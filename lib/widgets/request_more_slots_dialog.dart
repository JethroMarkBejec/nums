import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/requests_provider.dart';

Future<void> showRequestMoreSlotsDialog(
    BuildContext context, String email, int suggestedCookies) async {
  final reason = TextEditingController();
  final count = TextEditingController(text: suggestedCookies.toString());
  await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
            title: const Text('Request more bake slots'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: count,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Additional cookies')),
              TextField(
                  controller: reason,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Reason')),
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () {
                    final cookies = int.tryParse(count.text) ?? 0;
                    if (cookies <= 0 || reason.text.trim().isEmpty) return;
                    context.read<RequestsProvider>().create(
                        email: email,
                        type: 'limit',
                        message: reason.text.trim(),
                        data: {'cookies': cookies});
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Request sent to bakery staff.')));
                  },
                  child: const Text('Send request')),
            ],
          ));
  reason.dispose();
  count.dispose();
}
