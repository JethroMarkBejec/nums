import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Translucent rounded card with a thin blue outline.
class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 18, 18, 18),
    this.color,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: reduceMotion ? 1 : 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        width: double.infinity,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: AppColors.cardBorder.withValues(alpha: 0.68)),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.primary.withValues(alpha: _hovered ? 0.16 : 0.10),
              blurRadius: _hovered ? 27 : 22,
              offset: Offset(0, _hovered ? 12 : 9),
            ),
            const BoxShadow(
              color: Color(0x70FFFFFF),
              blurRadius: 2,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

/// Card title + optional trailing widget + divider (e.g. "Order Summary  Edit").
class AppCardHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const AppCardHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.q(20, weight: FontWeight.w700)),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}

/// "Label ........ value" row used in summaries.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const InfoRow(
      {super.key, required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style =
        AppTextStyles.q(15, weight: bold ? FontWeight.w700 : FontWeight.w500);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style),
        const SizedBox(width: 12),
        Flexible(child: Text(value, style: style, textAlign: TextAlign.right)),
      ],
    );
  }
}
