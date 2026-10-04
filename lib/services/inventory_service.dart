class InventoryService {
  Future<List<Map<String, dynamic>>> fetchInventory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {'id': '1', 'name': 'Butter Cookie', 'quantity': 42, 'unit': 'boxes'},
      {'id': '2', 'name': 'Sugar Cookie', 'quantity': 30, 'unit': 'boxes'},
    ];
  }
}
