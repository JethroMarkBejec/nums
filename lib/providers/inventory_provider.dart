import 'package:flutter/foundation.dart';

class InventoryProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _inventory = [
    {'id': '1', 'name': 'Butter Cookie', 'quantity': 42, 'unit': 'boxes'},
    {'id': '2', 'name': 'Chocolate Chip', 'quantity': 18, 'unit': 'boxes'},
  ];

  List<Map<String, dynamic>> get inventory => _inventory
      .map((item) => Map<String, dynamic>.unmodifiable(item))
      .toList(growable: false);

  void updateStock(String id, int newQuantity) {
    if (newQuantity < 0) return;
    final index = _inventory.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _inventory[index]['quantity'] = newQuantity;
      notifyListeners();
    }
  }

  bool adjustStock(String id, int change) {
    final index = _inventory.indexWhere((item) => item['id'] == id);
    if (index < 0) return false;
    final current = _inventory[index]['quantity'] as int;
    final updated = current + change;
    if (updated < 0) return false;
    _inventory[index]['quantity'] = updated;
    notifyListeners();
    return true;
  }
}
