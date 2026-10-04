import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/live_bake_tracker.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().email ?? '';
    final orders = context
        .watch<OrderProvider>()
        .ordersFor(email)
        .where((order) => order['status'] == OrderProvider.finalStatus)
        .toList();
    return AppScreenScaffold(
      title: 'Order History',
      body: orders.isEmpty
          ? Center(
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
                    Text('Your past orders', style: AppTextStyles.display1(30)),
                    const SizedBox(height: 8),
                    Text('Orders at the final tracker stage will appear here.',
                        style:
                            AppTextStyles.q(15, color: AppColors.textSecondary),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = orders[index];
                final items = order['items'] as List;
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(order['id'] as String,
                                style: AppTextStyles.q(17,
                                    weight: FontWeight.w700)),
                          ),
                          const StatusBadge(
                              text: 'Ready', color: AppColors.success),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LiveBakeTracker(
                        orderId: order['id'] as String,
                        email: order['email'] as String? ?? '',
                      ),
                      const SizedBox(height: 8),
                      Text(items.map((item) => item['name']).join(', '),
                          style: AppTextStyles.q(14,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              AppFormatters.longDate(
                                  order['createdAt'] as DateTime),
                              style: AppTextStyles.q(12,
                                  color: AppColors.textMuted)),
                          Text(AppFormatters.peso(order['total'] as num),
                              style:
                                  AppTextStyles.q(16, weight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
