import 'package:flutter/foundation.dart';

class PaymentAccountProvider extends ChangeNotifier {
  final Map<String, Map<String, String>> _accounts = {};

  Map<String, String>? accountFor(String email) {
    final value = _accounts[email.trim().toLowerCase()];
    return value == null ? null : Map.unmodifiable(value);
  }

  String mask(String number) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7) return 'Not linked';
    return '${digits.substring(0, 4)} *** ${digits.substring(digits.length - 4)}';
  }

  bool save(String email, String method, String number) {
    final key = email.trim().toLowerCase();
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (key.isEmpty || !['GCash', 'Maya', 'Cash'].contains(method))
      return false;
    final previous = _accounts[key];
    if (method != 'Cash' && digits.isEmpty && previous?['method'] == method)
      return true;
    if (method != 'Cash' && digits.length < 10) return false;
    _accounts[key] = {
      'method': method,
      'number': method == 'Cash' ? '' : mask(digits)
    };
    notifyListeners();
    return true;
  }
}
