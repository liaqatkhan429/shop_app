import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/repositories/auth_repository_impl.dart';
import 'package:shop_app/repositories/customer_repository_impl.dart';
import 'package:shop_app/repositories/product_repository_impl.dart';
import 'package:shop_app/repositories/users_repository_impl.dart';
import 'package:shop_app/routes/app_router.dart';
import 'package:shop_app/services/auth_service.dart';
import 'package:shop_app/services/customer_services.dart';
import 'package:shop_app/services/database_service.dart';
import 'package:shop_app/services/product_services.dart';
import 'package:shop_app/services/secure_storage_service.dart';
import 'package:shop_app/services/session_service.dart';
import 'package:shop_app/services/user_services.dart';
import 'package:shop_app/viewmodels/auth_viewmodel.dart';
import 'package:shop_app/viewmodels/create_pin_viewmodel.dart';
import 'package:shop_app/viewmodels/customer_viewmodel.dart';
import 'package:shop_app/viewmodels/products_viewmodel.dart';
import 'package:shop_app/viewmodels/sidebar_viewmodel.dart';
import 'package:shop_app/viewmodels/splash_viewmodel.dart';

import 'data/auth_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ───────────────── CORE SERVICES ─────────────────
  final databaseService = DatabaseService();
  await databaseService.init();

  final secureStorageService = SecureStorageService();
  final sessionService = SessionService();

  // ───────────────── AUTH LAYER ─────────────────
  final authLocalDataSource =
  AuthLocalDataSource(secureStorageService);

  final authRepository =
  AuthRepositoryImpl(authLocalDataSource);

  // ───────────────── USER LAYER ─────────────────
  final userRepository =
  UserRepositoryImpl(databaseService);

  final userService =
  UserService(userRepository);

  // ───────────────── PRODUCT LAYER ─────────────────

final productRepository =
  ProductRepositoryImpl(databaseService);

  final productService =
  ProductService(productRepository);

  //
  final authService =
  AuthService(authRepository, sessionService, userRepository);

  ///////////// CUSTOMER
  final customerRepository =
  CustomerRepositoryImpl(databaseService);

  final customerService =
  CustomerService(customerRepository);

  // //
  // final storage = FlutterSecureStorage();
  //
  // await storage.deleteAll();
  //await Hive.deleteBoxFromDisk('products');
  runApp(
    MultiProvider(
      providers: [
        // ───────── SERVICES ─────────
        Provider<AuthService>.value(value: authService),
        Provider<SessionService>.value(value: sessionService),
        Provider<UserService>.value(value: userService),
        Provider<ProductService>.value(value: productService),
        Provider<CustomerService>.value(value: customerService,),

        // ───────── VIEWMODELS ─────────
        ChangeNotifierProvider(
          create: (_) => SplashViewModel(authService, sessionService),
        ),

        ChangeNotifierProvider(
          create: (_) => CreatePinViewModel(authService),
        ),

        ChangeNotifierProvider(
          create: (_) => ProductViewModel(productService),
        ),


        ChangeNotifierProvider(
          create: (_) => CustomerViewModel(customerService),
        ),

        ChangeNotifierProvider(
          create: (_) => SidebarViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            context.read<AuthService>(),
          ),
        ),
      ],
      child: const BuildMaxApp(),
    ),
  );
}

class BuildMaxApp extends StatelessWidget {
  const BuildMaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We retrieve the services once to build the router.
    // GoRouter will handle internal navigation based on these services.
    final authService = Provider.of<AuthService>(context, listen: false);
    final sessionService = Provider.of<SessionService>(context, listen: false);

    final router = AppRouter.buildRouter(authService, sessionService);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
