import 'package:flutter/material.dart';

import '../../../providers/order_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/live_bake_tracker.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final statusValue = args['status'];
    if (args['orderNumber'] is! String ||
        args['total'] is! num ||
        args['method'] is! String ||
        args['paymentStatus'] is! String ||
        args['orderedAt'] is! DateTime ||
        args['deliveryDate'] is! DateTime ||
        statusValue is! String ||
        !OrderProvider.statuses.contains(statusValue)) {
      return _missingOrder(context);
    }
    final orderNumber = args['orderNumber'] as String;
    final total = args['total'] as num;
    final method = args['method'] as String;
    final paymentStatus = args['paymentStatus'] as String;
    final orderedAt = args['orderedAt'] as DateTime;
    final delivery = args['deliveryDate'] as DateTime;

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
                      LiveBakeTracker(
                        orderId: orderNumber,
                        email: args['email'] as String? ?? '',
                        showDemoButton: true,
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

  Widget _missingOrder(BuildContext context) => GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.receipt_long_outlined,
                        color: AppColors.primary, size: 56),
                    const SizedBox(height: 16),
                    Text('No confirmed order found',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.display1(26)),
                    const SizedBox(height: 8),
                    Text(
                      'Complete checkout to see your order confirmation here.',
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.q(15, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'Back to Home',
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/customer-shell', (route) => false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
