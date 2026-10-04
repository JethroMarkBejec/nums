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

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().email ?? '';
    final orders = context.watch<OrderProvider>().ordersFor(email);
    final visible = orders
        .where((order) => (order['status'] == 'Delivered') == _showHistory)
        .toList();

    return AppScreenScaffold(
      title: 'My Orders',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your bakes, in progress',
                    style: AppTextStyles.display1(28)),
                const SizedBox(height: 5),
                Text('Follow each order from oven to doorstep.',
                    style: AppTextStyles.q(14, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('In progress')),
                    ButtonSegment(value: true, label: Text('History')),
                  ],
                  selected: {_showHistory},
                  onSelectionChanged: (selection) =>
                      setState(() => _showHistory = selection.first),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: visible.isEmpty
                  ? Center(
                      key: ValueKey('empty-$_showHistory'),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text(
                          _showHistory
                              ? 'Completed orders will appear here.'
                              : 'No active orders yet. Your next batch is just a few taps away.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.q(15,
                              color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  : ListView.separated(
                      key: ValueKey('orders-$_showHistory'),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _OrderCard(order: visible[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String;
    final statusIndex = OrderProvider.statuses.indexOf(status);
    final createdAt = order['createdAt'] as DateTime;
    final items = order['items'] as List;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(13)),
                child: const Icon(Icons.receipt_long_rounded,
                    color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order['id'] as String,
                        style: AppTextStyles.q(17, weight: FontWeight.w700)),
                    Text(
                        '${items.length} product${items.length == 1 ? '' : 's'} · ${AppFormatters.longDate(createdAt)}',
                        style: AppTextStyles.q(12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              StatusBadge(
                text: status,
                color: status == 'Delivered'
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (var i = 0; i < OrderProvider.statuses.length; i++) ...[
                _OrderStep(
                  label: OrderProvider.statuses[i],
                  complete: statusIndex >= i,
                  last: i == OrderProvider.statuses.length - 1,
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment · ${order['paymentStatus']}',
                  style: AppTextStyles.q(13, color: AppColors.textSecondary)),
              Text(AppFormatters.peso(order['total'] as num),
                  style: AppTextStyles.q(17, weight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderStep extends StatelessWidget {
  const _OrderStep(
      {required this.label, required this.complete, required this.last});
  final String label;
  final bool complete;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(complete ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 16,
              color: complete ? AppColors.primary : AppColors.textMuted),
          const SizedBox(width: 3),
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.q(9,
                    color: complete
                        ? AppColors.textPrimary
                        : AppColors.textMuted)),
          ),
          if (!last)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: complete ? AppColors.primary : AppColors.divider,
              ),
            ),
        ],
      ),
    );
  }
}
