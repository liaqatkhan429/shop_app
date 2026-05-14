abstract class AuthRepository {
  Future<void> saveAdminPin(String pin);
  Future<bool> verifyAdminPin(String pin);
  Future<bool> isAdminSetupComplete();
  Future<void> saveRecoveryCode(String code);
  Future<String?> getRecoveryCode();
  Future<bool> verifyRecoveryCode(String code);

  Future<void> deleteAdminPin();
}
