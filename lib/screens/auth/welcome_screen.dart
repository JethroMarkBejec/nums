import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/gradient_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('assets/images/logo.png',
                          width: 220, fit: BoxFit.contain),
                      const SizedBox(height: 5),
                      Text('Cookie’s, Baked for You',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.display1(22)),
                      const SizedBox(height: 8),
                      Text('Small batches. A little joy in every box.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.q(10,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 34),
                      AppButton(
                        label: 'Log in',
                        height: 48,
                        fontSize: 16,
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Create a New Account',
                        isPrimary: false,
                        height: 48,
                        fontSize: 16,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
