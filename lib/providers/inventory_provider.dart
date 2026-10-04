import 'package:flutter/foundation.dart';

class InventoryProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _inventory = [
    {'id': '1', 'name': 'Butter Cookie', 'quantity': 42, 'unit': 'boxes'},
    {'id': '2', 'name': 'Chocolate Chip', 'quantity': 18, 'unit': 'boxes'},
  ];

  List<Map<String, dynamic>> get inventory => List.unmodifiable(_inventory);

  void updateStock(String id, int newQuantity) {
    final index = _inventory.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _inventory[index]['quantity'] = newQuantity;
      notifyListeners();
    }
  }
}
