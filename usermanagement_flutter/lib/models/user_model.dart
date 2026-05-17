class UserModel {
  final String id;
  final String email;
  final String? phoneNumber;
  final List<String>? role;

  const UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Xử lý chuyển đổi danh sách Role từ API động (.NET claim dạng list hoặc string)
    List<String>? parsedRoles;
    if (json['roles'] != null) {
      parsedRoles = List<String>.from(json['roles']);
    } else if (json['role'] != null) {
      parsedRoles = [json['role'].toString()];
    }

    return UserModel(
      id: json['id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      role: parsedRoles,
    );
  }
}