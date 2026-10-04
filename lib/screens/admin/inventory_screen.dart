import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';
import '../../widgets/status_badge.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>().inventory;
    final totalBoxes = inventory.fold<int>(
      0,
      (sum, item) => sum + (item['quantity'] as int),
    );

    return AppScreenScaffold(
      title: 'Inventory',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Stock overview', style: AppTextStyles.display1(30)),
          const SizedBox(height: 5),
          Text('Current finished-cookie stock by variety.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: Colors.white, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Text('$totalBoxes finished boxes in stock',
                      style: AppTextStyles.q(17,
                          weight: FontWeight.w700, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final item in inventory) ...[
            Builder(builder: (context) {
              final id = item['id'] as String;
              final name = item['name'] as String;
              final quantity = item['quantity'] as int;
              final unit = item['unit'] as String;
              final lowStock = quantity <= 20;
              return AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.accentSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.cookie_outlined,
                          color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style:
                                  AppTextStyles.q(16, weight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text('$quantity $unit',
                              style: AppTextStyles.q(13,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          StatusBadge(
                            text: lowStock ? 'Low stock' : 'In stock',
                            color: lowStock
                                ? AppColors.warning
                                : AppColors.success,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Add one $unit',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => context
                              .read<InventoryProvider>()
                              .adjustStock(id, 1),
                          icon: const Icon(Icons.add_circle_outline_rounded,
                              color: AppColors.primary),
                        ),
                        IconButton(
                          tooltip: 'Remove one $unit',
                          visualDensity: VisualDensity.compact,
                          onPressed: quantity == 0
                              ? null
                              : () => context
                                  .read<InventoryProvider>()
                                  .adjustStock(id, -1),
                          icon: const Icon(Icons.remove_circle_outline_rounded,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
