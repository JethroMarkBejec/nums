import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_screen_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Order History',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.62),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.history_rounded,
                    color: AppColors.primary, size: 46),
              ),
              const SizedBox(height: 20),
              Text('Your past orders',
                  style: AppTextStyles.display1(30),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Completed orders will be saved here for an easy repeat.',
                  style: AppTextStyles.q(15, color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
