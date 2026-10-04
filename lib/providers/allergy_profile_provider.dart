import 'package:flutter/foundation.dart';

class AllergyProfileProvider extends ChangeNotifier {
  final Map<String, Set<String>> _allergies = {};
  final Map<String, String> _notes = {};

  Set<String> forEmail(String email) => Set.unmodifiable(
      _allergies[email.trim().toLowerCase()] ?? const <String>{});
  String noteFor(String email) => _notes[email.trim().toLowerCase()] ?? '';

  void save(String email, Set<String> allergies, String note) {
    final key = email.trim().toLowerCase();
    if (key.isEmpty) return;
    _allergies[key] = Set<String>.from(allergies);
    _notes[key] = note.trim();
    notifyListeners();
  }
}
