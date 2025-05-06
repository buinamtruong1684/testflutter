// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import '../models/User.dart';
import '../api/user_api_service.dart';

class AuthController with ChangeNotifier {
  final UserApiService _userApiService = UserApiService();
  User? _user;

  User? get user => _user;

  Future<bool> registerWithPassword(User user, String password) async {
    try {
      final newUser = await _userApiService.createUser(user, password);
      if (newUser != null) {
        _user = newUser;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi đăng ký: $e');
      return false;
    }
  }

  Future<bool> loginWithPassword(String username, String password) async {
    try {
      final loggedInUser = await _userApiService.login(username, password);
      if (loggedInUser != null) {
        _user = loggedInUser;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
