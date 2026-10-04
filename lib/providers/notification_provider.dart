import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications
      .map((notification) => Map<String, dynamic>.unmodifiable(notification))
      .toList(growable: false);
  int get unreadCount =>
      _notifications.where((item) => item['isRead'] != true).length;
  List<Map<String, dynamic>> forEmail(String email) => notifications
      .where((item) => item['email'] == email)
      .toList(growable: false);
  int unreadCountFor(String email) => _notifications
      .where((item) => item['email'] == email && item['isRead'] != true)
      .length;

  void add(
      {required String title,
      required String message,
      required String email,
      String? orderId}) {
    _notifications.insert(0, {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'title': title,
      'message': message,
      'createdAt': DateTime.now(),
      'isRead': false,
      'email': email,
      if (orderId != null) 'orderId': orderId,
    });
    notifyListeners();
  }

  void markRead(String id) {
    final item = _notifications.firstWhere((item) => item['id'] == id);
    if (item['isRead'] == true) return;
    item['isRead'] = true;
    notifyListeners();
  }

  void markAllAsRead(String email) {
    if (unreadCountFor(email) == 0) return;
    for (final item in _notifications) {
      if (item['email'] == email) item['isRead'] = true;
    }
    notifyListeners();
  }
}
