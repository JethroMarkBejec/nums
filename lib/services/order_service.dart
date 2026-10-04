class OrderService {
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'id': 'ORD-1001',
        'customerId': 'CUST-1',
        'total': 24.5,
        'status': 'Pending'
      },
      {
        'id': 'ORD-1002',
        'customerId': 'CUST-2',
        'total': 18.0,
        'status': 'Completed'
      },
    ];
  }
}
