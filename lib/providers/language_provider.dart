import 'package:flutter/foundation.dart';

class LanguageProvider extends ChangeNotifier {
  bool _tagalog = false;
  bool get isTagalog => _tagalog;
  String text(String english, String tagalog) => _tagalog ? tagalog : english;
  void toggle() {
    _tagalog = !_tagalog;
    notifyListeners();
  }
}
