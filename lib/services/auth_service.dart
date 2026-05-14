import 'dart:math';
import 'package:shop_app/repositories/users_repository.dart';

import 'session_service.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final SessionService _sessionService;

  AuthService(this._authRepository, this._sessionService, this._userRepository);

  Future<bool> isSetupComplete() async {
    return await _authRepository.isAdminSetupComplete();
  }

  Future<String> setupAdmin(String pin) async {
    // Save the new admin PIN
    await _authRepository.saveAdminPin(pin);

    // Generate a recovery code
    final random = Random.secure();
    final recoveryCode = List.generate(4, (_) => (random.nextInt(9000) + 1000).toString()).join('-');
    
    await _authRepository.saveRecoveryCode(recoveryCode);
    
    return recoveryCode;
  }

  Future<bool> loginAdmin(String pin) async {
    final isValid = await _authRepository.verifyAdminPin(pin);
    if (isValid) {
      await _sessionService.startSession(UserRole.admin);
      return true;
    }
    return false;
  }

  Future<bool> loginUser(String pin) async {

    final users = await _userRepository.getUsers();

    print("========== LOGIN DEBUG ==========");
    print("ENTERED PIN: $pin");
    print("TOTAL USERS: ${users.length}");

    for (var u in users) {
      print("USER => ${u.name} | PIN => ${u.pin}");
    }

    try {

      final user = users.firstWhere(
            (u) => u.pin.trim() == pin.trim(),
      );

      print("MATCH FOUND => ${user.name}");

      await _sessionService.startSession(UserRole.user);

      await _sessionService.saveActiveUserId(user.id);

      return true;

    } catch (e) {

      print("NO USER FOUND");

      return false;
    }
  }
  Future<void> logout() async {
    await _sessionService.clearSession();
  }

  

   Future<bool> verifyRecoveryCode(String code) async {
    return await _authRepository.verifyRecoveryCode(code);
  }

  Future<void> deleteOldAdminPin() async {
    await _authRepository.deleteAdminPin();
  }
}
