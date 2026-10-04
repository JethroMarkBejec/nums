class NotificationService {
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      {
        'id': 'N-1',
        'title': 'Delivery Update',
        'message': 'Your order is on the way.',
        'createdAt': DateTime.now(),
        'isRead': false,
      },
    ];
  }
}
