import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
  static const statuses = [
    'Confirmed',
    'Mixing',
    'Baking',
    'Cooling',
    'Packed',
    'Ready for pickup / Out for delivery',
    'Received',
  ];
  static const readyStatus = 'Ready for pickup / Out for delivery';
  static const finalStatus = 'Received';
  final List<Map<String, dynamic>> _orders = [];
  int _nextOrderNumber = 1027;

  List<Map<String, dynamic>> get orders => _orders
      .map((order) => Map<String, dynamic>.unmodifiable(order))
      .toList(growable: false);

  List<Map<String, dynamic>> ordersFor(String email) =>
      orders.where((order) => order['email'] == email).toList(growable: false);

  Map<String, dynamic>? orderById(String id) {
    for (final order in _orders) {
      if (order['id'] == id) {
        return Map<String, dynamic>.unmodifiable(order);
      }
    }
    return null;
  }

  Map<String, dynamic> createOrder({
    required String email,
    required String customerName,
    required List<Map<String, dynamic>> items,
    required double total,
    required String paymentMethod,
    required String paymentStatus,
    String? initialStatus,
    List<String> exclusions = const [],
  }) {
    final now = DateTime.now();
    final order = <String, dynamic>{
      'id': 'NUMS-${_nextOrderNumber++}',
      'email': email,
      'customerName': customerName,
      'items': items.map((item) => Map<String, dynamic>.from(item)).toList(),
      'gift_note': items
          .map((item) => item['gift_note'])
          .whereType<String>()
          .where((note) => note.trim().isNotEmpty)
          .join('\n'),
      'exclusions': List<String>.from(exclusions),
      'total': total,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': now,
      'deliveryDate': DateTime(now.year, now.month, now.day + 1),
      'status': initialStatus ?? statuses.first,
    };
    _orders.insert(0, order);
    notifyListeners();
    return Map<String, dynamic>.unmodifiable(order);
  }

  bool approveForPayment(String id, {String? message}) {
    final index = _orders.indexWhere((item) => item['id'] == id);
    if (index < 0 || _orders[index]['status'] != 'Pending admin review')
      return false;
    final order = _orders[index];
    order['status'] = statuses.first;
    order['adminMessage'] =
        message ?? 'Approved. You can complete payment now.';
    order['paymentStatus'] = 'Pending';
    notifyListeners();
    return true;
  }

  bool declineReview(String id, String message) {
    final index = _orders.indexWhere((item) => item['id'] == id);
    if (index < 0 || _orders[index]['status'] != 'Pending admin review')
      return false;
    final order = _orders[index];
    order['status'] = 'Declined';
    order['adminMessage'] = message;
    notifyListeners();
    return true;
  }

  bool markPaid(String id, {required String method}) {
    final index = _orders.indexWhere((item) => item['id'] == id);
    if (index < 0 ||
        _orders[index]['status'] == 'Pending admin review' ||
        _orders[index]['status'] == 'Declined') return false;
    _orders[index]['paymentMethod'] = method;
    _orders[index]['paymentStatus'] = 'Paid (demo)';
    notifyListeners();
    return true;
  }

  bool refundOrder(String id) {
    final index = _orders.indexWhere((item) => item['id'] == id);
    if (index < 0 || _orders[index]['paymentStatus'] != 'Paid (demo)')
      return false;
    _orders[index]['paymentStatus'] = 'Refunded (demo)';
    notifyListeners();
    return true;
  }

  bool saveFeedback(String id,
      {required int rating,
      required String comment,
      String? photoName,
      Uint8List? photoBytes}) {
    final index = _orders.indexWhere((item) => item['id'] == id);
    if (index < 0 ||
        _orders[index]['status'] != 'Received' ||
        rating < 1 ||
        rating > 5) return false;
    _orders[index]['feedback'] = {
      'rating': rating,
      'comment': comment.trim(),
      if (photoName != null) 'photoName': photoName,
      if (photoBytes != null) 'photoBytes': Uint8List.fromList(photoBytes),
    };
    notifyListeners();
    return true;
  }

  bool advanceStatus(String id) {
    final index = _orders.indexWhere((order) => order['id'] == id);
    if (index < 0) return false;
    final current = statuses.indexOf(_orders[index]['status'] as String);
    if (_orders[index]['paymentStatus'] != 'Paid (demo)') return false;
    if (current < 0 || current >= statuses.length - 1) return false;
    _orders[index]['status'] = statuses[current + 1];
    notifyListeners();
    return true;
  }
}
