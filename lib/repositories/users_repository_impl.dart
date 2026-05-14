import 'package:shop_app/repositories/users_repository.dart';
import 'package:shop_app/services/user_services.dart';

import '../models/users_model.dart';
import '../services/database_service.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseService _databaseService;

  UserRepositoryImpl(this._databaseService);

  @override
  Future<void> addUser(UserModel user) async {
    await _databaseService.addUser(user);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    return await _databaseService.getUsers();
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _databaseService.updateUser(user);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _databaseService.deleteUser(id);
  }
}