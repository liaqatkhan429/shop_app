import '../services/secure_storage_service.dart';

class AuthLocalDataSource {
  final SecureStorageService _secureStorage;

  AuthLocalDataSource(this._secureStorage);

  Future<void> saveAdminPin(String pin) async {
    await _secureStorage.saveAdminPin(pin);
  }

  Future<String?> getAdminPin() async {
    return await _secureStorage.getAdminPin();
  }

  Future<bool> isAdminPinSet() async {
    return await _secureStorage.isAdminPinSet();
  }

  Future<void> saveRecoveryCode(String code) async {
    await _secureStorage.saveRecoveryCode(code);
  }

  Future<String?> getRecoveryCode() async {
    return await _secureStorage.getRecoveryCode();
  }

   Future<void> deleteAdminPin() async {
    await _secureStorage.clearAll();
  }
}
