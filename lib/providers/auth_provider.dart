import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final Map<String, ({String name, String password, String role, int points})>
      _accounts = {
    'welcome@nums.com': (
      name: 'Cookie Lover',
      password: 'cookies123',
      role: 'customer',
      points: 0,
    ),
    'staff@nums.com': (
      name: 'NUMS Staff',
      password: 'staff123',
      role: 'admin',
      points: 0,
    ),
  };

  AppUser? _currentUser;

  bool get isAuthenticated => _currentUser != null;
  String? get email => _currentUser?.email;
  String? get username => _currentUser?.name;
  String? get role => _currentUser?.role;
  AppUser? get currentUser => _currentUser;
  int? pointsForAccount(String email) =>
      _accounts[email.trim().toLowerCase()]?.points;

  bool signIn({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null || account.password != password) return false;
    _setSession(normalizedEmail, account.name, account.role, account.points);
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
      points: 0,
    );
    _setSession(normalizedEmail, trimmedName, 'customer', 0);
    return true;
  }

  void _setSession(String email, String name, String role, int points) {
    _currentUser = AppUser(
      id: email,
      name: name,
      email: email,
      role: role,
      points: points,
    );
    notifyListeners();
  }

  /// Updates the local user record; award and redemption rules belong in
  /// PointsRepository, which validates changes before calling this method.
  bool setPointsBalance(String email, int points) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null || points < 0) return false;
    _accounts[normalizedEmail] = (
      name: account.name,
      password: account.password,
      role: account.role,
      points: points,
    );
    if (_currentUser?.email == normalizedEmail) {
      _currentUser = _currentUser!.copyWith(points: points);
    }
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
