import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: MouseRegion(
        onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: enabled ? (_) => setState(() => _hovered = false) : null,
        child: Listener(
          onPointerDown:
              enabled ? (_) => setState(() => _pressed = true) : null,
          onPointerUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onPointerCancel:
              enabled ? (_) => setState(() => _pressed = false) : null,
          child: AnimatedScale(
            scale: _pressed ? 0.975 : (_hovered ? 1.015 : 1),
            duration: Duration(milliseconds: reduceMotion ? 1 : 150),
            curve: Curves.easeOutCubic,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isPrimary
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.86),
                foregroundColor:
                    widget.isPrimary ? Colors.white : AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.4),
                disabledForegroundColor: Colors.white70,
                elevation: widget.isPrimary ? 5 : 2,
                shadowColor: AppColors.primary.withValues(alpha: 0.32),
                surfaceTintColor: Colors.white,
                animationDuration: const Duration(milliseconds: 220),
                overlayColor: Colors.white.withValues(alpha: 0.12),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: widget.isPrimary
                        ? Colors.transparent
                        : AppColors.cardBorder,
                    width: 1,
                  ),
                ),
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: reduceMotion ? 1 : 180),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: Text(
                  widget.label,
                  key: ValueKey(widget.label),
                  style: AppTextStyles.q(
                    widget.fontSize,
                    weight: FontWeight.w700,
                    color: widget.isPrimary
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
