class RegisterInputs {
  final String password;
  final String displayName;
  final String experienceYears;
  final String phone;
  final String address;
  final String level;

  RegisterInputs({
    required this.password,
    required this.phone,
    required this.address,
    required this.displayName,
    required this.experienceYears,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'phone': phone,
      'address': address,
      'displayName': displayName,
      'experienceYears': experienceYears,
      'level': level
    };
  }
}
