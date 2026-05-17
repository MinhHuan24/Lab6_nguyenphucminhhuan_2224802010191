import 'package:flutter/material.dart';
import '../../services/roll_check.dart';
import '../../services/token_handler.dart';
import '../account/login_page.dart';

class UsersMainPage extends StatefulWidget {
  const UsersMainPage({super.key});

  @override
  State<UsersMainPage> createState() => _UsersMainPageState();
}

class _UsersMainPageState extends State<UsersMainPage> {
  @override
  void initState() {
    super.initState();
    RollCheck.checkUserRoll(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("USER DASHBOARD"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              TokenHandler().clearToken();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Đăng nhập thành công với vai trò Thành Viên Hệ Thống!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}