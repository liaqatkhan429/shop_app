import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/views/forgot_password.dart';
import 'package:shop_app/views/user_screen.dart';

import '../viewmodels/forget_password_viewmodel.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/create_admin_pin_screen.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

import '../views/main_layout_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/products_screen.dart';
import '../views/customer_screen.dart';
import '../views/create_invoice_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();


  static bool canAccess(String path, UserRole role) {
    // public routes
    if (path == '/' ||
        path == '/login' ||
        path == '/create-admin-pin' ||
        path == '/forgot-password') {
      return true;
    }

    switch (path) {
      case '/users':
      case '/dashboard':
        return role == UserRole.admin;

      case '/create-invoice':
      case '/clients':
      case '/items':
        return role != UserRole.none;

      default:
        return false;
    }
  }

  static GoRouter buildRouter(
    AuthService authService,
    SessionService sessionService,
  ) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (BuildContext context, GoRouterState state) async {
        final isSplash = state.matchedLocation == '/';
        final isSetup = state.matchedLocation == '/create-admin-pin';
        final isLogin = state.matchedLocation == '/login';
        final role = await sessionService.getActiveSession();

        final path = state.uri.path;

        // block unauthorized access
        if (!canAccess(path, role)) {
          return '/create-invoice'; // or dashboard fallback
        }

        if (isSplash) return null;

        final isSetupComplete = await authService.isSetupComplete();
        if (!isSetupComplete && !isSetup) {
          return '/create-admin-pin';
        }

        if (isSetupComplete && isSetup) {
          return '/login';
        }

        final isProtectedRoute = !isSplash && !isSetup && !isLogin &&  state.matchedLocation != '/forgot-password';

        if (isProtectedRoute) {
          final activeSession = await sessionService.getActiveSession();
          if (activeSession == UserRole.none) {
            return '/login';
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/create-admin-pin',
          name: 'create_admin_pin',
          builder: (context, state) => const CreateAdminPinScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot_password',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => ForgotPasswordViewModel(context.read<AuthService>()),
            child: const ForgotPasswordScreen(),
          ),
        ),

        // Shell Route for Dashboard UI
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainLayoutScreen(child: child);
          },
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/create-invoice',
              name: 'create_invoice',
              builder: (context, state) => const CreateInvoiceScreen(),
            ),
            GoRoute(
              path: '/clients',
              name: 'clients',
              builder: (context, state) => const ClientsScreen(),
            ),
            GoRoute(
              path: '/items',
              name: 'items',
              builder: (context, state) => const ItemsScreen(),
            ),
            GoRoute(
              path: '/users',
              name: 'users',
              builder: (context, state) => const UsersScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
