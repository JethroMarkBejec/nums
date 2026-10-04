import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../providers/order_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shows the local order stage. The demo app uses ChangeNotifier updates; a
/// Firestore snapshot stream can replace this provider when a backend exists.
class LiveBakeTracker extends StatefulWidget {
  const LiveBakeTracker({
    super.key,
    required this.orderId,
    required this.email,
    this.showDemoButton = false,
  });

  final String orderId;
  final String email;
  final bool showDemoButton;

  @override
  State<LiveBakeTracker> createState() => _LiveBakeTrackerState();
}

class _LiveBakeTrackerState extends State<LiveBakeTracker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  Timer? _demoTimer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _motion.stop();
      _motion.value = 0.5;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    _motion.dispose();
    super.dispose();
  }

  void _runDemo() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _demoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final advanced =
          context.read<OrderProvider>().advanceStatus(widget.orderId);
      if (!advanced) {
        timer.cancel();
        setState(() => _isRunning = false);
        return;
      }
      final order = context.read<OrderProvider>().orderById(widget.orderId);
      final stage = order?['status'] as String? ?? 'Updated';
      context.read<NotificationProvider>().add(
            title: 'Bake tracker update',
            message: 'Order ${widget.orderId} is now $stage.',
            email: widget.email,
            orderId: widget.orderId,
          );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Your cookies are now: $stage'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ));
      if (stage == OrderProvider.finalStatus) {
        timer.cancel();
        setState(() => _isRunning = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().orderById(widget.orderId);
    final stage = order?['status'] as String? ?? OrderProvider.statuses.first;
    final index = OrderProvider.statuses
        .indexOf(stage)
        .clamp(0, OrderProvider.statuses.length - 1)
        .toInt();
    final progress = (index + 1) / OrderProvider.statuses.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Live bake tracker',
                    style: AppTextStyles.q(18, weight: FontWeight.w700)),
              ),
              Text('${index + 1} / ${OrderProvider.statuses.length}',
                  style: AppTextStyles.q(12,
                      weight: FontWeight.w700, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 86,
                height: 78,
                child: AnimatedBuilder(
                  animation: _motion,
                  builder: (context, _) => CustomPaint(
                    painter: _BakeStagePainter(
                      stageIndex: index,
                      phase: _motion.value,
                      reduceMotion: MediaQuery.of(context).disableAnimations,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  label: 'Order stage: $stage',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stage,
                          style: AppTextStyles.q(16, weight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(_stageMessage(index),
                          style: AppTextStyles.q(12,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '${OrderProvider.statuses.take(index + 1).join('  ·  ')}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.q(10, color: AppColors.textSecondary),
          ),
          if (widget.showDemoButton) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _isRunning || stage == OrderProvider.finalStatus
                    ? null
                    : _runDemo,
                icon: Icon(_isRunning
                    ? Icons.hourglass_top_rounded
                    : Icons.play_arrow_rounded),
                label: Text(_isRunning ? 'Running…' : 'Run demo'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _stageMessage(int index) => switch (index) {
        0 => 'Your order is confirmed and in our queue.',
        1 => 'We are mixing your cookie dough.',
        2 => 'Your cookies are baking in the oven.',
        3 => 'The fresh batch is cooling.',
        4 => 'Your cookies are being packed with care.',
        5 => 'Your order is ready for pickup or delivery.',
        _ => 'Your order has been received. Enjoy your cookies!',
      };
}

class _BakeStagePainter extends CustomPainter {
  const _BakeStagePainter({
    required this.stageIndex,
    required this.phase,
    required this.reduceMotion,
  });

  final int stageIndex;
  final double phase;
  final bool reduceMotion;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ink = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = AppColors.accentSoft
      ..style = PaintingStyle.fill;
    final t = reduceMotion ? 0.5 : phase;

    switch (stageIndex) {
      case 0: // confirmed order, gently pulsing cookie stamp
        final pulse = 1 + math.sin(t * math.pi * 2) * 0.04;
        canvas.drawCircle(center, 24 * pulse, fill);
        canvas.drawCircle(center, 20 * pulse, ink);
        final check = Path()
          ..moveTo(center.dx - 9, center.dy)
          ..lineTo(center.dx - 2, center.dy + 7)
          ..lineTo(center.dx + 11, center.dy - 9);
        canvas.drawPath(check, ink);
        break;
      case 1: // wobbling mixing bowl
        final angle = reduceMotion ? 0.0 : math.sin(t * math.pi * 2) * 0.12;
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(angle);
        canvas.translate(-center.dx, -center.dy);
        canvas.drawArc(Rect.fromCenter(center: center, width: 48, height: 44),
            0, math.pi, false, ink);
        canvas.drawLine(Offset(center.dx - 24, center.dy),
            Offset(center.dx + 24, center.dy), ink);
        canvas.drawLine(Offset(center.dx - 18, center.dy + 1),
            Offset(center.dx - 11, center.dy + 19), ink);
        canvas.drawLine(Offset(center.dx + 18, center.dy + 1),
            Offset(center.dx + 11, center.dy + 19), ink);
        canvas.drawLine(Offset(center.dx - 11, center.dy + 19),
            Offset(center.dx + 11, center.dy + 19), ink);
        canvas.restore();
        break;
      case 2: // glowing oven and puffing cookies
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(center: center, width: 52, height: 58),
                const Radius.circular(8)),
            fill);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(center: center, width: 52, height: 58),
                const Radius.circular(8)),
            ink);
        final glow = Paint()
          ..color = AppColors.accent.withValues(alpha: 0.4 + t * 0.3);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset(center.dx, center.dy + 4),
                    width: 36,
                    height: 30),
                const Radius.circular(5)),
            glow);
        canvas.drawCircle(Offset(center.dx - 8, center.dy + 5), 4, ink);
        canvas.drawCircle(Offset(center.dx + 8, center.dy + 5), 4, ink);
        canvas.drawCircle(Offset(center.dx + 18, center.dy - 20), 2, ink);
        break;
      case 3: // cooling cookies and rising steam
        canvas.drawLine(Offset(center.dx - 25, center.dy + 18),
            Offset(center.dx + 25, center.dy + 18), ink);
        for (var i = 0; i < 3; i++) {
          final x = center.dx - 15 + i * 15;
          canvas.drawCircle(Offset(x, center.dy + 8), 5, fill);
          canvas.drawCircle(Offset(x, center.dy + 8), 5, ink);
          final lift = reduceMotion ? 3.0 : 3 + ((t + i * 0.22) % 1) * 8;
          final steam = Path()
            ..moveTo(x, center.dy - 1)
            ..cubicTo(x - 5, center.dy - lift, x + 5, center.dy - lift - 5, x,
                center.dy - lift - 12);
          canvas.drawPath(steam, ink);
        }
        break;
      case 4: // box flaps closing
        final flap = reduceMotion ? 0.5 : t;
        final topY = center.dy - 7 + flap * 11;
        final box = Path()
          ..moveTo(center.dx - 22, center.dy - 7)
          ..lineTo(center.dx, center.dy + 2)
          ..lineTo(center.dx + 22, center.dy - 7)
          ..lineTo(center.dx + 22, center.dy + 17)
          ..lineTo(center.dx, center.dy + 27)
          ..lineTo(center.dx - 22, center.dy + 17)
          ..close();
        canvas.drawPath(box, fill);
        canvas.drawPath(box, ink);
        canvas.drawLine(Offset(center.dx, center.dy + 2),
            Offset(center.dx, center.dy + 27), ink);
        canvas.drawLine(Offset(center.dx - 22, topY),
            Offset(center.dx, center.dy + 2), ink);
        canvas.drawLine(Offset(center.dx + 22, topY),
            Offset(center.dx, center.dy + 2), ink);
        break;
      default: // sliding pickup bag / bicycle
        final dx = reduceMotion ? 0.0 : math.sin(t * math.pi * 2) * 7;
        canvas.drawCircle(center.translate(-17 + dx, 15), 8, ink);
        canvas.drawCircle(center.translate(18 + dx, 15), 8, ink);
        canvas.drawLine(
            center.translate(-17 + dx, 15), center.translate(-5 + dx, -2), ink);
        canvas.drawLine(
            center.translate(-5 + dx, -2), center.translate(4 + dx, 15), ink);
        canvas.drawLine(
            center.translate(4 + dx, 15), center.translate(-17 + dx, 15), ink);
        canvas.drawLine(
            center.translate(-5 + dx, -2), center.translate(18 + dx, 15), ink);
        final bag = Rect.fromCenter(
            center: center.translate(8 + dx, -8), width: 21, height: 19);
        canvas.drawRRect(
            RRect.fromRectAndRadius(bag, const Radius.circular(4)), fill);
        canvas.drawRRect(
            RRect.fromRectAndRadius(bag, const Radius.circular(4)), ink);
        canvas.drawLine(
            center.translate(4 + dx, -19), center.translate(13 + dx, -19), ink);
    }
  }

  @override
  bool shouldRepaint(covariant _BakeStagePainter oldDelegate) =>
      oldDelegate.stageIndex != stageIndex ||
      oldDelegate.phase != phase ||
      oldDelegate.reduceMotion != reduceMotion;
}
