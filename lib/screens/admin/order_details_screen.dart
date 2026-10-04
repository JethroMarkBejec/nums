import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenScaffold(
      title: 'Order Details',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child:
                    Text('Order #NMS-1025', style: AppTextStyles.display1(28)),
              ),
              const StatusBadge(text: 'Preparing', color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 5),
          Text('Detailed order view.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order items',
                    style: AppTextStyles.q(19, weight: FontWeight.w700)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/images/box_cookies.png',
                          width: 70, height: 70, fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cookie box',
                              style:
                                  AppTextStyles.q(16, weight: FontWeight.w700)),
                          Text('Box of 6  ·  Qty 1',
                              style: AppTextStyles.q(13,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Text('₱220',
                        style: AppTextStyles.q(15, weight: FontWeight.w700)),
                  ],
                ),
                const Divider(height: 26, color: AppColors.divider),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTextStyles.q(15)),
                    Text('₱220',
                        style: AppTextStyles.q(18, weight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fulfillment',
                    style: AppTextStyles.q(19, weight: FontWeight.w700)),
                const SizedBox(height: 14),
                const _DetailRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Customer',
                    value: 'Customer details'),
                const SizedBox(height: 14),
                const _DetailRow(
                    icon: Icons.calendar_month_outlined,
                    label: 'Schedule',
                    value: 'Tomorrow'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.q(12, color: AppColors.textSecondary)),
              Text(value, style: AppTextStyles.q(14, weight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
