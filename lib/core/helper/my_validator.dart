class MyValidators {
  static String? displayNamevalidator(String? displayName,
      {int minLenth = 3, int maxLenth = 20}) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < minLenth || displayName.length > maxLenth) {
      return 'Display name must be between 3 and 20 characters';
    }

    return null; // Return null if display name is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? confirmPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? currentPasswordValidator({
    required String? value,
    required String currentPassword,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    if (value != currentPassword) {
      return 'Incorrect current password';
    }
    return null;
  }

  static String? yearsOfExperienceValidator(String? value,
      {int minYears = 0, int maxYears = 50}) {
    if (value == null || value.isEmpty) {
      return 'Years of experience cannot be empty';
    }
    final num? years = num.tryParse(value);
    if (years == null) {
      return 'Please enter a valid number';
    }
    if (years < minYears || years > maxYears) {
      return 'Years of experience must be between $minYears and $maxYears';
    }
    return null; // Return null if input is valid
  }
}
