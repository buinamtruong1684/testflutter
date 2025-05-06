import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Task_Provider.dart'; // Nhớ import đúng
import 'Task_List_Screen.dart'; // Nhớ import đúng màn hình danh sách task

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _username = '';
  String _password = '';

  void _submit(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      bool success = false;

      if (_isLogin) {
        success = provider.login(_username, _password);
        if (!success) {
          _showMessage(context, 'Đăng nhập thất bại. Kiểm tra tài khoản hoặc mật khẩu.');
          return;
        }
      } else {
        success = provider.register(_username, _password);
        if (!success) {
          _showMessage(context, 'Tên đăng nhập đã tồn tại.');
          return;
        } else {
          _showMessage(context, 'Đăng ký thành công. Mời đăng nhập.');
          setState(() {
            _isLogin = true;
          });
          return;
        }
      }

      // Đăng nhập thành công -> chuyển sang màn hình task
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TaskListScreen()),
      );
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Đăng nhập' : 'Đăng ký'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên đăng nhập'),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên' : null,
                onChanged: (value) => _username = value,
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
                onChanged: (value) => _password = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submit(context),
                child: Text(_isLogin ? 'Đăng nhập' : 'Đăng ký'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin ? 'Chưa có tài khoản? Đăng ký ngay' : 'Đã có tài khoản? Đăng nhập',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
