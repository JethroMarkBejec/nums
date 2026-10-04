import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final total = cart.total;

    return AppScreenScaffold(
      title: 'Your Cart',
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.62),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined,
                          color: AppColors.primary, size: 42),
                    ),
                    const SizedBox(height: 20),
                    Text('Your cart is empty',
                        style: AppTextStyles.display1(30),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('Your next batch of cookies is just a few taps away.',
                        style:
                            AppTextStyles.q(15, color: AppColors.textSecondary),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return AppCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                    'assets/images/box_cookies.png',
                                    width: 86,
                                    height: 86,
                                    fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'] as String,
                                        style: AppTextStyles.q(17,
                                            weight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(
                                        'Box of ${item['boxSize'] ?? 6}  ·  Qty ${item['quantity']}',
                                        style: AppTextStyles.q(13,
                                            color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      AppFormatters.peso(
                                          (item['price'] as num) *
                                              (item['quantity'] as int)),
                                      style: AppTextStyles.q(16,
                                          weight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _quantityButton(
                                        icon: Icons.remove_rounded,
                                        onTap: () => cart.setQuantity(
                                            item['id'] as String,
                                            (item['quantity'] as int) - 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        child: Text('${item['quantity']}',
                                            style: AppTextStyles.q(14,
                                                weight: FontWeight.w700)),
                                      ),
                                      _quantityButton(
                                        icon: Icons.add_rounded,
                                        onTap: () => cart.setQuantity(
                                            item['id'] as String,
                                            (item['quantity'] as int) + 1),
                                      ),
                                      IconButton(
                                        tooltip: 'Remove item',
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () => cart
                                            .removeItem(item['id'] as String),
                                        icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.error,
                                            size: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order total', style: AppTextStyles.q(17)),
                            Text(AppFormatters.peso(total),
                                style: AppTextStyles.q(22,
                                    weight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/payment'),
                            icon: const Icon(Icons.lock_outline_rounded),
                            label: Text('Continue to payment',
                                style: AppTextStyles.q(16,
                                    weight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shadowColor:
                                  AppColors.primary.withValues(alpha: 0.28),
                              animationDuration:
                                  const Duration(milliseconds: 180),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _quantityButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorder),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
