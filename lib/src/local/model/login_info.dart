class LoginInfo {
  String email;
  String password;

  LoginInfo({
    required this.email,
    required this.password,
  });

  bool get isNotEmpty {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
