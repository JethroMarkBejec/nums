import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// "-  [ 1 ]  +" stepper from the Order Details design.
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 196,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _cell('-', onDecrement, Colors.white.withValues(alpha: 0.35)),
          Expanded(
            child: Center(
              child: Text('$quantity',
                  style: AppTextStyles.q(20, weight: FontWeight.w700)),
            ),
          ),
          _cell('+', onIncrement, AppColors.accentSoft),
        ],
      ),
    );
  }

  Widget _cell(String symbol, VoidCallback onTap, Color fill) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 43,
        height: double.infinity,
        color: fill,
        alignment: Alignment.center,
        child:
            Text(symbol, style: AppTextStyles.q(20, weight: FontWeight.w700)),
      ),
    );
  }
}
