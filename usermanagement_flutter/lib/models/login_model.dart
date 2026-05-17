class LoginModel {
  final String email;
  final String password;

  // Constructor chuẩn để tạo đối tượng dữ liệu đăng nhập
  const LoginModel({
    required this.email,
    required this.password,
  });

  // Hàm chuyển đổi dữ liệu cấu trúc Map phục vụ jsonEncode bên Login Page
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}