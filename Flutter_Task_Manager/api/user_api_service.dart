import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';
import '../config/ApiConfig.dart'; // Import file chứa baseUrl

class UserApiService {
  final String _baseUrl = ApiConfig.baseUrl + '/users'; // URL base

  // Phương thức đăng nhập
  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Phương thức đăng nhập với Google
  Future<User?> loginWithGoogle(String googleToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login/google'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'token': googleToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to login with Google');
    }
  }

  // Phương thức đăng nhập với Facebook
  Future<User?> loginWithFacebook(String facebookToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login/facebook'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'token': facebookToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to login with Facebook');
    }
  }

  // Phương thức đăng ký người dùng
  Future<User?> createUser(User user, String password) async {
    final Map<String, dynamic> requestBody = user.toJson();
    requestBody['password'] = password;

    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to create user');
    }
  }
}

