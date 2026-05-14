import 'auth_repository.dart';
import '../data/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveAdminPin(String pin) async {
    await _localDataSource.saveAdminPin(pin);
  }

  @override
  Future<bool> verifyAdminPin(String pin) async {
    final storedPin = await _localDataSource.getAdminPin();
    return storedPin == pin;
  }

  @override
  Future<bool> isAdminSetupComplete() async {
    return await _localDataSource.isAdminPinSet();
  }

  @override
  Future<void> saveRecoveryCode(String code) async {
    await _localDataSource.saveRecoveryCode(code);
  }

  @override
  Future<String?> getRecoveryCode() async {
    return await _localDataSource.getRecoveryCode();
  }

   @override
  Future<bool> verifyRecoveryCode(String code) async {
    final savedCode = await _localDataSource.getRecoveryCode();

    return savedCode == code;
  }

  @override
  Future<void> deleteAdminPin() async {
    await _localDataSource.deleteAdminPin();
  }
}
