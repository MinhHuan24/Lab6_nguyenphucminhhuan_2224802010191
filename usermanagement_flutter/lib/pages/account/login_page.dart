import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:usermanagement_flutter/models/login_model.dart';
import 'package:usermanagement_flutter/services/token_handler.dart';
import 'package:usermanagement_flutter/pages/admin/admin_main_page.dart';
import 'package:usermanagement_flutter/pages/users/users_main_page.dart';
import 'package:usermanagement_flutter/pages/account/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; });

    final url = Uri.parse('http://10.0.2.2:5218/api/account/login');
    
    try {
      final loginData = LoginModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData.toJson()),
      );

      setState(() { _isLoading = false; });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token'];

        TokenHandler().addToken(token);

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String? role = decodedToken['role'] ?? decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

        if (!mounted) return;

        if (role == 'Admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminMainPage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UsersMainPage()));
        }
      } else {
        _showError("Tài khoản hoặc mật khẩu không chính xác.");
      }
    } catch (e) {
      setState(() { _isLoading = false; });
      _showError("Lỗi kết nối máy chủ API! Hãy chắc chắn bạn đã chạy lệnh 'dotnet run'.");
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Đăng nhập thất bại"),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng Nhập Hệ Thống"), centerTitle: true, backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Vui lòng nhập email" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Vui lòng nhập mật khẩu" : null,
              ),
              const SizedBox(height: 24),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue),
                    child: const Text("ĐĂNG NHẬP", style: TextStyle(color: Colors.white)),
                  ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                child: const Text("Chưa có tài khoản? Đăng ký ngay"),
              )
            ],
          ),
        ),
      ),
    );
  }
}