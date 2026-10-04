import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_screen_scaffold.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Customize Order',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Make it your own', style: AppTextStyles.display1(30)),
          const SizedBox(height: 5),
          Text('Choose the finishing touches for your cookie box.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset('assets/images/cookie_oatmeal.png',
                height: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mix-ins',
                    style: AppTextStyles.q(19, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Included with your selected cookie.',
                    style: AppTextStyles.q(13, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                const _ChoiceRow(label: 'Chocolate chips', selected: true),
                const Divider(height: 20, color: AppColors.divider),
                const _ChoiceRow(label: 'Rolled oats', selected: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.edit_note_rounded,
                    color: AppColors.primary, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Special requests',
                          style: AppTextStyles.q(17, weight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Add baking notes on the order details screen.',
                          style: AppTextStyles.q(13,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  final String label;
  final bool selected;

  const _ChoiceRow({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: selected ? AppColors.primary : AppColors.textMuted,
            size: 21),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.q(15, weight: FontWeight.w600)),
        const Spacer(),
        Text('Included',
            style: AppTextStyles.q(12, color: AppColors.textSecondary)),
      ],
    );
  }
}
