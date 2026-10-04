import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/batch_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';

class BatchManagementScreen extends StatelessWidget {
  const BatchManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final batches = context.watch<BatchProvider>().batches;

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
            Builder(builder: (context) {
              final id = batch['id'] as String;
              final name = batch['name'] as String;
              final quantity = batch['quantity'] as int;
              final status = batch['status'] as String;
              final progress = (batch['progress'] as num).toDouble();
              return AppCard(
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
                              Text(name,
                                  style: AppTextStyles.q(16,
                                      weight: FontWeight.w700)),
                              Text('$quantity cookies',
                                  style: AppTextStyles.q(13,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        StatusBadge(
                          text: status,
                          color: status == 'Complete'
                              ? AppColors.success
                              : status == 'In progress'
                                  ? AppColors.warning
                                  : AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.divider,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.accent),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text('${(progress * 100).round()}% complete',
                              style: AppTextStyles.q(12,
                                  color: AppColors.textSecondary)),
                        ),
                        if (status != 'Complete')
                          TextButton.icon(
                            onPressed: () =>
                                context.read<BatchProvider>().advance(id),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Advance batch'),
                          )
                        else
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.success),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
