import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'workout_tracking_page.dart';

class WorkoutCountdownPage extends StatefulWidget {
  final String workoutName;
  final IconData workoutIcon;
  final Color accentColor;

  const WorkoutCountdownPage({
    super.key,
    required this.workoutName,
    required this.workoutIcon,
    required this.accentColor,
  });

  @override
  State<WorkoutCountdownPage> createState() => _WorkoutCountdownPageState();
}

class _WorkoutCountdownPageState extends State<WorkoutCountdownPage>
    with TickerProviderStateMixin {
  late AnimationController _sweepController;
  late AnimationController _scaleController;
  late Animation<double> _sweepAnimation;
  late Animation<double> _scaleAnimation;

  int _currentCount = 3;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();

    // Full immersive dark mode for this screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Ring sweep animation — 0→1 in 900ms per count
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _sweepAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sweepController, curve: Curves.easeInOut),
    );

    // Number scale pulse animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    _sweepController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentCount > 1) {
          // Pulse the number then decrement
          _scaleController.forward().then((_) {
            _scaleController.reverse();
            if (mounted) {
              setState(() {
                _currentCount--;
              });
              _sweepController.reset();
              _sweepController.forward();
            }
          });
        } else {
          // All done — flash green check then auto-navigate to tracking
          setState(() {
            _isDone = true;
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (ctx, anim, secAnim) => WorkoutTrackingPage(
                    workoutName: widget.workoutName,
                    workoutIcon: widget.workoutIcon,
                    accentColor: widget.accentColor,
                  ),
                  transitionsBuilder: (ctx, anim, secAnim, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            }
          });
        }
      }
    });

    // Small delay before starting
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _sweepController.forward();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _sweepController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ringDiameter = screenSize.width * 0.72;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Walking icon circle at top ──
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2B1A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.accentColor.withAlpha(60),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  widget.workoutIcon,
                  color: widget.accentColor,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Animated sweep ring + countdown number ──
            AnimatedBuilder(
              animation: Listenable.merge([_sweepAnimation, _scaleAnimation]),
              builder: (context, child) {
                return SizedBox(
                  width: ringDiameter,
                  height: ringDiameter,
                  child: CustomPaint(
                    painter: _CountdownRingPainter(
                      progress: _sweepAnimation.value,
                      accentColor: widget.accentColor,
                      isDone: _isDone,
                    ),
                    child: Center(
                      child: _isDone
                          ? TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 300),
                              builder: (_, val, __) => Transform.scale(
                                scale: val,
                                child: Icon(
                                  Icons.check_rounded,
                                  color: widget.accentColor,
                                  size: ringDiameter * 0.42,
                                ),
                              ),
                            )
                          : Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Text(
                                '$_currentCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ringDiameter * 0.44,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                  letterSpacing: -3,
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // ── Workout name label ──
            AnimatedOpacity(
              opacity: _isDone ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                widget.workoutName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom Painter for the sweep ring ──
class _CountdownRingPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final bool isDone;

  _CountdownRingPainter({
    required this.progress,
    required this.accentColor,
    required this.isDone,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    const strokeWidth = 16.0;
    const startAngle = -pi / 2; // Start from top (12 o'clock)

    // Background dim ring
    final bgPaint = Paint()
      ..color = accentColor.withAlpha(38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (isDone) {
      // Full bright ring when countdown is complete
      final donePaint = Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, donePaint);
      return;
    }

    // Active sweep arc — bright lime green
    final sweepPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Glow layer (slightly wider, transparent)
    final glowPaint = Paint()
      ..color = accentColor.withAlpha(70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final sweepAngle = 2 * pi * progress;

    if (sweepAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        sweepPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CountdownRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDone != isDone ||
        oldDelegate.accentColor != accentColor;
  }
}
