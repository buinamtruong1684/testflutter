import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/Account.dart';

class AccountAPIService {
  static final AccountAPIService instance = AccountAPIService._init();
  final String baseUrl = 'https://my-json-server.typicode.com/buinamtruong1684/testflutter';
  AccountAPIService._init();

  Future<Account?> login(String username, String password) async {
    final response = await http.get(Uri.parse('$baseUrl/accounts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Account> accounts = jsonList.map((json) => Account.fromMap(json)).toList();

      try {
        final account = accounts.firstWhere((acc) =>
        acc.username == username &&
            acc.password == password &&
            acc.status == 'active');

        // Cập nhật lastLogin
        account.lastLogin = DateTime.now().toIso8601String();
        await updateAccount(account);

        return account;
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  Future<Account> updateAccount(Account account) async {
    final response = await http.put(
      Uri.parse('$baseUrl/accounts/${account.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(account.toMap()),
    );

    if (response.statusCode == 200) {
      return Account.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update account');
    }
  }
}
