import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final double height;
  final double fontSize;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = true,
    this.height = 52,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.86),
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white70,
          elevation: isPrimary ? 3 : 1,
          shadowColor: AppColors.primary.withValues(alpha: 0.28),
          surfaceTintColor: Colors.white,
          animationDuration: const Duration(milliseconds: 180),
          overlayColor: Colors.white.withValues(alpha: 0.12),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isPrimary ? Colors.transparent : AppColors.cardBorder,
              width: 1,
            ),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: Text(
            label,
            key: ValueKey(label),
            style: AppTextStyles.q(
              fontSize,
              weight: FontWeight.w700,
              color: isPrimary ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
