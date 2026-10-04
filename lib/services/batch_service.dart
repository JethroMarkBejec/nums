class BatchService {
  Future<List<Map<String, dynamic>>> getBatches() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {
        'id': 'B-101',
        'name': 'Morning Batch',
        'quantity': 50,
        'createdAt': DateTime.now()
      },
      {
        'id': 'B-102',
        'name': 'Afternoon Batch',
        'quantity': 35,
        'createdAt': DateTime.now()
      },
    ];
  }
}
