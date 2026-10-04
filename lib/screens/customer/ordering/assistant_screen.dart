import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_screen_scaffold.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Cookie Assistant',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('A little help choosing?',
                          style: AppTextStyles.q(18,
                              weight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Your personal guide to the cookie menu.',
                          style: AppTextStyles.q(13, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: const BoxDecoration(
                      color: AppColors.accentSoft, shape: BoxShape.circle),
                  child: const Icon(Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary, size: 34),
                ),
                const SizedBox(height: 16),
                Text('Recommendations are on the way',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.q(20, weight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                    'The assistant will suggest a treat based on your favorites.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.q(14, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('A few ways to decide',
              style: AppTextStyles.q(18, weight: FontWeight.w700)),
          const SizedBox(height: 10),
          const _TipRow(
              icon: Icons.favorite_border_rounded,
              text: 'Pick a familiar favorite'),
          const SizedBox(height: 8),
          const _TipRow(
              icon: Icons.cookie_outlined, text: 'Try a fresh-baked classic'),
          const SizedBox(height: 8),
          const _TipRow(
              icon: Icons.card_giftcard_outlined,
              text: 'Share a box with someone'),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.q(14, weight: FontWeight.w600)),
        ],
      ),
    );
  }
}
