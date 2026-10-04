import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Email verification')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined,
                size: 64, color: AppColors.primary),
            const SizedBox(height: 20),
            Text('Email verification is unavailable',
                textAlign: TextAlign.center, style: AppTextStyles.display1(26)),
            const SizedBox(height: 10),
            Text(
              'This local version has no email service. Create an account from the sign-up screen to continue.',
              textAlign: TextAlign.center,
              style: AppTextStyles.q(15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Back to Sign In',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false),
            ),
          ],
        ),
      ),
    );
  }
}
