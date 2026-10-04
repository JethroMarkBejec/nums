import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Pill-shaped text field (login/signup style).
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final double fontSize;
  final double verticalPadding;

  const AppTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.fontSize = 16,
    this.verticalPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.5),
    );
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      style: AppTextStyles.q(fontSize, weight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: labelText, // the design shows the label as the placeholder
        hintStyle: AppTextStyles.q(fontSize, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.25),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: verticalPadding,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: AppTextStyles.q(12, color: AppColors.error),
      ),
    );
  }
}
