import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)?.settings.arguments as String?;
    final order = orderId == null
        ? null
        : context.watch<OrderProvider>().orderById(orderId);

    return AppScreenScaffold(
      title: 'Order Details',
      body: order == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text(
                  'This order is no longer available. Return to the order queue and select an order.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.q(15, color: AppColors.textSecondary),
                ),
              ),
            )
          : _details(context, order),
    );
  }

  Widget _details(BuildContext context, Map<String, dynamic> order) {
    final items = List<Map<String, dynamic>>.from(order['items'] as List);
    final status = order['status'] as String? ?? 'Placed';
    final createdAt = order['createdAt'] as DateTime;
    final deliveryDate = order['deliveryDate'] as DateTime;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(order['id'] as String,
                  style: AppTextStyles.display1(28)),
            ),
            StatusBadge(
              text: status,
              color:
                  status == 'Delivered' ? AppColors.success : AppColors.warning,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(order['customerName'] as String,
            style: AppTextStyles.q(14, color: AppColors.textSecondary)),
        const SizedBox(height: 18),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order items',
                  style: AppTextStyles.q(19, weight: FontWeight.w700)),
              const SizedBox(height: 14),
              for (final item in items) ...[
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/images/box_cookies.png',
                          width: 62, height: 62, fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'] as String,
                              style:
                                  AppTextStyles.q(15, weight: FontWeight.w700)),
                          Text(
                            'Box of ${item['boxSize'] ?? 6} · Qty ${item['quantity']}',
                            style: AppTextStyles.q(12,
                                color: AppColors.textSecondary),
                          ),
                          if ((item['notes'] as String?)?.isNotEmpty ?? false)
                            Text('Note: ${item['notes']}',
                                style: AppTextStyles.q(12,
                                    color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Text(
                      AppFormatters.peso(
                        (item['price'] as num) * (item['quantity'] as int),
                      ),
                      style: AppTextStyles.q(14, weight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              const Divider(height: 20, color: AppColors.divider),
              _DetailRow(
                  label: 'Total',
                  value: AppFormatters.peso(order['total'] as num),
                  bold: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fulfillment and payment',
                  style: AppTextStyles.q(19, weight: FontWeight.w700)),
              const SizedBox(height: 14),
              _DetailRow(
                  label: 'Order date',
                  value: AppFormatters.longDate(createdAt)),
              const SizedBox(height: 12),
              _DetailRow(
                  label: 'Pickup / delivery',
                  value: AppFormatters.longDate(deliveryDate)),
              const SizedBox(height: 12),
              _DetailRow(
                  label: 'Payment method',
                  value: order['paymentMethod'] as String),
              const SizedBox(height: 12),
              _DetailRow(
                  label: 'Payment status',
                  value: order['paymentStatus'] as String),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(
      {required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: AppTextStyles.q(13, color: AppColors.textSecondary)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: AppTextStyles.q(14,
                    weight: bold ? FontWeight.w700 : FontWeight.w600)),
          ),
        ],
      );
}
