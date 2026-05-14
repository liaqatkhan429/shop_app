import '../models/users_model.dart';

abstract class UserRepository {
  Future<void> addUser(UserModel user);
  Future<List<UserModel>> getUsers();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}