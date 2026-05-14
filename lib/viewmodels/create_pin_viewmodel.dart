import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class CreatePinViewModel extends ChangeNotifier {
  final AuthService _authService;

  String _initialPin = '';
  String _confirmPin = '';
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _recoveryCode;

  CreatePinViewModel(this._authService);

  String get initialPin => _initialPin;
  String get confirmPin => _confirmPin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get recoveryCode => _recoveryCode;

  void setInitialPin(String pin) {
    _initialPin = pin;
    _errorMessage = null;
    notifyListeners();
  }

  void setConfirmPin(String pin) {
    _confirmPin = pin;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> createAdminPin() async {
    if (_initialPin.length != 6 || _confirmPin.length != 6) {
      _errorMessage = 'PIN must be exactly 6 digits.';
      notifyListeners();
      return false;
    }

    if (_initialPin != _confirmPin) {
      _errorMessage = 'PIN DOES NOT MATCH';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Setup the admin via service and get recovery code
      _recoveryCode = await _authService.setupAdmin(_initialPin);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to save PIN. Please try again.';
      notifyListeners();
      return false;
    }
  }
}
