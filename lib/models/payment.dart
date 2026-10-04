class Payment {
  final String id;
  final String orderId;
  final double amount;
  final String method;
  final DateTime paidAt;

  Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.paidAt,
  });
}
