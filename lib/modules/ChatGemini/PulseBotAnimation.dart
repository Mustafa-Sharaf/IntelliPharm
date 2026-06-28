import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

const double EYE_RX = 1.0;
const double EYE_RY = 2.2;

class Waypoint {
  final double dx;
  final double dy;
  final Duration holdRange;
  final double moveDurSeconds;
  const Waypoint({required this.dx, required this.dy, required this.holdRange, required this.moveDurSeconds});
}

const List<Waypoint> WAYPOINTS = [
  Waypoint(dx: 0.0, dy: 0.0, holdRange: Duration(milliseconds: 1200), moveDurSeconds: 0.55),
  Waypoint(dx: -1.9, dy: 0.55, holdRange: Duration(milliseconds: 850), moveDurSeconds: 0.32),
  Waypoint(dx: -1.8, dy: 0.0, holdRange: Duration(milliseconds: 600), moveDurSeconds: 0.5),
  Waypoint(dx: -1.0, dy: -0.55, holdRange: Duration(milliseconds: 500), moveDurSeconds: 0.45),
  Waypoint(dx: 0.0, dy: -0.65, holdRange: Duration(milliseconds: 700), moveDurSeconds: 0.52),
  Waypoint(dx: 0.0, dy: 0.0, holdRange: Duration(milliseconds: 400), moveDurSeconds: 0.42),
  Waypoint(dx: 1.0, dy: -0.55, holdRange: Duration(milliseconds: 500), moveDurSeconds: 0.45),
  Waypoint(dx: 1.8, dy: 0.0, holdRange: Duration(milliseconds: 600), moveDurSeconds: 0.5),
  Waypoint(dx: 1.9, dy: 0.55, holdRange: Duration(milliseconds: 850), moveDurSeconds: 0.32),
  Waypoint(dx: 0.2, dy: 0.55, holdRange: Duration(milliseconds: 500), moveDurSeconds: 0.55),
];

class BotExpressiveAnimation extends StatefulWidget {
  final Color containerColor;
  final Color iconColor;
  final double size;

  const BotExpressiveAnimation({
    super.key,
    required this.containerColor,
    required this.iconColor,
    this.size = 96,
  });

  @override
  State<BotExpressiveAnimation> createState() => _BotExpressiveAnimationState();
}

class _BotExpressiveAnimationState extends State<BotExpressiveAnimation> with TickerProviderStateMixin {
  late AnimationController _gazeController;
  late Animation<Offset> _gazeAnimation;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  // أنيميشن إضافي لجعل الروبوت يتنفس بنبض خفيف
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _waypointIdx = 0;
  Timer? _gazeTimer;
  Timer? _blinkTimer;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _gazeController = AnimationController(vsync: this);
    _gazeAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_gazeController);

    _blinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    _blinkAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.04).chain(CurveTween(curve: Curves.easeIn)), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.04, end: 1.0).chain(CurveTween(curve: const Cubic(0.34, 1.7, 0.64, 1))), weight: 70),
    ]).animate(_blinkController);

    // إعداد حركة النبض (Breathing Effect) بجانب حركة الأعين
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleGaze();
      _scheduleBlink();
    });
  }

  @override
  void dispose() {
    _gazeController.dispose();
    _blinkController.dispose();
    _pulseController.dispose();
    _gazeTimer?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }

  void _scheduleGaze() {
    if (!mounted) return;
    final wp = WAYPOINTS[_waypointIdx];
    _gazeController.duration = Duration(milliseconds: (wp.moveDurSeconds * 1000).toInt());
    Curve curve = wp.moveDurSeconds <= 0.38 ? const Cubic(0.34, 1.56, 0.64, 1) : const Cubic(0.25, 0.46, 0.45, 0.94);

    _gazeAnimation = Tween<Offset>(begin: _gazeAnimation.value, end: Offset(wp.dx, wp.dy)).animate(
      CurvedAnimation(parent: _gazeController, curve: curve),
    );
    _gazeController.forward(from: 0.0);

    _gazeTimer = Timer(Duration(milliseconds: wp.holdRange.inMilliseconds + (_random.nextDouble() * 100 - 50).toInt()), () {
      if (mounted) {
        _waypointIdx = (_waypointIdx + 1) % WAYPOINTS.length;
        _scheduleGaze();
      }
    });
  }

  void _scheduleBlink() {
    if (!mounted) return;
    _blinkTimer = Timer(Duration(milliseconds: (2400 + _random.nextDouble() * 2800).toInt()), () async {
      if (mounted) {
        await _blinkController.forward(from: 0.0);
        if (_random.nextDouble() < 0.28) {
          _blinkTimer = Timer(Duration(milliseconds: (380 + _random.nextDouble() * 140).toInt()), () {
            if (mounted) _blinkController.forward(from: 0.0);
          });
        }
        _scheduleBlink();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: widget.containerColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: Listenable.merge([_gazeAnimation, _blinkAnimation]),
            builder: (context, child) {
              return CustomPaint(
                painter: _RobotCustomPainter(
                  iconColor: widget.iconColor,
                  gazeOffset: _gazeAnimation.value,
                  scaleY: _blinkAnimation.value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RobotCustomPainter extends CustomPainter {
  final Color iconColor;
  final Offset gazeOffset;
  final double scaleY;

  _RobotCustomPainter({required this.iconColor, required this.gazeOffset, required this.scaleY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = iconColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.scale(size.width / 24.0, size.height / 24.0);

    // 1. الهوائي
    canvas.drawPath(Path()..moveTo(12, 8)..lineTo(12, 4)..lineTo(8, 4), paint);
    // 2. الرأس
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(4, 8, 16, 12), const Radius.circular(2)), paint);
    // 3. الأذنين
    canvas.drawLine(const Offset(2, 14), const Offset(4, 14), paint);
    canvas.drawLine(const Offset(20, 14), const Offset(22, 14), paint);

    // 4. رسم العيون التعبيرية
    final fillPaint = Paint()..color = iconColor..style = PaintingStyle.fill;
    _drawEye(canvas, 9.0 + gazeOffset.dx, 14.0 + gazeOffset.dy, fillPaint);
    _drawEye(canvas, 15.0 + gazeOffset.dx, 14.0 + gazeOffset.dy, fillPaint);
  }

  void _drawEye(Canvas canvas, double cx, double cy, Paint fillPaint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: EYE_RX * 2, height: (EYE_RY * 2) * scaleY),
        const Radius.circular(EYE_RX),
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RobotCustomPainter oldDelegate) {
    return oldDelegate.iconColor != iconColor || oldDelegate.gazeOffset != gazeOffset || oldDelegate.scaleY != scaleY;
  }
}