import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Dashboard',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Bakery overview', style: AppTextStyles.display1(30)),
          const SizedBox(height: 5),
          Text('A quick look at today’s shop operations.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny_outlined,
                    color: Colors.white, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Today’s production',
                          style: AppTextStyles.q(17,
                              weight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 3),
                      Text('Orders, stock, and batches at a glance.',
                          style: AppTextStyles.q(13, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _DashboardTile(
              icon: Icons.receipt_long_outlined,
              title: 'Orders',
              detail: 'Review incoming orders and update their status.'),
          const SizedBox(height: 10),
          const _DashboardTile(
              icon: Icons.inventory_2_outlined,
              title: 'Inventory',
              detail: 'Keep track of ingredients and finished cookie boxes.'),
          const SizedBox(height: 10),
          const _DashboardTile(
              icon: Icons.cookie_outlined,
              title: 'Production batches',
              detail: 'Follow each bake from preparation to ready stock.'),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _DashboardTile(
      {required this.icon, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.q(16, weight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(detail,
                    style: AppTextStyles.q(12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
