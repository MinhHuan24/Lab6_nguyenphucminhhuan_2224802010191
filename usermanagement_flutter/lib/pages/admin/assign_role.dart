import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:usermanagement_flutter/models/user_model.dart';

class AssignRolePage extends StatefulWidget {
  final UserModel user;
  const AssignRolePage({super.key, required this.user});

  @override
  State<AssignRolePage> createState() => _AssignRolePageState();
}

class _AssignRolePageState extends State<AssignRolePage> {
  String? _selectedRole;
  bool _isUpdating = false; 
  final List<String> _availableRoles = ["Admin", "User", "Student"];

  @override
  void initState() {
    super.initState();
    String? userRole = widget.user.role?.isNotEmpty == true ? widget.user.role![0] : "User";
    if (userRole.isNotEmpty) {
      userRole = userRole[0].toUpperCase() + userRole.substring(1).toLowerCase();
    }
    if (_availableRoles.contains(userRole)) {
      _selectedRole = userRole;
    } else {
      _selectedRole = "User"; 
    }
  }

  // Hàm xử lý gọi API kết nối đến SQL Server qua Backend
  Future<void> _updateUserRole() async {
    setState(() {
      _isUpdating = true;
    });
    final url = Uri.parse('http://10.0.2.2:5218/api/account/update-role');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.user.email,
          "newRole": _selectedRole, 
        }),
      );

      setState(() {
        _isUpdating = false;
      });

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đã cập nhật quyền tài khoản thành $_selectedRole thành công!")),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cập nhật vai trò thất bại từ phía hệ thống!")),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi kết nối máy chủ: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cấp Quyền Thành Viên"), 
        backgroundColor: Colors.blue, 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tài khoản: ${widget.user.email}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Chọn vai trò mới phù hợp:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _availableRoles.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (val) { 
                setState(() { _selectedRole = val; }); 
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            
            const SizedBox(height: 30),
            _isUpdating 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), 
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _updateUserRole, 
                  child: const Text("CẬP NHẬT VAI TRÒ", style: TextStyle(color: Colors.white)),
                ),
          ],
        ),
      ),
    );
  }
}