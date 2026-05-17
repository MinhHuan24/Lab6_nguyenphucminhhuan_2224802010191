import 'package:flutter/material.dart';

class UnknownRolesPage extends StatelessWidget {
  const UnknownRolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cảnh Báo Quyền"), backgroundColor: Colors.grey),
      body: const Center(
        child: Text("Tài khoản của bạn chưa được cấp quyền để truy cập hệ thống này."),
      ),
    );
  }
}