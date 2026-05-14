import 'package:flutter/cupertino.dart';

import '../models/users_model.dart';
import '../services/user_services.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;

  UserViewModel(this._userService);

  // ───────────────── DATA ─────────────────
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  UserModel? _editingUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  bool _isLoading = false;

  List<UserModel> get users =>
      _filteredUsers.isEmpty ? _users : _filteredUsers;

  UserModel? get editingUser => _editingUser;

  bool get isLoading => _isLoading;

  String? nameError;
  String? pinError;

  bool validate() {

    // Name validation
    if (nameController.text.trim().isEmpty) {
      nameError = "Name is required";
    } else {
      nameError = null;
    }

    // PIN validation
    if (pinController.text.trim().isEmpty) {
      pinError = "PIN is required";
    } else if (pinController.text.length < 6) {
      pinError = "PIN must be 6 digits";
    } else if (pinController.text.length > 6) {
      pinError = "PIN cannot exceed 6 digits";
    } else {
      pinError = null;
    }

    notifyListeners();

    return nameError == null && pinError == null;
  }

  // ───────────────── LOAD USERS ─────────────────
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    _users = await _userService.getUsers();
    _filteredUsers = [];

    _isLoading = false;
    notifyListeners();
  }

  // ───────────────── ADD USER ─────────────────
  Future<void> addUser() async {
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      pin: pinController.text,
      createdAt: DateTime.now(),
    );

    await _userService.addUser(user);

    clearForm();
    await loadUsers();
  }

  // ───────────────── UPDATE USER ─────────────────
  Future<void> updateUser() async {
    if (_editingUser == null) return;

    final updated = _editingUser!.copyWith(
      name: nameController.text,
      pin: pinController.text,
    );

    await _userService.updateUser(updated);

    clearForm();
    await loadUsers();
  }

  // ───────────────── DELETE USER ─────────────────
  Future<void> deleteUser(String id) async {
    await _userService.deleteUser(id);
    await loadUsers();
  }

  // ───────────────── EDIT MODE START ─────────────────
  void startEditUser(UserModel user) {
    _editingUser = user;

    nameController.text = user.name;
    pinController.text = user.pin;

    notifyListeners();
  }

  // ───────────────── CLEAR FORM ─────────────────
  void clearForm() {
    _editingUser = null;
    nameController.clear();
    pinController.clear();
    notifyListeners();
  }

  // ───────────────── SEARCH ─────────────────
  void searchUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = [];
    } else {
      _filteredUsers = _users
          .where((u) =>
          u.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}