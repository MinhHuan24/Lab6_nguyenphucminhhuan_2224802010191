import 'package:flutter/material.dart';

class AddRolePage extends StatelessWidget {
  const AddRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final roleController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Thêm Vai Trò Mới"), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: "Tên vai trò (Ví dụ: Giáo viên)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.orange),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tính năng yêu cầu quyền DbAdmin cấp cao!")));
                Navigator.pop(context);
              },
              child: const Text("XÁC NHẬN THÊM", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}