import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  
  static const String _adminPinKey = 'admin_pin';
  static const String _recoveryCodeKey = 'recovery_code';

  Future<void> saveAdminPin(String pin) async {
    await _storage.write(key: _adminPinKey, value: pin);
  }

  Future<String?> getAdminPin() async {
    return await _storage.read(key: _adminPinKey);
  }

  Future<bool> isAdminPinSet() async {
    final pin = await getAdminPin();
    return pin != null && pin.isNotEmpty;
  }

  Future<void> saveRecoveryCode(String code) async {
    await _storage.write(key: _recoveryCodeKey, value: code);
  }

  Future<String?> getRecoveryCode() async {
    return await _storage.read(key: _recoveryCodeKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
