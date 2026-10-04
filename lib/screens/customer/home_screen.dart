import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';

/// Home tab. Background gradient + bottom nav come from [CustomerShell].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Static demo data (swap for InventoryProvider / BatchService later).
  static const int _dailyLimit = 500;
  static const int _claimed = 300;
  static const int _cookiesLeft = 191;

  static const _specials = [
    ('Oatmeal Chocolate Chip', 220),
    ('Banana Oatmeal', 220),
    ('Cinnamon Oatmeal', 220),
  ];

  void _addBox(BuildContext context, String name, int price) {
    context.read<CartProvider>().addItem({
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'name': name,
      'price': price,
      'quantity': 1,
      'boxSize': 6,
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Added Box of 6 \u2013 $name')));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final username = auth.username ?? 'Customer';
    final unreadCount =
        context.watch<NotificationProvider>().unreadCountFor(auth.email ?? '');

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/logo.png',
                  width: 170, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi $username,', style: AppTextStyles.display1(28)),
                      Text('Good things are baking!',
                          style: AppTextStyles.q(16)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Marisol',
                              style:
                                  AppTextStyles.q(13, weight: FontWeight.w600)),
                          Text('Angeles City, Pampanga',
                              style: AppTextStyles.q(10)),
                        ],
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        tooltip: 'Notifications',
                        visualDensity: VisualDensity.compact,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/notifications'),
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_none_rounded,
                                color: AppColors.primary, size: 27),
                            if (unreadCount > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  constraints: const BoxConstraints(
                                      minWidth: 16, minHeight: 16),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('$unreadCount',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.q(9,
                                          weight: FontWeight.w700,
                                          color: Colors.white)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 138,
              child: Row(
                children: [
                  Expanded(flex: 8, child: _batchCard()),
                  const SizedBox(width: 12),
                  Expanded(flex: 5, child: _preorderCard(context)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _deliveryBanner(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text('Today\u2019s Specials',
                  style: AppTextStyles.display1(24)),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _specials.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(
                      child: _specialCard(
                          context, _specials[i].$1, _specials[i].$2)),
                ],
              ],
            ),
            const SizedBox(height: 14),
            _bulkCard(context),
            const SizedBox(height: 10),
            _infoBar(),
          ],
        ),
      ),
    );
  }

  Widget _batchCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\u2019s Batch',
              style: AppTextStyles.display1(20, color: Colors.white)),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$_cookiesLeft',
                  style: AppTextStyles.q(36,
                      weight: FontWeight.w700, color: Colors.white)),
              const SizedBox(width: 6),
              Text('cookies left',
                  style: AppTextStyles.q(20,
                      weight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          Text('$_claimed / $_dailyLimit claimed',
              style: AppTextStyles.q(12, color: Colors.white)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _claimed / _dailyLimit,
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
          const Spacer(),
          Text('Orders still Open  >',
              style: AppTextStyles.q(16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _preorderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tomorrow\u2019s Preorder',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.display1(15, color: Colors.white)),
          const SizedBox(height: 6),
          Text('Pick up / Delivery',
              style: AppTextStyles.q(10, color: Colors.white)),
          Text(AppFormatters.longDate(AppFormatters.tomorrow()),
              style: AppTextStyles.q(10, color: Colors.white)),
          const Spacer(),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.pushNamed(context, '/solo-order'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Pre-order for\nTomorrow',
                          style: AppTextStyles.q(11,
                              color: AppColors.textSecondary, height: 1.2)),
                    ),
                    const Icon(Icons.arrow_right_alt_rounded,
                        color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryBanner() {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tomorrow\u2019s Delivery',
                    style: AppTextStyles.display1(22)),
                const SizedBox(height: 4),
                Text('Pre-order today,\ndelivered tomorrow.',
                    style: AppTextStyles.q(15,
                        color: AppColors.textSecondary, height: 1.25)),
              ],
            ),
          ),
          Image.asset('assets/images/cat_delivery.png', height: 88),
        ],
      ),
    );
  }

  Widget _specialCard(BuildContext context, String name, int price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.55,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/cookie_oatmeal.png',
                    fit: BoxFit.cover),
                Positioned(
                  left: 8,
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    child: Text('In Stock',
                        style: AppTextStyles.q(8,
                            weight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: Text(name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.q(11, weight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Box of 6',
                style: AppTextStyles.q(9, color: AppColors.textSecondary)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: SizedBox(
              width: double.infinity,
              height: 30,
              child: ElevatedButton(
                onPressed: () => _addBox(context, name, price),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: FittedBox(
                  child: Text('Add Box to Cart',
                      style: AppTextStyles.q(11,
                          weight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulkCard(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.fromLTRB(18, 0, 14, 0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 6,
            child: Image.asset('assets/images/cats_bulk.png', height: 52),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bulk / Custom Order',
                    style: AppTextStyles.display1(22, color: Colors.white)),
                const SizedBox(height: 2),
                Text('For events, parties, and\nlarger packages.',
                    style:
                        AppTextStyles.q(14, color: Colors.white, height: 1.2)),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 12,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bulk orders coming soon.')),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Inquire Now',
                          style: AppTextStyles.q(12, weight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_right_alt_rounded,
                          size: 20, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFB9C6D6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Boxes: 3, 6, or 12 cookies',
              style: AppTextStyles.q(13, color: AppColors.textSecondary)),
          Container(width: 1, height: 14, color: AppColors.textSecondary),
          Text('Daily preorder limit: $_dailyLimit cookies',
              style: AppTextStyles.q(13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
