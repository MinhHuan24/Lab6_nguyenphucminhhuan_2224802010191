import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:usermanagement_flutter/models/user_model.dart';
import 'assign_role.dart';

class GetUsersPage extends StatefulWidget {
  const GetUsersPage({super.key});

  @override
  State<GetUsersPage> createState() => _GetUsersPageState();
}

class _GetUsersPageState extends State<GetUsersPage> {
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final url = Uri.parse('http://10.0.2.2:5218/api/account/users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _users = data.map((json) => UserModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi tải danh sách người dùng!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản Lý Người Dùng"), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.email.isNotEmpty ? user.email[0].toUpperCase() : "?")),
                title: Text(user.email),
                subtitle: Text("Quyền: ${user.role?.join(', ') ?? 'Chưa duyệt'}"),
                trailing: const Icon(Icons.edit, color: Colors.blue),
                onTap: () async {
                  final result = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AssignRolePage(user: user))
                  );
                  if (result == true) _fetchUsers(); // Tải lại danh sách nếu có thay đổi vai trò
                },
              );
            },
          ),
    );
  }
}