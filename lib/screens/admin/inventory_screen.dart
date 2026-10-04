import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = [
      ('Butter Cookie', '42 boxes', 'In stock'),
      ('Chocolate Chip', '18 boxes', 'Low stock'),
    ];

    return AppScreenScaffold(
      title: 'Inventory',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Stock overview', style: AppTextStyles.display1(30)),
          const SizedBox(height: 5),
          Text('Current finished-cookie stock by variety.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: Colors.white, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Text('Inventory management overview',
                      style: AppTextStyles.q(17,
                          weight: FontWeight.w700, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final item in inventory) ...[
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.cookie_outlined,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1,
                            style:
                                AppTextStyles.q(16, weight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text(item.$2,
                            style: AppTextStyles.q(13,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: item.$3,
                    color: item.$3 == 'In stock'
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
