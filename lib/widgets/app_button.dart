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
    this.height = 56,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(
              color: isPrimary ? Colors.transparent : AppColors.inputBorder,
              width: 1.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.q(
            fontSize,
            weight: FontWeight.w600,
            color: isPrimary ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
