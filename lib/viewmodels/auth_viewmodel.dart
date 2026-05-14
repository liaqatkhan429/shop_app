import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  UserRole _selectedRole = UserRole.admin;
  String _pin = '';
  
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this._authService);

  UserRole get selectedRole => _selectedRole;
  String get pin => _pin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setSelectedRole(UserRole role) {
    if (_selectedRole != role) {
      _selectedRole = role;
      _pin = '';
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setPin(String pin) {
    _pin = pin;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login() async {
    if (_pin.length != 6) {
      _errorMessage = 'PIN must be exactly 6 digits.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    bool success = false;

    if (_selectedRole == UserRole.admin) {
      success = await _authService.loginAdmin(_pin);
    } else {
      success = await _authService.loginUser(_pin);
    }

    _isLoading = false;

    if (!success) {
      _errorMessage = 'Wrong PIN';
      notifyListeners();
      return false;   // 🔥 MUST STOP HERE
    }

    notifyListeners();
    return true;
  }
}
