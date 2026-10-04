import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/requests_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/daily_batch_provider.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_screen_scaffold.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<RequestsProvider>().requests;
    return AppScreenScaffold(
        title: 'Requests',
        body: requests.isEmpty
            ? Center(
                child: Text('No customer requests yet.',
                    style: AppTextStyles.q(15, color: AppColors.textSecondary)))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _RequestCard(request: requests[index])));
  }
}

class _RequestCard extends StatefulWidget {
  final Map<String, dynamic> request;
  const _RequestCard({required this.request});
  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard> {
  final _reply = TextEditingController();
  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(request['email'] as String,
                        style: AppTextStyles.q(13, weight: FontWeight.w700))),
                Chip(label: Text(request['status'] as String))
              ]),
              const SizedBox(height: 5),
              Text(request['message'] as String),
              if (request['type'] == 'flavor')
                Text('${request['flavor']} · ${request['votes'] ?? 0} votes'),
              if (request['type'] == 'limit')
                Text('Requested additional cookies: ${request['cookies']}'),
              if ((request['reply'] as String?)?.isNotEmpty == true) ...[
                const Divider(height: 22),
                Text('Reply sent: ${request['reply']}')
              ] else if (request['type'] == null ||
                  request['type'] == 'chat' ||
                  (request['status'] == 'Open' && request['type'] != null)) ...[
                const SizedBox(height: 10),
                TextField(
                    controller: _reply,
                    decoration:
                        const InputDecoration(labelText: 'Reply to customer')),
                Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                        onPressed: () {
                          if (_reply.text.trim().isEmpty) return;
                          context
                              .read<RequestsProvider>()
                              .reply(request['id'] as String, _reply.text);
                          context.read<NotificationProvider>().add(
                              title: 'Staff replied',
                              message: _reply.text.trim(),
                              email: request['email'] as String);
                        },
                        child: const Text('Send reply')))
              ],
              if (request['status'] == 'Open' &&
                  request['type'] != null &&
                  request['type'] != 'chat') ...[
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () => _resolve(context, request, false),
                      child: const Text('Decline')),
                  const SizedBox(width: 8),
                  FilledButton(
                      onPressed: () => _resolve(context, request, true),
                      child: Text(request['type'] == 'allergy'
                          ? 'Approve order'
                          : 'Approve')),
                ]),
              ],
            ])));
  }

  void _resolve(
      BuildContext context, Map<String, dynamic> request, bool approve) {
    final id = request['id'] as String;
    final type = request['type'] as String;
    final decisionMessage = _reply.text.trim();
    if (type == 'limit' && approve) {
      context
          .read<DailyBatchProvider>()
          .increaseLimit(request['cookies'] as int);
    }
    if (type == 'allergy') {
      final orderId = request['orderId'] as String;
      final orders = context.read<OrderProvider>();
      if (approve) {
        orders.approveForPayment(orderId,
            message: decisionMessage.isEmpty ? null : decisionMessage);
      } else {
        orders.declineReview(
            orderId,
            decisionMessage.isEmpty
                ? 'The bakery could not safely fulfill this request. Please contact staff.'
                : decisionMessage);
      }
      context.read<NotificationProvider>().add(
          title: approve ? 'Order approved for payment' : 'Order review update',
          message: approve
              ? 'Order $orderId was approved. Payment is now available.'
              : (decisionMessage.isEmpty
                  ? 'Order $orderId was declined. Please contact bakery staff.'
                  : decisionMessage),
          email: request['email'] as String,
          orderId: orderId);
    }
    context.read<RequestsProvider>().setStatus(
        id, approve ? 'Approved' : 'Declined',
        reply: decisionMessage.isEmpty ? null : decisionMessage);
    if (type != 'allergy') {
      context.read<NotificationProvider>().add(
          title: 'Request update',
          message: decisionMessage.isEmpty
              ? (approve
                  ? 'Your $type request was approved.'
                  : 'Your $type request was declined.')
              : decisionMessage,
          email: request['email'] as String);
    }
  }
}
