import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';

class BatchManagementScreen extends StatelessWidget {
  const BatchManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final batches = [
      ('Morning bake', '300 cookies', 'In progress', 0.6),
      ('Tomorrow preorder', '200 cookies', 'Scheduled', 0.2),
    ];

    return AppScreenScaffold(
      title: 'Batch Management',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Production batches', style: AppTextStyles.display1(30)),
          const SizedBox(height: 5),
          Text('Batches and production tracking.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          for (final batch in batches) ...[
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
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
                            Text(batch.$1,
                                style: AppTextStyles.q(16,
                                    weight: FontWeight.w700)),
                            Text(batch.$2,
                                style: AppTextStyles.q(13,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      StatusBadge(
                        text: batch.$3,
                        color: batch.$3 == 'In progress'
                            ? AppColors.warning
                            : AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: batch.$4,
                      minHeight: 8,
                      backgroundColor: AppColors.divider,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Production progress',
                      style:
                          AppTextStyles.q(12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
