import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService;

  String _recoveryCode = '';

  bool _isLoading = false;
  String? _errorMessage;

  ForgotPasswordViewModel(this._authService);

  String get recoveryCode => _recoveryCode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setRecoveryCode(String code) {
    _recoveryCode = code;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> verifyRecoveryCode() async {
    if (_recoveryCode.trim().isEmpty) {
      _errorMessage = 'Recovery code is required.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isValid =
          await _authService.verifyRecoveryCode(_recoveryCode);

      if (!isValid) {
        _isLoading = false;
        _errorMessage = 'Invalid recovery code.';
        notifyListeners();
        return false;
      }

      // Delete old admin PIN after successful verification
      await _authService.deleteOldAdminPin();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Something went wrong.';
      notifyListeners();
      return false;
    }
  }
}
