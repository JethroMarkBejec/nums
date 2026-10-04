import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final email = context.watch<AuthProvider>().email ?? '';
    final notifications = provider.forEmail(email);
    final unreadCount = provider.unreadCountFor(email);
    return AppScreenScaffold(
      title: 'Notifications',
      body: Column(
        children: [
          if (unreadCount > 0)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => provider.markAllAsRead(email),
                icon: const Icon(Icons.done_all_rounded),
                label: const Text('Mark all read'),
              ),
            ),
          Expanded(
            child: notifications.isEmpty
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
                            child: const Icon(Icons.notifications_none_rounded,
                                color: AppColors.primary, size: 46),
                          ),
                          const SizedBox(height: 20),
                          Text('All caught up',
                              style: AppTextStyles.display1(30)),
                          const SizedBox(height: 8),
                          Text('Order updates will show up here.',
                              style: AppTextStyles.q(15,
                                  color: AppColors.textSecondary),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final unread = item['isRead'] != true;
                      final createdAt = item['createdAt'] as DateTime;
                      return AppCard(
                        color: unread
                            ? Colors.white.withValues(alpha: 0.88)
                            : null,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => provider.markRead(item['id'] as String),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                unread
                                    ? Icons.notifications_active_rounded
                                    : Icons.notifications_none_rounded,
                                color: unread
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['title'] as String,
                                        style: AppTextStyles.q(16,
                                            weight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(item['message'] as String,
                                        style: AppTextStyles.q(14,
                                            color: AppColors.textSecondary)),
                                    const SizedBox(height: 6),
                                    Text(AppFormatters.longDate(createdAt),
                                        style: AppTextStyles.q(11,
                                            color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              if (unread)
                                const Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Icon(Icons.circle,
                                      color: AppColors.primary, size: 9),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
