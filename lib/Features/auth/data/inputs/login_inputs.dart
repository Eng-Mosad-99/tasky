class LoginInput {
  final String phone;
  final String password;

  LoginInput({required this.phone, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'phone': phone,
    };
  }
}
