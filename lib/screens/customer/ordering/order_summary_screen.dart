import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_screen_scaffold.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Order Summary',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('One last look', style: AppTextStyles.display1(30)),
          const SizedBox(height: 5),
          Text('Review your order before payment.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: const BoxDecoration(
                      color: AppColors.accentSoft, shape: BoxShape.circle),
                  child: const Icon(Icons.inventory_2_outlined,
                      color: AppColors.primary, size: 38),
                ),
                const SizedBox(height: 14),
                Text('Order details',
                    style: AppTextStyles.q(20, weight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                    'Your selected cookies, box sizes, and quantities will appear here.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.q(14, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup or delivery',
                          style: AppTextStyles.q(15, weight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text('Tomorrow',
                          style: AppTextStyles.q(13,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
