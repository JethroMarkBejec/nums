import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import 'gradient_background.dart';

class AppScreenScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const AppScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(title, style: AppTextStyles.display1(24)),
          actions: actions,
        ),
        body: SafeArea(top: false, child: body),
      ),
    );
  }
}
