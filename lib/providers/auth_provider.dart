import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final Map<String, ({String name, String password, String role})> _accounts = {
    'welcome@nums.com': (
      name: 'Cookie Lover',
      password: 'cookies123',
      role: 'customer',
    ),
    'staff@nums.com': (
      name: 'NUMS Staff',
      password: 'staff123',
      role: 'admin',
    ),
  };

  AppUser? _currentUser;

  bool get isAuthenticated => _currentUser != null;
  String? get email => _currentUser?.email;
  String? get username => _currentUser?.name;
  String? get role => _currentUser?.role;
  AppUser? get currentUser => _currentUser;

  bool signIn({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null || account.password != password) return false;
    _setSession(normalizedEmail, account.name, account.role);
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
    _accounts[normalizedEmail] = (
      name: trimmedName,
      password: password,
      role: 'customer',
    );
    _setSession(normalizedEmail, trimmedName, 'customer');
    return true;
  }

  void _setSession(String email, String name, String role) {
    _currentUser = AppUser(
      id: email,
      name: name,
      email: email,
      role: role,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
