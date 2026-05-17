import 'package:flutter/material.dart';
import '../../services/roll_check.dart';
import '../../services/token_handler.dart';
import '../account/login_page.dart';
import 'get_users.dart';
import 'get_roles.dart';
import 'add_user.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  @override
  void initState() {
    super.initState();
    RollCheck.checkAdminRoll(context);
  }

  void _logout() {
    TokenHandler().clearToken();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN MANAGEMENT PANEL"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuButton(context, "DANH SÁCH NGƯỜI DÙNG", Icons.supervised_user_circle, Colors.blue, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const GetUsersPage()));
          }),
          _buildMenuButton(context, "THÊM MỚI TÀI KHOẢN", Icons.person_add, Colors.green, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUserPage()));
          }),
          _buildMenuButton(context, "VAI TRÒ HỆ THỐNG", Icons.admin_panel_settings, Colors.orange, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const GetRolesPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: Card(
        color: color.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}