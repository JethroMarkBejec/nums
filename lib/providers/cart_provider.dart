import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items =>
      _items.map((item) => Map<String, dynamic>.unmodifiable(item)).toList();
  int get itemCount =>
      _items.fold(0, (sum, item) => sum + (item['quantity'] as int));
  bool get isEmpty => _items.isEmpty;

  void addItem(Map<String, dynamic> item) {
    _items.add(Map<String, dynamic>.from(item));
    notifyListeners();
  }

  void setQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index < 0) return;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index]['quantity'] = quantity;
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  double get total => _items.fold<double>(
        0,
        (sum, item) =>
            sum + (item['price'] as num).toDouble() * (item['quantity'] as int),
      );
}
