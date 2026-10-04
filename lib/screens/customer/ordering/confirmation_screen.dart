import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/gradient_background.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final now = DateTime.now();
    final orderNumber = args['orderNumber'] as String? ?? 'NUMS-1026';
    final total = (args['total'] as num?) ?? 220;
    final method = args['method'] as String? ?? 'GCash';
    final paymentStatus = args['paymentStatus'] as String? ?? 'Pending';
    final orderedAt = args['orderedAt'] as DateTime? ?? now;
    final delivery =
        args['deliveryDate'] as DateTime? ?? AppFormatters.tomorrow(orderedAt);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 46),
                      ),
                      const SizedBox(height: 14),
                      Text('Order Confirmed!',
                          style: AppTextStyles.q(26, weight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Text('Thank you for supporting our small business!',
                          style: AppTextStyles.q(15)),
                      const SizedBox(height: 14),
                      AppCard(
                        child: Column(
                          children: [
                            AppCardHeader(
                              title: 'Order #$orderNumber',
                              trailing: const Icon(Icons.assignment_outlined,
                                  color: AppColors.primary),
                            ),
                            const SizedBox(height: 14),
                            InfoRow(
                                label: 'Total Amount',
                                value: AppFormatters.peso(total)),
                            const SizedBox(height: 10),
                            InfoRow(label: 'Payment Method', value: method),
                            const SizedBox(height: 10),
                            InfoRow(
                                label: 'Payment Status', value: paymentStatus),
                            const SizedBox(height: 10),
                            InfoRow(
                                label: 'Order Date',
                                value:
                                    '${AppFormatters.longDate(orderedAt)} (Today)'),
                            const SizedBox(height: 10),
                            InfoRow(
                                label: 'Delivery Date',
                                value:
                                    'Tomorrow, ${AppFormatters.longDate(delivery)}'),
                            const SizedBox(height: 10),
                            const InfoRow(
                                label: 'Estimated Time',
                                value: '8:00 AM - 12:00 PM'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      AppCard(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppCardHeader(title: 'Order Status'),
                            const SizedBox(height: 18),
                            _Step(
                              title: 'Order Placed',
                              subtitle:
                                  '${AppFormatters.longDate(orderedAt)} - ${AppFormatters.time12(orderedAt)}',
                              done: true,
                            ),
                            const _Step(
                                title: 'Baking', subtitle: 'In progress'),
                            const _Step(
                                title: 'Out for Delivery',
                                subtitle: 'Tomorrow'),
                            const _Step(
                                title: 'Delivered',
                                subtitle: 'Tomorrow',
                                last: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      AppCard(
                        color: Colors.white.withValues(alpha: 0.5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.local_shipping_outlined,
                                color: AppColors.primary, size: 26),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                  'We\u2019ll notify you once your order is out for delivery.',
                                  style: AppTextStyles.q(13)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: AppButton(
                  label: 'Back to Home',
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/customer-shell', (route) => false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One row of the vertical status timeline.
class _Step extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool done;
  final bool last;

  const _Step({
    required this.title,
    required this.subtitle,
    this.done = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: done ? AppColors.primary : AppColors.timeline,
                      width: 2.5,
                    ),
                  ),
                  child: done
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20)
                      : null,
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 4,
                      color: done ? AppColors.primary : AppColors.timeline,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.q(17, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style:
                          AppTextStyles.q(13, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
