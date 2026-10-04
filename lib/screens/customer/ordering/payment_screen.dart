import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart_provider.dart';
import '../../../providers/daily_batch_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/requests_provider.dart';
import '../../../providers/payment_account_provider.dart';
import '../../../repositories/payment_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/request_more_slots_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _methods = [
    (name: 'GCash', asset: 'assets/images/pay_gcash.png'),
    (name: 'Maya', asset: 'assets/images/pay_maya.png'),
    (name: 'Cash', asset: null),
  ];

  String _selected = 'GCash';
  bool _isReviewing = false;
  bool _isPaying = false;
  bool _didLoadAccount = false;
  final _numberController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoadAccount) return;
    _didLoadAccount = true;
    final email = context.read<AuthProvider>().email ?? '';
    final account = context.read<PaymentAccountProvider>().accountFor(email);
    if (account != null) {
      _selected = account['method']!;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _savePaymentAccount() {
    final email = context.read<AuthProvider>().email ?? '';
    final saved = context
        .read<PaymentAccountProvider>()
        .save(email, _selected, _numberController.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(saved
            ? 'Payment preference saved on this device.'
            : 'Enter a valid mobile number, or choose Cash.')));
  }

  Future<void> _confirm(double total) async {
    final cart = context.read<CartProvider>();
    final orderId = (ModalRoute.of(context)?.settings.arguments
        as Map?)?['orderId'] as String?;
    final existingOrder = orderId == null
        ? null
        : context.read<OrderProvider>().orderById(orderId);
    final items = existingOrder == null
        ? cart.items
        : List<Map<String, dynamic>>.from(existingOrder['items'] as List);
    if ((items.isEmpty || existingOrder == null && cart.isEmpty) ||
        _isReviewing ||
        _isPaying) return;
    final amount = existingOrder == null
        ? total
        : (existingOrder['total'] as num).toDouble();
    final exclusions = items
        .expand((item) =>
            (item['exclusions'] as List?)?.cast<String>() ?? const <String>[])
        .toList();
    final accountSaved = context.read<PaymentAccountProvider>().save(
        context.read<AuthProvider>().email ?? '',
        _selected,
        _numberController.text);
    if (!accountSaved) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Link a valid GCash or Maya number first, or select Cash.')));
      return;
    }
    final cookieCount = items.fold<int>(
        0,
        (sum, item) =>
            sum +
            ((item['boxSize'] as num?)?.toInt() ?? 0) *
                ((item['quantity'] as num?)?.toInt() ?? 1));
    final capacity = context.read<DailyBatchProvider>();
    if (!capacity.canReserve(cookieCount)) {
      await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
                title: const Text('Daily batch limit reached'),
                content: Text(
                    'Your cart has $cookieCount cookies, but only ${capacity.remaining} remain. Request additional slots from bakery staff?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Review cart')),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        showRequestMoreSlotsDialog(
                            this.context,
                            this.context.read<AuthProvider>().email ?? '',
                            cookieCount - capacity.remaining);
                      },
                      child: const Text('Request more slots')),
                ],
              ));
      return;
    }
    if (exclusions.isNotEmpty && existingOrder == null) {
      final submit = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
                title: const Text('Bakery review required'),
                content: Text(
                    'Your order includes these allergy exclusions: ${exclusions.join(', ')}. Staff must approve the request before payment. Submit it for review?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Go back')),
                  FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Submit for review'))
                ],
              ));
      if (submit != true || !mounted) return;
      final auth = context.read<AuthProvider>();
      final order = context.read<OrderProvider>().createOrder(
          email: auth.email ?? '',
          customerName: auth.username ?? 'Customer',
          items: items,
          total: amount,
          paymentMethod: _selected,
          paymentStatus: 'Pending',
          initialStatus: 'Pending admin review',
          exclusions: exclusions);
      context.read<RequestsProvider>().create(
          email: auth.email ?? '',
          type: 'allergy',
          message:
              'Allergy/exclusion review for ${order['id']}: ${exclusions.join(', ')}',
          data: {'orderId': order['id']});
      context.read<NotificationProvider>().add(
          title: 'Order sent for review',
          message: 'Order ${order['id']} must be approved before payment.',
          email: auth.email ?? '',
          orderId: order['id'] as String);
      cart.clear();
      Navigator.pushNamedAndRemoveUntil(
          context, '/customer-shell', (route) => false);
      return;
    }
    if (existingOrder != null && existingOrder['paymentStatus'] != 'Pending')
      return;
    if (existingOrder != null &&
        existingOrder['status'] == 'Pending admin review') return;
    if (_isReviewing || _isPaying) return;
    setState(() => _isReviewing = true);
    final shouldPay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm payment'),
        content: Text(
          '${items.length} item${items.length == 1 ? '' : 's'} in your order\n'
          'Total: ${AppFormatters.peso(amount)}\n'
          'Payment method: $_selected\n\n'
          'Continue to pay now? This app simulates the $_selected payment for this demo. No money will be charged.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Go back'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Pay now'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (shouldPay != true) {
      setState(() => _isReviewing = false);
      return;
    }
    if (!capacity.reserve(cookieCount)) {
      setState(() => _isReviewing = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Today’s batch filled while you were reviewing. Please update your cart.')));
      return;
    }
    setState(() {
      _isReviewing = false;
      _isPaying = true;
    });
    var paymentSucceeded = false;
    try {
      paymentSucceeded = (await context
                  .read<PaymentRepository>()
                  .pay(amount: amount, method: _selected))
              .status ==
          'Paid';
    } catch (_) {
      paymentSucceeded = false;
    }
    if (!mounted) {
      capacity.release(cookieCount);
      return;
    }
    if (!paymentSucceeded) {
      capacity.release(cookieCount);
      setState(() => _isPaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Payment could not be completed. Your cart is unchanged.')),
      );
      return;
    }
    final now = DateTime.now();
    final auth = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final order = existingOrder == null
        ? orderProvider.createOrder(
            email: auth.email ?? '',
            customerName: auth.username ?? 'Customer',
            items: items,
            total: amount,
            paymentMethod: _selected,
            paymentStatus: 'Paid (demo)',
          )
        : (orderProvider.markPaid(orderId!, method: _selected)
            ? orderProvider.orderById(orderId)!
            : existingOrder);
    context.read<NotificationProvider>().add(
          title: 'Order placed',
          message: 'Order ${order['id']} is now in your order progress.',
          email: auth.email ?? '',
          orderId: order['id'] as String,
        );
    final args = {
      'orderNumber': order['id'],
      'total': amount,
      'method': _selected,
      'orderedAt': now,
      'deliveryDate': AppFormatters.tomorrow(now),
      'status': order['status'],
      'paymentStatus': order['paymentStatus'],
      'email': auth.email ?? '',
    };
    if (existingOrder == null) cart.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, '/confirmation', (route) => false,
        arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final orderId = (ModalRoute.of(context)?.settings.arguments
        as Map?)?['orderId'] as String?;
    final existingOrder = orderId == null
        ? null
        : context.watch<OrderProvider>().orderById(orderId);
    final items = existingOrder == null
        ? cart.items
        : List<Map<String, dynamic>>.from(existingOrder['items'] as List);
    final total = existingOrder == null
        ? cart.total
        : (existingOrder['total'] as num).toDouble();
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
                          Text(
                              existingOrder == null
                                  ? 'Payment'
                                  : 'Complete approved payment',
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
                            if (_selected != 'Cash') ...[
                              TextField(
                                  controller: _numberController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                      labelText: 'Linked mobile number')),
                            ],
                            Text(
                                'Linked account: ${context.watch<PaymentAccountProvider>().accountFor(context.watch<AuthProvider>().email ?? '')?['number'] ?? 'Not linked'}'),
                            const SizedBox(height: 8),
                            Row(children: [
                              Expanded(
                                  child: Text(
                                      'Demo payment only · no card details stored',
                                      style: AppTextStyles.q(12,
                                          color: AppColors.textSecondary))),
                              TextButton(
                                  onPressed: _savePaymentAccount,
                                  child: const Text('Save')),
                            ]),
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
                      : _isPaying
                          ? 'Processing payment…'
                          : _isReviewing
                              ? 'Reviewing payment…'
                              : (existingOrder == null
                                  ? 'Pay & Place Order'
                                  : 'Pay approved order'),
                  onPressed: items.isEmpty || _isPaying || _isReviewing
                      ? null
                      : () => _confirm(total),
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
                        '${item['items_summary'] ?? 'Box of ${item['boxSize'] ?? 6}'}'
                        ' · Qty ${item['quantity']}',
                        style:
                            AppTextStyles.q(14, color: AppColors.textSecondary),
                      ),
                      if ((item['gift_note'] as String?)?.isNotEmpty == true)
                        Text('Gift note: ${item['gift_note']}',
                            style: AppTextStyles.q(12,
                                color: AppColors.textSecondary)),
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

  Widget _methodTile(String name, String? asset) {
    final selected = _selected == name;
    return InkWell(
      onTap: () => setState(() => _selected = name),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (asset != null)
              ClipOval(
                  child: Image.asset(asset,
                      width: 46, height: 46, fit: BoxFit.cover))
            else
              const CircleAvatar(
                  backgroundColor: AppColors.accentSoft,
                  child:
                      Icon(Icons.payments_outlined, color: AppColors.primary)),
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
