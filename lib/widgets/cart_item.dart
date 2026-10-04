import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    super.key,
    required this.title,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Qty: $quantity'),
      trailing: Text('₱${price.toStringAsFixed(2)}'),
    );
  }
}
