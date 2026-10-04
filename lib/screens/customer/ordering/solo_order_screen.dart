import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/quantity_selector.dart';

class SoloOrderScreen extends StatefulWidget {
  const SoloOrderScreen({super.key});

  @override
  State<SoloOrderScreen> createState() => _SoloOrderScreenState();
}

class _SoloOrderScreenState extends State<SoloOrderScreen> {
  int _quantity = 1;
  int _selectedBox = 0;
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final productName = args['name'] as String? ?? 'Oatmeal Chocolate Chip';
    final description = args['description'] as String? ??
        'Soft, chewy, and packed with\nchocolate chips and oats';
    final basePrice = (args['price'] as num?)?.toInt() ?? 220;
    final boxes = [
      (size: 3, price: (basePrice / 2).round()),
      (size: 6, price: basePrice),
      (size: 12, price: basePrice * 2),
    ];
    final box = boxes[_selectedBox];
    final total = box.price * _quantity;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                    ),
                    Text('Order Details',
                        style: AppTextStyles.q(20, weight: FontWeight.w500)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/cart'),
                      child: const Icon(Icons.shopping_cart_outlined,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/cookie_oatmeal.png',
                              width: 144,
                              height: 144,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName,
                                    style: AppTextStyles.q(30,
                                        weight: FontWeight.w700, height: 1.15)),
                                const SizedBox(height: 10),
                                Text(description,
                                    style: AppTextStyles.q(12,
                                        color: AppColors.textPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text('Choose Box Size',
                          style: AppTextStyles.q(20, weight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          for (var i = 0; i < boxes.length; i++) ...[
                            if (i > 0) const SizedBox(width: 12),
                            Expanded(child: _boxOption(i, boxes[i])),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Quantity',
                          style: AppTextStyles.q(20, weight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          QuantitySelector(
                            quantity: _quantity,
                            onDecrement: () => setState(() =>
                                _quantity = _quantity > 1 ? _quantity - 1 : 1),
                            onIncrement: () => setState(() => _quantity++),
                          ),
                          const Spacer(),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Total: ',
                                style: AppTextStyles.q(20,
                                    weight: FontWeight.w400)),
                            TextSpan(
                                text: AppFormatters.peso(total),
                                style: AppTextStyles.q(20,
                                    weight: FontWeight.w700)),
                          ])),
                          const SizedBox(width: 16),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color:
                                  AppColors.cardBorder.withValues(alpha: 0.6)),
                        ),
                        child: Text(
                          'This item is included in the daily preorder limit (500 cookies).',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.q(12,
                              color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('Special Requests',
                              style:
                                  AppTextStyles.q(20, weight: FontWeight.w700)),
                          const SizedBox(width: 10),
                          Text('(optional)', style: AppTextStyles.q(12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notes,
                        maxLines: 2,
                        minLines: 2,
                        style: AppTextStyles.q(14),
                        decoration: InputDecoration(
                          hintText: 'e.g, less sweet, extra chips',
                          hintStyle:
                              AppTextStyles.q(14, color: AppColors.textMuted),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.35),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: _fieldBorder(AppColors.cardBorder),
                          enabledBorder: _fieldBorder(AppColors.cardBorder),
                          focusedBorder: _fieldBorder(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () =>
                        _addToCart(productName, box.size, box.price),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: AppColors.primary.withValues(alpha: 0.3),
                      animationDuration: const Duration(milliseconds: 180),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_shopping_cart_rounded, size: 20),
                        const SizedBox(width: 9),
                        Text(
                          'Add to Cart  ·  ${AppFormatters.peso(total)}',
                          style: AppTextStyles.q(18,
                              weight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _fieldBorder(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.withValues(alpha: 0.8)),
      );

  void _addToCart(String name, int boxSize, int boxPrice) {
    // price = price of ONE box; CartProvider.total multiplies by quantity.
    context.read<CartProvider>().addItem({
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'name': name,
      'price': boxPrice,
      'quantity': _quantity,
      'boxSize': boxSize,
      'notes': _notes.text.trim(),
      'mixIns': const ['Chocolate Chips (included)'],
    });
    Navigator.pop(context);
  }

  Widget _boxOption(int index, ({int size, int price}) b) {
    final selected = _selectedBox == index;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => _selectedBox = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 150,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.cardBorder.withValues(alpha: 0.7),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    AppColors.primary.withValues(alpha: selected ? 0.18 : 0.06),
                blurRadius: selected ? 14 : 7,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                  child: Image.asset('assets/images/box_cookies.png',
                      fit: BoxFit.contain)),
              Text('Box of ${b.size}',
                  style: AppTextStyles.q(15,
                      weight: selected ? FontWeight.w700 : FontWeight.w500)),
              Text(AppFormatters.peso(b.price),
                  style: AppTextStyles.q(15,
                      weight: selected ? FontWeight.w700 : FontWeight.w500)),
              const SizedBox(height: 6),
              _radio(selected),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _radio(bool selected) {
  return Container(
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
  );
}
