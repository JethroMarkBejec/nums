import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final Map<String, ({String name, String password})> _accounts = {
    'welcome@nums.com': (name: 'Cookie Lover', password: 'cookies123'),
  };

  bool _isAuthenticated = false;
  String? _email;
  String? _username;

  bool get isAuthenticated => _isAuthenticated;
  String? get email => _email;
  String? get username => _username;

  bool signIn({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null || account.password != password) return false;
    _setSession(normalizedEmail, account.name);
    return true;
  }

  bool signUp(
      {required String name, required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) return false;
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || normalizedEmail.isEmpty || password.length < 6) {
      return false;
    }
    _accounts[normalizedEmail] = (name: trimmedName, password: password);
    _setSession(normalizedEmail, trimmedName);
    return true;
  }

  void _setSession(String email, String name) {
    _email = email;
    _username = name;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _email = null;
    _username = null;
    notifyListeners();
  }
}
