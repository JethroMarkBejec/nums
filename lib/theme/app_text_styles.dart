import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Quicksand is used throughout for a consistent, polished typographic system.
class AppTextStyles {
  static const String body = 'Quicksand';
  static const double scaleFactor = 0.95;

  static TextStyle q(
    double size, {
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: body,
      fontSize: size * scaleFactor < 10.5 ? 10.5 : size * scaleFactor,
      fontWeight: weight,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: color,
    );
  }

  static TextStyle display1(
    double size, {
    Color color = AppColors.textPrimary,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: body,
      fontSize: size * scaleFactor,
      fontWeight: FontWeight.w700,
      fontVariations: [FontVariation('wght', FontWeight.w700.value.toDouble())],
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle fun(double size, {Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontFamily: 'Gaegu',
      fontSize: size * scaleFactor,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  // Kept for backwards compatibility with the older screens.
  static final TextStyle headline1 =
      q(32, weight: FontWeight.w700, letterSpacing: -0.5);
  static final TextStyle headline2 = q(24, weight: FontWeight.w700);
  static final TextStyle bodyLarge = q(16, weight: FontWeight.w500);
  static final TextStyle bodyMedium = q(14, weight: FontWeight.w400);
  static final TextStyle label =
      q(12, weight: FontWeight.w600, letterSpacing: 0.5);
}
