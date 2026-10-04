import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
  static const statuses = [
    'Confirmed',
    'Mixing',
    'Baking',
    'Cooling',
    'Packed',
    'Ready for pickup / Out for delivery',
  ];
  static const finalStatus = 'Ready for pickup / Out for delivery';
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
  }) {
    final now = DateTime.now();
    final order = <String, dynamic>{
      'id': 'NUMS-${_nextOrderNumber++}',
      'email': email,
      'customerName': customerName,
      'items': items.map((item) => Map<String, dynamic>.from(item)).toList(),
      'total': total,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': now,
      'deliveryDate': DateTime(now.year, now.month, now.day + 1),
      'status': statuses.first,
    };
    _orders.insert(0, order);
    notifyListeners();
    return Map<String, dynamic>.unmodifiable(order);
  }

  bool advanceStatus(String id) {
    final index = _orders.indexWhere((order) => order['id'] == id);
    if (index < 0) return false;
    final current = statuses.indexOf(_orders[index]['status'] as String);
    if (current < 0 || current >= statuses.length - 1) return false;
    _orders[index]['status'] = statuses[current + 1];
    notifyListeners();
    return true;
  }
}
