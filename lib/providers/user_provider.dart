// lib/providers/user_provider.dart
// Provider that manages current logged-in user (stores user id + email).
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/DatabaseHelper.dart';

class UserProvider extends ChangeNotifier {
  int? _userId;
  String? _email;

  int? get userId => _userId;
  String? get email => _email;
  bool get isLoggedIn => _userId != null;

  // Load user id from shared_preferences if present
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (id != null) {
      final row = await DatabaseHelper.instance.getUserById(id);
      if (row != null) {
        _userId = id;
        _email = row['email'] as String?;
        notifyListeners();
      } else {
        // inconsistency: remove saved id
        await prefs.remove('user_id');
      }
    }
  }

  // Login or register: if user exists, verify password; if not, create user.
  // Returns null on success, or error message on failure.
  Future<String?> loginOrRegister({required String email, required String password}) async {
    final db = DatabaseHelper.instance;
    final existing = await db.getUserByEmail(email);
    if (existing == null) {
      // create new user
      try {
        final id = await db.createUser(email: email, password: password);
        await _saveSession(userId: id, email: email);
        return null;
      } catch (e) {
        return 'Could not create user: $e';
      }
    } else {
      final storedPassword = existing['password'] as String?;
      if (storedPassword == password) {
        final id = existing['id'] as int;
        await _saveSession(userId: id, email: email);
        return null;
      } else {
        return 'Invalid credentials';
      }
    }
  }

  Future<void> _saveSession({required int userId, required String email}) async {
    _userId = userId;
    _email = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    notifyListeners();
  }

  Future<void> logout() async {
    _userId = null;
    _email = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    notifyListeners();
  }
}
