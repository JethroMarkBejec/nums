import 'package:flutter/foundation.dart';

/// Tracks each account's game attempts for the current local calendar day.
class PlayProvider with ChangeNotifier {
  static const dailyPlayLimit = 3;

  final Map<String, _DailyPlays> _dailyPlays = {};

  int playsTodayFor(String email) => _dailyPlaysFor(email)?.plays ?? 0;

  int playsRemainingFor(String email) => dailyPlayLimit - playsTodayFor(email);

  bool startPlay(String email) {
    final userKey = email.trim().toLowerCase();
    if (userKey.isEmpty) return false;
    final daily = _dailyPlaysFor(userKey)!;
    if (daily.plays >= dailyPlayLimit) return false;
    daily.plays++;
    notifyListeners();
    return true;
  }

  _DailyPlays? _dailyPlaysFor(String email) {
    final userKey = email.trim().toLowerCase();
    if (userKey.isEmpty) return null;
    final now = DateTime.now();
    final current = _dailyPlays[userKey];
    if (current != null &&
        now.year == current.day.year &&
        now.month == current.day.month &&
        now.day == current.day.day) {
      return current;
    }
    return _dailyPlays[userKey] = _DailyPlays(day: now);
  }
}

class _DailyPlays {
  _DailyPlays({required this.day});

  final DateTime day;
  int plays = 0;
}
