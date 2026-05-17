import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Ép cấu trúc Package Import để hệ thống quét chính xác tuyệt đối vị trí file
import 'package:usermanagement_flutter/services/token_handler.dart';
import 'package:usermanagement_flutter/pages/account/login_page.dart';

class RollCheck {
  static void checkAdminRoll(BuildContext context) {
    String token = TokenHandler().getToken();
    
    if (token.isEmpty || JwtDecoder.isExpired(token)) {
      _redirectToLogin(context);
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String? role = decodedToken['role'] ?? decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

    if (role != 'Admin') {
      _redirectToLogin(context);
    }
  }

  static void checkUserRoll(BuildContext context) {
    String token = TokenHandler().getToken();
    
    if (token.isEmpty || JwtDecoder.isExpired(token)) {
      _redirectToLogin(context);
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String? role = decodedToken['role'] ?? decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

    if (role != 'User' && role != 'Student') {
      _redirectToLogin(context);
    }
  }

  static void _redirectToLogin(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }
}