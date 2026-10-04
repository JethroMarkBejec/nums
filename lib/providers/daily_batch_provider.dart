import 'package:flutter/foundation.dart';

/// Local demo capacity shared by the home screen, box builder and checkout.
class DailyBatchProvider extends ChangeNotifier {
  static const int initialDailyLimit = 500;
  int _dailyLimit = initialDailyLimit;
  int _claimed = 300;

  int get claimed => _claimed;
  int get dailyLimit => _dailyLimit;
  int get remaining => (_dailyLimit - _claimed).clamp(0, _dailyLimit).toInt();

  bool canReserve(int cookies) => cookies > 0 && cookies <= remaining;

  bool reserve(int cookies) {
    if (!canReserve(cookies)) return false;
    _claimed += cookies;
    notifyListeners();
    return true;
  }

  void release(int cookies) {
    if (cookies <= 0 || _claimed - cookies < 0) return;
    _claimed -= cookies;
    notifyListeners();
  }

  void increaseLimit(int additionalCookies) {
    if (additionalCookies <= 0) return;
    _dailyLimit += additionalCookies;
    notifyListeners();
  }
}
