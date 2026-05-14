import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { admin, user, none }

class SessionService {
  static const String _sessionRoleKey = 'session_role';
  static const String _sessionTimeKey = 'session_time';
  
  // Timeout for session (e.g., 12 hours)
  static const int _sessionTimeoutHours = 12;

  Future<void> startSession(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionRoleKey, role.toString());
    await prefs.setInt(_sessionTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionRoleKey);
    await prefs.remove(_sessionTimeKey);
  }

  Future<UserRole> getActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_sessionRoleKey);
    final timeStr = prefs.getInt(_sessionTimeKey);

    if (roleString == null || timeStr == null) return UserRole.none;

    final sessionTime = DateTime.fromMillisecondsSinceEpoch(timeStr);
    final now = DateTime.now();

    if (now.difference(sessionTime).inHours >= _sessionTimeoutHours) {
      await clearSession();
      return UserRole.none;
    }

    if (roleString == UserRole.admin.toString()) return UserRole.admin;
    if (roleString == UserRole.user.toString()) return UserRole.user;

    return UserRole.none;
  }

  static const String _activeUserIdKey = 'active_user_id';

  Future<void> saveActiveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_activeUserIdKey, userId);
  }
}
