import 'package:flutter/material.dart';
import 'add_role.dart';

class GetRolesPage extends StatefulWidget {
  const GetRolesPage({super.key});

  @override
  State<GetRolesPage> createState() => _GetRolesPageState();
}

class _GetRolesPageState extends State<GetRolesPage> {
  // Danh sách Role chuẩn cấu hình của phân quyền Backend
  final List<String> _roles = ["Admin", "User", "Student"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vai Trò Hệ Thống"), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.gavel, color: Colors.orange),
            title: Text(_roles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.verified, color: Colors.green),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRolePage()));
        },
      ),
    );
  }
}