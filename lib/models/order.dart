class Order {
  final String id;
  final String customerId;
  final double total;
  final DateTime createdAt;
  final String status;

  Order({
    required this.id,
    required this.customerId,
    required this.total,
    required this.createdAt,
    required this.status,
  });
}
