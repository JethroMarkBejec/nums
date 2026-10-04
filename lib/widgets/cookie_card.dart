import 'package:flutter/material.dart';

class CookieCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double price;
  final VoidCallback? onTap;

  const CookieCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text('₱${price.toStringAsFixed(2)}'),
        onTap: onTap,
      ),
    );
  }
}
