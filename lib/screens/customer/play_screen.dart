import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/play_provider.dart';
import '../../repositories/points_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_screen_scaffold.dart';

enum _BakeResult { perfect, good, burnt }

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with TickerProviderStateMixin {
  static const _goldenStart = 0.45;
  static const _goldenEnd = 0.55;
  static const _goodStart = 0.29;
  static const _goodEnd = 0.71;
  static const _roundsPerGame = 5;

  late final AnimationController _heatController;
  late final AnimationController _cookieColorController;
  final FocusNode _keyboardFocus = FocusNode(debugLabel: 'Perfect Bake game');

  _BakeResult? _roundResult;
  Color _cookieTargetColor = _rawCookieColor;
  int _round = 0;
  int _gamePoints = 0;
  bool _gameStarted = false;
  bool _gameFinished = false;
  bool _pointPop = false;
  int _pointPopGeneration = 0;

  static const _rawCookieColor = Color(0xFFD9C39F);
  static const _goldenCookieColor = Color(0xFFE0AD57);
  static const _goodCookieColor = Color(0xFFC9954F);
  static const _burntCookieColor = Color(0xFF65483A);

  @override
  void initState() {
    super.initState();
    _heatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _cookieColorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    _heatController.dispose();
    _cookieColorController.dispose();
    _keyboardFocus.dispose();
    super.dispose();
  }

  bool get _reduceMotion => MediaQuery.of(context).disableAnimations;

  Duration _roundDuration(int round) {
    final baseMilliseconds = 2000 - (round - 1) * 250;
    final reducedSpeed = _reduceMotion ? 1.7 : 1.0;
    return Duration(milliseconds: (baseMilliseconds * reducedSpeed).round());
  }

  void _startGame() {
    final email = context.read<AuthProvider>().email ?? '';
    if (!context.read<PlayProvider>().startPlay(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have used all 3 plays for today.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      _round = 1;
      _gamePoints = 0;
      _roundResult = null;
      _gameStarted = true;
      _gameFinished = false;
      _cookieTargetColor = _rawCookieColor;
      _cookieColorController.value = 1;
    });
    _keyboardFocus.requestFocus();
    _startHeatBar();
  }

  void _startHeatBar() {
    _heatController
      ..stop()
      ..duration = _roundDuration(_round)
      ..value = 0
      ..repeat(reverse: true);
  }

  void _handlePrimaryAction() {
    _keyboardFocus.requestFocus();
    if (!_gameStarted) {
      _startGame();
    } else if (_roundResult == null) {
      _stopHeatBar();
    } else if (_round < _roundsPerGame) {
      _nextRound();
    } else {
      _startGame();
    }
  }

  void _stopHeatBar() {
    if (!_gameStarted || _roundResult != null) return;
    _heatController.stop();
    final position = _heatController.value;
    final result = _judge(position);
    final points = switch (result) {
      _BakeResult.perfect => 3,
      _BakeResult.good => 1,
      _BakeResult.burnt => 0,
    };
    final auth = context.read<AuthProvider>();
    final email = auth.email ?? '';
    if (points > 0) {
      context.read<PointsRepository>().awardGamePoints(
            auth,
            email: email,
            points: points,
          );
    }
    setState(() {
      _roundResult = result;
      _gamePoints += points;
      _cookieTargetColor = switch (result) {
        _BakeResult.perfect => _goldenCookieColor,
        _BakeResult.good => _goodCookieColor,
        _BakeResult.burnt => _burntCookieColor,
      };
      if (_reduceMotion) {
        _cookieColorController.value = 1;
      } else {
        _cookieColorController.forward(from: 0);
      }
      if (_round == _roundsPerGame) {
        _gameFinished = true;
        _gameStarted = false;
      }
      if (points > 0 && !_reduceMotion) _pointPop = true;
    });
    if (points > 0 && !_reduceMotion) {
      final generation = ++_pointPopGeneration;
      Future<void>.delayed(const Duration(milliseconds: 180), () {
        if (mounted && generation == _pointPopGeneration) {
          setState(() => _pointPop = false);
        }
      });
    }
  }

  _BakeResult _judge(double position) {
    if (position >= _goldenStart && position <= _goldenEnd) {
      return _BakeResult.perfect;
    }
    if (position >= _goodStart && position <= _goodEnd) {
      return _BakeResult.good;
    }
    return _BakeResult.burnt;
  }

  void _nextRound() {
    setState(() {
      _round++;
      _roundResult = null;
      _cookieTargetColor = _rawCookieColor;
      _cookieColorController.value = 1;
    });
    _startHeatBar();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      _handlePrimaryAction();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  String get _resultLabel => switch (_roundResult) {
        _BakeResult.perfect => 'Perfect! +3 points',
        _BakeResult.good => 'Good! +1 point',
        _BakeResult.burnt => 'Burnt — 0 points',
        null => '',
      };

  Color get _resultColor => switch (_roundResult) {
        _BakeResult.perfect => const Color(0xFF39744D),
        _BakeResult.good => AppColors.primary,
        _BakeResult.burnt => _burntCookieColor,
        null => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.email ?? '';
    final plays = context.watch<PlayProvider>();
    final points = auth.currentUser?.points ?? 0;
    final roundLabel = _round == 0 ? 1 : _round;

    return AppScreenScaffold(
      title: 'Perfect Bake',
      body: Focus(
        focusNode: _keyboardFocus,
        onKeyEvent: _onKeyEvent,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Find the golden moment',
                          style: AppTextStyles.display1(25)),
                      const SizedBox(height: 4),
                      Text('Stop the heat bar in the green zone.',
                          style: AppTextStyles.q(14,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _pointsBadge(points),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                      'ROUND', '$_round / $_roundsPerGame'),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _infoTile(
                    'PLAYS LEFT',
                    '${plays.playsRemainingFor(email)}',
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(child: _infoTile('GAME', '$_gamePoints pts')),
              ],
            ),
            const SizedBox(height: 14),
            AppCard(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handlePrimaryAction,
                child: Semantics(
                  button: true,
                  label: _gameStarted && _roundResult == null
                      ? 'Oven. Tap or press Space to stop the moving heat bar.'
                      : 'Oven. Tap or press Space to continue the game.',
                  child: SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: AnimatedBuilder(
                      animation: Listenable.merge(
                          [_heatController, _cookieColorController]),
                      builder: (context, child) => CustomPaint(
                        painter: _PerfectBakePainter(
                          heatPosition: _heatController.value,
                          cookieColor: Color.lerp(
                                _rawCookieColor,
                                _cookieTargetColor,
                                _cookieColorController.value,
                              ) ??
                              _cookieTargetColor,
                          isMoving: _gameStarted && _roundResult == null,
                          round: roundLabel,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              label: _roundResult == null
                  ? 'Round $_round of $_roundsPerGame. ${_gameStarted ? 'Heat bar moving.' : 'Ready to start.'}'
                  : 'Round $_round result: $_resultLabel',
              child: Center(
                child: Text(
                  _roundResult == null
                      ? _gameStarted
                          ? 'Tap the oven or press Space to stop the bar'
                          : 'One play is five rounds'
                      : _resultLabel,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.q(17,
                      weight: FontWeight.w700,
                      color: _roundResult == null
                          ? AppColors.textSecondary
                          : _resultColor),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _buttonEnabled(plays.playsRemainingFor(email))
                    ? _handlePrimaryAction
                    : null,
                icon: Icon(_buttonIcon),
                label: Text(_buttonLabel(plays.playsRemainingFor(email))),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Perfect: 3 points · Good: 1 point · Burnt: 0 points · 3 plays per user each day',
              textAlign: TextAlign.center,
              style: AppTextStyles.q(12, color: AppColors.textSecondary),
            ),
            if (_gameFinished) ...[
              const SizedBox(height: 8),
              Text(
                'Game complete! You earned $_gamePoints points this game.',
                textAlign: TextAlign.center,
                style: AppTextStyles.q(14, weight: FontWeight.w700),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _buttonEnabled(int playsRemaining) {
    if (_gameStarted) return true;
    if (_roundResult != null && _round < _roundsPerGame) return true;
    if (_gameFinished || _round == 0) return playsRemaining > 0;
    return false;
  }

  String _buttonLabel(int playsRemaining) {
    if (_gameStarted && _roundResult == null) return 'Stop the heat';
    if (_roundResult != null && _round < _roundsPerGame) return 'Next round';
    if (_gameFinished) {
      return playsRemaining > 0 ? 'Play another game' : 'Daily plays used';
    }
    return playsRemaining > 0 ? 'Start a 5-round game' : 'Daily plays used';
  }

  IconData get _buttonIcon {
    if (_gameStarted && _roundResult == null) return Icons.pan_tool_alt_rounded;
    if (_roundResult != null && _round < _roundsPerGame) {
      return Icons.arrow_forward_rounded;
    }
    return Icons.play_arrow_rounded;
  }

  Widget _pointsBadge(int points) => AnimatedScale(
        scale: !_reduceMotion && _pointPop ? 1.12 : 1,
        duration: _reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 160),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [AppColors.heroShadow],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text('$points pts',
                  style: AppTextStyles.q(13,
                      weight: FontWeight.w700, color: Colors.white)),
            ],
          ),
        ),
      );

  Widget _infoTile(String title, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.q(9,
                    weight: FontWeight.w700,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: AppTextStyles.q(16, weight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

class _PerfectBakePainter extends CustomPainter {
  const _PerfectBakePainter({
    required this.heatPosition,
    required this.cookieColor,
    required this.isMoving,
    required this.round,
  });

  final double heatPosition;
  final Color cookieColor;
  final bool isMoving;
  final int round;

  static const _goldenZoneColor = Color(0xFF72A57A);

  @override
  void paint(Canvas canvas, Size size) {
    final ovenRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.08,
      size.width * 0.8,
      size.height * 0.84,
    );
    final ovenRRect = RRect.fromRectAndRadius(
      ovenRect,
      const Radius.circular(22),
    );
    canvas.drawRRect(ovenRRect, Paint()..color = AppColors.primary);
    canvas.drawRRect(
      ovenRRect,
      Paint()
        ..color = AppColors.textSecondary.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final window = Rect.fromLTWH(
      ovenRect.left + size.width * 0.07,
      ovenRect.top + size.height * 0.08,
      ovenRect.width - size.width * 0.14,
      size.height * 0.48,
    );
    final windowRRect = RRect.fromRectAndRadius(
      window,
      const Radius.circular(14),
    );
    canvas.drawRRect(
      windowRRect,
      Paint()..color = const Color(0xFF182A39),
    );
    canvas.drawRRect(
      windowRRect,
      Paint()
        ..color = AppColors.accentSoft.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final cookieCenter = Offset(size.width / 2, window.center.dy + 2);
    canvas.drawCircle(
      cookieCenter,
      size.width * 0.105,
      Paint()..color = cookieColor,
    );
    final chips = Paint()..color = AppColors.primary;
    for (final chip in const [
      Offset(-0.35, -0.25),
      Offset(0.28, -0.3),
      Offset(-0.1, 0.3),
      Offset(0.4, 0.25),
    ]) {
      canvas.drawCircle(
        cookieCenter + Offset(chip.dx * size.width * 0.1,
            chip.dy * size.width * 0.1),
        size.width * 0.012,
        chips,
      );
    }

    final gauge = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.71,
      size.width * 0.6,
      size.height * 0.13,
    );
    final gaugeRRect = RRect.fromRectAndRadius(
      gauge,
      const Radius.circular(9),
    );
    canvas.drawRRect(gaugeRRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      gaugeRRect,
      Paint()
        ..color = AppColors.cardBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final goldenRect = Rect.fromLTWH(
      gauge.left + gauge.width * 0.45,
      gauge.top,
      gauge.width * 0.1,
      gauge.height,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(goldenRect, const Radius.circular(5)),
      Paint()..color = _goldenZoneColor,
    );

    final heatX = gauge.left + gauge.width * heatPosition;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(heatX, gauge.center.dy),
          width: math.max(7, size.width * 0.027).toDouble(),
          height: gauge.height + 18,
        ),
        const Radius.circular(5),
      ),
      Paint()..color = AppColors.accent,
    );

    final labelPainter = TextPainter(
      text: TextSpan(
        text: 'ROUND $round  ·  ${isMoving ? 'BAKING' : 'OVEN READY'}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width * 0.72);
    labelPainter.paint(
      canvas,
      Offset((size.width - labelPainter.width) / 2, size.height * 0.875),
    );
  }

  @override
  bool shouldRepaint(covariant _PerfectBakePainter oldDelegate) =>
      oldDelegate.heatPosition != heatPosition ||
      oldDelegate.cookieColor != cookieColor ||
      oldDelegate.isMoving != isMoving ||
      oldDelegate.round != round;
}
