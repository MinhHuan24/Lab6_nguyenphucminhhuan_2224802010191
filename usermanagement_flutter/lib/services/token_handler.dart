class TokenHandler {
  TokenHandler._internal();
  static final TokenHandler _instance = TokenHandler._internal();
  factory TokenHandler() => _instance;

  String _jwtToken = "";

  void addToken(String token) {
    if (token.isNotEmpty) _jwtToken = token;
  }

  String getToken() => _jwtToken;
  void clearToken() => _jwtToken = "";
}