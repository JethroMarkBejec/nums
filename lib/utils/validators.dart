class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Accepts either an email address or a PH mobile number.
  static String? validateEmailOrPhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email or phone number is required';
    final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    final isPhone = RegExp(r'^(\+63|0)?9\d{9}$')
        .hasMatch(v.replaceAll(RegExp(r'[\s-]'), ''));
    if (!isEmail && !isPhone) return 'Enter a valid email or phone number';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
