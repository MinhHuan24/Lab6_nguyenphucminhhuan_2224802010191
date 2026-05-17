import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });

    final url = Uri.parse('http://10.0.2.2:5218/api/account/register');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        })
      );

      setState(() { _isLoading = false; });

      if (response.statusCode == 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thêm tài khoản thành công!")));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm Người Dùng"), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email tài khoản", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Vui lòng nhập Email" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu khởi tạo", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.length < 6) ? "Mật khẩu phải từ 6 ký tự" : null,
              ),
              const SizedBox(height: 24),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addUser,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green),
                    child: const Text("TẠO TÀI KHOẢN", style: TextStyle(color: Colors.white)),
                  )
            ],
          ),
        ),
      ),
    );
  }
}