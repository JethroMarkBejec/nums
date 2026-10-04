import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_screen_scaffold.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'id': 'cookie-1',
        'name': 'Butter Cookie',
        'price': 120,
        'description': 'Classic buttery cookie.'
      },
      {
        'id': 'cookie-2',
        'name': 'Chocolate Chip',
        'price': 150,
        'description': 'Loaded with chocolate chips.'
      },
      {
        'id': 'cookie-3',
        'name': 'Sugar Cookie',
        'price': 130,
        'description': 'Soft, sweet, and festive.'
      },
    ];

    return AppScreenScaffold(
      title: 'Fresh from the oven',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('The cookie menu', style: AppTextStyles.display1(30)),
          const SizedBox(height: 4),
          Text('Small-batch favorites, baked fresh for tomorrow.',
              style: AppTextStyles.q(14, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const SizedBox(height: 12),
            _MenuItem(item: items[index]),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Order today for pickup or delivery tomorrow.',
                      style: AppTextStyles.q(14, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _MenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.74),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            Navigator.pushNamed(context, '/solo-order', arguments: item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset('assets/images/cookie_oatmeal.png',
                    width: 82, height: 82, fit: BoxFit.cover),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'] as String,
                        style: AppTextStyles.q(17, weight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(item['description'] as String,
                        style: AppTextStyles.q(13,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Box of 6',
                        style: AppTextStyles.q(12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₱${item['price']}',
                      style: AppTextStyles.q(16, weight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: AppColors.primary, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
