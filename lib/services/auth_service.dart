class AuthService {
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return email.isNotEmpty && password.isNotEmpty;
  }

  Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return name.isNotEmpty && email.isNotEmpty && password.length >= 6;
  }
}
