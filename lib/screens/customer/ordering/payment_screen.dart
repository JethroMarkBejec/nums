import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/gradient_background.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _methods = [
    (name: 'GCash', asset: 'assets/images/pay_gcash.png'),
    (name: 'Maya', asset: 'assets/images/pay_maya.png'),
    (name: 'GoTyme', asset: 'assets/images/pay_gotyme.png'),
  ];

  String _selected = 'GCash';

  Future<void> _confirm(double total) async {
    final cart = context.read<CartProvider>();
    if (cart.isEmpty) return;
    final items = cart.items;
    final shouldPlace = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Review before placing your order'),
        content: Text(
          '${items.length} item${items.length == 1 ? '' : 's'} in your order\n'
          'Total: ${AppFormatters.peso(total)}\n'
          'Payment method: $_selected\n\n'
          'Place this order? Payment will show as pending until a payment provider is connected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Go back'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Place order'),
          ),
        ],
      ),
    );
    if (shouldPlace != true || !mounted) return;
    final now = DateTime.now();
    final auth = context.read<AuthProvider>();
    final order = context.read<OrderProvider>().createOrder(
          email: auth.email ?? '',
          customerName: auth.username ?? 'Customer',
          items: items,
          total: total,
          paymentMethod: _selected,
        );
    context.read<NotificationProvider>().add(
          title: 'Order placed',
          message: 'Order ${order['id']} is now in your order progress.',
          email: auth.email ?? '',
          orderId: order['id'] as String,
        );
    final args = {
      'orderNumber': order['id'],
      'total': total,
      'method': _selected,
      'orderedAt': now,
      'deliveryDate': AppFormatters.tomorrow(now),
      'status': 'Placed',
      'paymentStatus': order['paymentStatus'],
    };
    cart.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, '/confirmation', (route) => false,
        arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final total = cart.total;
    final delivery = AppFormatters.tomorrow();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.maybePop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: 20),
                          ),
                          Text('Payment',
                              style:
                                  AppTextStyles.q(22, weight: FontWeight.w500)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 14),
                        child: Text(
                            'Review your order and choose a payment method.',
                            style: AppTextStyles.q(14)),
                      ),
                      _orderSummary(items, total),
                      const SizedBox(height: 20),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppCardHeader(
                                title: 'Pickup Date & Delivery'),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined,
                                    size: 24, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Text(
                                    'Tomorrow, ${AppFormatters.longDate(delivery)}',
                                    style: AppTextStyles.q(17)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                                'Orders must be picked up or delivered on the selected date.',
                                style: AppTextStyles.q(13,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Method',
                                style: AppTextStyles.q(20,
                                    weight: FontWeight.w700)),
                            const SizedBox(height: 14),
                            for (final m in _methods)
                              _methodTile(m.name, m.asset),
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
                  label: items.isEmpty
                      ? 'Your cart is empty'
                      : 'Review & Place Order',
                  onPressed: items.isEmpty ? null : () => _confirm(total),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderSummary(List<Map<String, dynamic>> items, double total) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(
            title: 'Order Summary',
            trailing: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/cart'),
              child: Text('Edit', style: AppTextStyles.q(16)),
            ),
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('Your cart is empty.', style: AppTextStyles.q(15)),
            ),
          for (final item in items) ...[
            Row(
              children: [
                Image.asset('assets/images/box_cookies.png',
                    width: 104, fit: BoxFit.contain),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'] as String,
                          style: AppTextStyles.q(14,
                              color: AppColors.textSecondary)),
                      Text(
                        'Box of ${item['boxSize'] ?? 6}'
                        ' · Qty ${item['quantity']}',
                        style:
                            AppTextStyles.q(14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppFormatters.peso(
                      (item['price'] as num) * (item['quantity'] as int)),
                  style: AppTextStyles.q(14, weight: FontWeight.w600),
                ),
              ],
            ),
            if ((item['mixIns'] as List?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 6),
              Text('Mix-ins', style: AppTextStyles.q(14)),
              for (final m in item['mixIns'] as List)
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 2),
                  child: Text('\u2022  $m', style: AppTextStyles.q(14)),
                ),
            ],
            const SizedBox(height: 8),
          ],
          const Divider(height: 20, color: AppColors.divider),
          InfoRow(label: 'Subtotal', value: AppFormatters.peso(total)),
          const SizedBox(height: 8),
          const InfoRow(label: 'Delivery Fee', value: '\u20B10'),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          InfoRow(label: 'Total', value: AppFormatters.peso(total), bold: true),
        ],
      ),
    );
  }

  Widget _methodTile(String name, String asset) {
    final selected = _selected == name;
    return InkWell(
      onTap: () => setState(() => _selected = name),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipOval(
                child: Image.asset(asset,
                    width: 46, height: 46, fit: BoxFit.cover)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppTextStyles.q(17, weight: FontWeight.w600)),
                  Text('Pay with $name',
                      style:
                          AppTextStyles.q(14, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.3),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
