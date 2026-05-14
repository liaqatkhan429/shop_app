import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

enum SplashState { loading, navigateToSetup, navigateToLogin, navigateToDashboard }

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService;
  final SessionService _sessionService;

  SplashState _state = SplashState.loading;
  SplashState get state => _state;

  SplashViewModel(this._authService, this._sessionService);

  Future<void> initialize() async {
    // Add artificial delay for the professional splash loading experience
    await Future.delayed(const Duration(seconds: 2));

    final isSetup = await _authService.isSetupComplete();
    
    if (!isSetup) {
      _state = SplashState.navigateToSetup;
    } else {
      final sessionRole = await _sessionService.getActiveSession();
      if (sessionRole != UserRole.none) {
         _state = SplashState.navigateToDashboard;
      } else {
         _state = SplashState.navigateToLogin;
      }
    }
    notifyListeners();
  }
}
