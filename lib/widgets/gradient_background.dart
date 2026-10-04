import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The light-blue -> white vertical gradient used behind every screen.
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientTop, AppColors.gradientBottom],
        ),
      ),
      child: SizedBox.expand(child: child),
    );
  }
}
