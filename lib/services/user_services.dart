import '../models/users_model.dart';
import '../repositories/users_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<void> addUser(UserModel user) =>
      _userRepository.addUser(user);

  Future<List<UserModel>> getUsers() =>
      _userRepository.getUsers();

  Future<void> updateUser(UserModel user) =>
      _userRepository.updateUser(user);

  Future<void> deleteUser(String id) =>
      _userRepository.deleteUser(id);
}