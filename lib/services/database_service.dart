import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/users_model.dart';

class DatabaseService {
  static const String _usersBox = 'users';
  static const String _productsBox = 'products';
  static const String _customersBox = 'customer';
  static const String _invoicesBox = 'invoices';
  static const String _settingsBox = 'settings';

  Future<void> init() async {
    final appDocumentDirectory =
    await getApplicationDocumentsDirectory();

    await Hive.initFlutter(appDocumentDirectory.path);

    await Hive.openBox(_usersBox);
    await Hive.openBox(_productsBox);
    await Hive.openBox(_customersBox);
    await Hive.openBox(_invoicesBox);
    await Hive.openBox(_settingsBox);
  }

  // ───────────────── USERS CRUD ─────────────────

  Box get _users => Hive.box(_usersBox);

  Future<void> addUser(UserModel user) async {
    await _users.put(user.id, user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    return _users.values
        .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> updateUser(UserModel user) async {
    await _users.put(user.id, user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await _users.delete(id);
  }

  // Optional single user
  Future<UserModel?> getUser(String id) async {
    final data = _users.get(id);
    if (data == null) return null;

    return UserModel.fromMap(
      Map<String, dynamic>.from(data),
    );
  }


  // ───────────────── BOX ACCESS ─────────────────

  Box getUsersBox() => Hive.box(_usersBox);
  Box getProductsBox() => Hive.box(_productsBox);
  Box getCustomersBox() => Hive.box(_customersBox);
  Box getInvoicesBox() => Hive.box(_invoicesBox);
  Box getSettingsBox() => Hive.box(_settingsBox);
}
