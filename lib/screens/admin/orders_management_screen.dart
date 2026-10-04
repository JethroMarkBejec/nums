import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';

class OrdersManagementScreen extends StatelessWidget {
  const OrdersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;
    return AppScreenScaffold(
      title: 'Orders Management',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Customer orders', style: AppTextStyles.display1(30)),
          const SizedBox(height: 5),
          Text('Advance each order to send a progress update.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined,
                    color: Colors.white, size: 26),
                const SizedBox(width: 12),
                Expanded(
                    child: Text('Order queue',
                        style: AppTextStyles.q(18,
                            weight: FontWeight.w700, color: Colors.white))),
                Text('${orders.length} orders',
                    style: AppTextStyles.q(13, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(28),
              child:
                  Center(child: Text('New customer orders will appear here.')),
            ),
          for (final order in orders) ...[
            Builder(builder: (context) {
              final id = order['id'] as String;
              final status = order['status'] as String;
              final statusIndex = OrderProvider.statuses.indexOf(status);
              final canAdvance = statusIndex >= 0 &&
                  statusIndex < OrderProvider.statuses.length - 1;
              final next =
                  canAdvance ? OrderProvider.statuses[statusIndex + 1] : null;
              return AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag_outlined,
                            color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/admin-order-details',
                              arguments: id,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(id,
                                      style: AppTextStyles.q(16,
                                          weight: FontWeight.w700)),
                                  Text(order['customerName'] as String,
                                      style: AppTextStyles.q(12,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        StatusBadge(
                            text: status == OrderProvider.finalStatus
                                ? 'Ready'
                                : status,
                            color: status == OrderProvider.finalStatus
                                ? AppColors.success
                                : AppColors.warning),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                              '${order['paymentMethod']} · ${order['paymentStatus']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.q(12,
                                  color: AppColors.textSecondary)),
                        ),
                        const SizedBox(width: 8),
                        Text(AppFormatters.peso(order['total'] as num),
                            style:
                                AppTextStyles.q(16, weight: FontWeight.w700)),
                      ],
                    ),
                    if (canAdvance && next != null) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            final advanced =
                                context.read<OrderProvider>().advanceStatus(id);
                            if (!advanced) return;
                            context.read<NotificationProvider>().add(
                                  title: 'Order update',
                                  message: 'Order $id is now $next.',
                                  email: order['email'] as String,
                                  orderId: id,
                                );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('$id updated to $next')));
                          },
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(next == OrderProvider.finalStatus
                              ? 'Mark ready'
                              : 'Advance to $next'),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
