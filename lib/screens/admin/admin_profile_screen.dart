import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Admin Profile',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.storefront_rounded,
                      color: Colors.white, size: 44),
                ),
                const SizedBox(height: 12),
                Text('Shop administrator', style: AppTextStyles.display1(28)),
                const SizedBox(height: 4),
                Text('NUMS Bakery',
                    style: AppTextStyles.q(14, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile details',
                    style: AppTextStyles.q(19, weight: FontWeight.w700)),
                const SizedBox(height: 16),
                const _AdminProfileRow(
                    icon: Icons.admin_panel_settings_outlined,
                    label: 'Access',
                    value: 'Administrator'),
                const Divider(height: 24, color: AppColors.divider),
                const _AdminProfileRow(
                    icon: Icons.store_outlined,
                    label: 'Store',
                    value: 'NUMS Bakery'),
                const Divider(height: 24, color: AppColors.divider),
                const _AdminProfileRow(
                    icon: Icons.manage_accounts_outlined,
                    label: 'Account',
                    value: 'Profile settings'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AdminProfileRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.q(12, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.q(15, weight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
