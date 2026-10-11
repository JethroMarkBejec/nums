import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/requests_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_screen_scaffold.dart';

class CustomRequestScreen extends StatefulWidget {
  const CustomRequestScreen({super.key});
  @override
  State<CustomRequestScreen> createState() => _CustomRequestScreenState();
}

class _CustomRequestScreenState extends State<CustomRequestScreen> {
  final _description = TextEditingController();
  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScreenScaffold(
      title: 'Custom request',
      body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text(
                'Tell us what you have in mind. Bakery staff will review your request.',
                style: AppTextStyles.q(14, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
                controller: _description,
                minLines: 3,
                maxLines: 6,
                maxLength: 300,
                decoration:
                    const InputDecoration(labelText: 'Request details')),
            const SizedBox(height: 16),
            FilledButton(
                onPressed: () {
                  final message = _description.text.trim();
                  if (message.isEmpty) return;
                  context.read<RequestsProvider>().create(
                      email: context.read<AuthProvider>().email ?? '',
                      type: 'custom',
                      message: message);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Custom request sent for review.')));
                },
                child: const Text('Send request')),
          ]));
}
