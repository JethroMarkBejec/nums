import 'package:flutter/material.dart';

import '../../widgets/app_button.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCECF3),
      appBar: AppBar(title: const Text('Verify Account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'We sent a verification code to your email.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Verify',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/customer-shell',
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
