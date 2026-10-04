import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/reviews_provider.dart';
import '../../repositories/points_repository.dart';
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
        .where((order) =>
            (order['status'] == OrderProvider.finalStatus) == _showHistory)
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
                Text(_showHistory ? 'Order history' : 'Your bakes, in progress',
                    style: AppTextStyles.display1(28)),
                const SizedBox(height: 5),
                Text(
                    _showHistory
                        ? 'Your delivered orders, all in one place.'
                        : 'Follow each order from oven to doorstep.',
                    style: AppTextStyles.q(14, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: AppColors.cardBorder.withValues(alpha: 0.8)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _filterButton('In progress', false)),
                      Expanded(child: _filterButton('History', true)),
                    ],
                  ),
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

  Widget _filterButton(String label, bool history) {
    final selected = _showHistory == history;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _showHistory = history),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected ? const [AppColors.cardShadow] : null,
        ),
        child: Text(label,
            style: AppTextStyles.q(14,
                weight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textSecondary)),
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
    final productNames = items
        .map((item) =>
            (item['items_summary'] as String?) ?? item['name'] as String)
        .join(', ');
    final boxCount = items.fold<int>(
      0,
      (sum, item) => sum + ((item['quantity'] as int?) ?? 1),
    );
    final progress = statusIndex < 0
        ? 0.0
        : ((statusIndex + 1) / OrderProvider.statuses.length).clamp(0.0, 1.0);
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
                    Text(AppFormatters.longDate(createdAt),
                        style: AppTextStyles.q(12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              StatusBadge(
                text: status == OrderProvider.readyStatus ? 'Ready' : status,
                color: status == OrderProvider.readyStatus ||
                        status == OrderProvider.finalStatus
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(productNames.isEmpty ? 'Cookie order' : productNames,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.q(15, weight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(
              '$boxCount box${boxCount == 1 ? '' : 'es'} · ${items.length} product${items.length == 1 ? '' : 's'}',
              style: AppTextStyles.q(12, color: AppColors.textSecondary)),
          if (status != OrderProvider.finalStatus) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order progress',
                    style: AppTextStyles.q(12,
                        weight: FontWeight.w700,
                        color: AppColors.textSecondary)),
                Text(
                    'Step ${statusIndex + 1} of ${OrderProvider.statuses.length}',
                    style: AppTextStyles.q(12,
                        weight: FontWeight.w700,
                        color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: AppColors.cardBorder.withValues(alpha: 0.55),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 5),
            Text('Currently: $status',
                style: AppTextStyles.q(13,
                    weight: FontWeight.w600, color: AppColors.primary)),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('Payment · ${order['paymentStatus']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.q(12, color: AppColors.textSecondary)),
              ),
              const SizedBox(width: 12),
              Text(AppFormatters.peso(order['total'] as num),
                  style: AppTextStyles.q(17, weight: FontWeight.w700)),
            ],
          ),
          if (order['paymentStatus'] == 'Pending' &&
              status != 'Pending admin review' &&
              status != 'Declined') ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/payment',
                      arguments: {'orderId': order['id']}),
                  icon: const Icon(Icons.lock_open_rounded),
                  label: const Text('Pay approved order')),
            ),
          ],
          if (status == 'Declined')
            Text(
                'Staff message: ${order['adminMessage'] ?? 'This order was declined.'}',
                style: AppTextStyles.q(13, color: AppColors.error)),
          if (status == OrderProvider.finalStatus && order['feedback'] == null)
            _FeedbackForm(order: order),
          if (status == OrderProvider.finalStatus && order['feedback'] != null)
            Text('Thanks for your ${order['feedback']['rating']}-star rating.',
                style: AppTextStyles.q(13, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _FeedbackForm extends StatefulWidget {
  final Map<String, dynamic> order;
  const _FeedbackForm({required this.order});
  @override
  State<_FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<_FeedbackForm> {
  int _rating = 5;
  final _comment = TextEditingController();
  XFile? _photo;
  Uint8List? _photoBytes;
  bool _pickingPhoto = false;
  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    setState(() => _pickingPhoto = true);
    try {
      final file = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 75);
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _photo = file;
        _photoBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Photo picker is unavailable here. You can still send your rating and comment.')));
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        Text('How was your order?',
            style: AppTextStyles.q(15, weight: FontWeight.w700)),
        Row(
            children: List.generate(
                5,
                (index) => IconButton(
                    tooltip: '${index + 1} stars',
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                        index < _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.warning)))),
        TextField(
            controller: _comment,
            maxLength: 240,
            decoration: const InputDecoration(labelText: 'Leave feedback')),
        OutlinedButton.icon(
          onPressed: _pickingPhoto ? null : _pickPhoto,
          icon: const Icon(Icons.photo_library_outlined),
          label: Text(_pickingPhoto
              ? 'Opening photos…'
              : (_photo == null ? 'Add optional photo' : 'Change photo')),
        ),
        if (_photoBytes != null) ...[
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  Image.memory(_photoBytes!, height: 140, fit: BoxFit.cover)),
          Text(_photo!.name,
              style: AppTextStyles.q(12, color: AppColors.textSecondary)),
        ],
        Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
                onPressed: () {
                  final id = widget.order['id'] as String;
                  final email = widget.order['email'] as String;
                  if (!context.read<OrderProvider>().saveFeedback(id,
                      rating: _rating,
                      comment: _comment.text,
                      photoName: _photo?.name,
                      photoBytes: _photoBytes)) return;
                  context.read<ReviewsProvider>().add(
                      orderId: id,
                      email: email,
                      rating: _rating,
                      comment: _comment.text,
                      photoName: _photo?.name,
                      photoBytes: _photoBytes,
                      flavors: ((widget.order['items'] as List?) ?? const [])
                          .map((item) => item['name'] as String? ?? '')
                          .where((name) => name.isNotEmpty)
                          .toSet()
                          .toList());
                  context.read<PointsRepository>().awardFeedback(
                      context.read<AuthProvider>(),
                      email: email,
                      feedbackId: id);
                },
                child: const Text('Send feedback'))),
      ]);
}
