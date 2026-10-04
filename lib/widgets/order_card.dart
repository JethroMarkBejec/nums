import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String status;
  final double total;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(orderId),
        subtitle: Text(status),
        trailing: Text('₱${total.toStringAsFixed(2)}'),
      ),
    );
  }
}
