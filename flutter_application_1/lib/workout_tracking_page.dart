import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutTrackingPage extends StatefulWidget {
  final String workoutName;
  final IconData workoutIcon;
  final Color accentColor;

  const WorkoutTrackingPage({
    super.key,
    required this.workoutName,
    required this.workoutIcon,
    required this.accentColor,
  });

  @override
  State<WorkoutTrackingPage> createState() => _WorkoutTrackingPageState();
}

class _WorkoutTrackingPageState extends State<WorkoutTrackingPage>
    with TickerProviderStateMixin {
  late Stopwatch _stopwatch;
  late Timer _uiTimer;
  bool _isPaused = false;
  int _lapCount = 0;

  // Ring animation controller
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _stopwatch = Stopwatch()..start();

    _uiTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _stopwatch.stop();
    _uiTimer.cancel();
    _ringController.dispose();
    super.dispose();
  }

  String _formatTime() {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final centiseconds =
        (elapsed.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$centiseconds';
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
    });
  }

  void _endWorkout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'End Workout?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your workout will be saved.',
          style: TextStyle(color: Color(0xFF8E8E93)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: widget.accentColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            child: const Text('End',
                style: TextStyle(
                    color: Color(0xFFFF3B30), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    final elapsedMs = elapsed.inMilliseconds;
    final ringProgress = (elapsed.inSeconds % 60) / 60.0;

    // Calculate dynamic mock stats
    final double distanceFt = elapsedMs * (4.667 / 1000.0);
    final int activeCal = (elapsedMs * (0.2 / 1000.0)).floor();
    final int totalCal = (elapsedMs * (0.25 / 1000.0)).floor();

    String paceStr = "--'--\"";
    if (distanceFt > 10.0) {
      final double miles = distanceFt / 5280.0;
      final double minutes = elapsedMs / 60000.0;
      final double pace = minutes / miles;
      final int pMin = pace.floor();
      final int pSec = ((pace - pMin) * 60).floor();
      paceStr = "$pMin'${pSec.toString().padLeft(2, '0')}\"";
    }

    // Dimmed grey color for metrics when paused
    final metricColor = _isPaused
        ? const Color(0xFF636366)
        : Colors.white;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Main Metrics ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Distance: 0 FT
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: metricColor,
                            fontSize: 100,
                            fontWeight: FontWeight.w200,
                            height: 1.0,
                            letterSpacing: -4,
                          ),
                          child: Text(distanceFt.toStringAsFixed(0)),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              color: metricColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                            child: const Text('FT'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Average Pace
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: metricColor,
                            fontSize: 38,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                          child: Text(paceStr),
                        ),
                        const SizedBox(width: 14),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
                            'AVERAGE\nPACE',
                            style: TextStyle(
                              color: Color(0xFF636366),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 44),

                    // Active Cal | Total Cal
                    Row(
                      children: [
                        _buildStat('$activeCal', 'ACTIVE CAL', metricColor),
                        const SizedBox(width: 64),
                        _buildStat('$totalCal', 'TOTAL CAL', metricColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Control Panel ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF48484A),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Row 1: icon | timer | mini ring
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Workout icon (dimmed when paused)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            widget.workoutIcon,
                            color: _isPaused
                                ? const Color(0xFF636366)
                                : widget.accentColor,
                            size: 26,
                          ),
                        ),
                      ),

                      // Timer (frozen yellow when paused)
                      Text(
                        _formatTime(),
                        style: TextStyle(
                          color: _isPaused
                              ? const Color(0xFF8E8E93)
                              : const Color(0xFFFFFF00),
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),

                      // Mini ring (dimmed when paused)
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CustomPaint(
                          painter: _MiniRingPainter(
                            progress: ringProgress,
                            isDimmed: _isPaused,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Row 2: lap | center button | heart-off
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Lap button
                      _buildControlButton(
                        onTap: _isPaused ? null : () => setState(() => _lapCount++),
                        child: Text(
                          '${_lapCount + 1}',
                          style: TextStyle(
                            color: _isPaused
                                ? const Color(0xFF636366)
                                : Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        size: 64,
                        bgColor: const Color(0xFF2C2C2E),
                      ),

                      // Center button: Pause ↔ Resume (yellow circular arrow when paused)
                      GestureDetector(
                        onTap: _togglePause,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: _isPaused
                                ? const Color(0xFF3D3A00) // olive/dark yellow bg
                                : const Color(0xFF2C2C2E),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isPaused
                                  ? const Color(0xFF6B6400)
                                  : const Color(0xFF3A3A3C),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _isPaused
                                  ? Icons.refresh_rounded   // circular arrow = resume
                                  : Icons.pause_rounded,
                              color: _isPaused
                                  ? const Color(0xFFFFFF00) // yellow when paused
                                  : Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),

                      // Heart rate disabled button
                      _buildControlButton(
                        onTap: () {},
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFF636366),
                              size: 26,
                            ),
                            Transform.rotate(
                              angle: 0.45,
                              child: Container(
                                width: 2,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF636366),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        size: 64,
                        bgColor: const Color(0xFF2C2C2E),
                      ),
                    ],
                  ),

                  // ── Paused action buttons (animated in/out) ──
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _isPaused
                        ? Column(
                            children: [
                              const SizedBox(height: 16),

                              // End Workout — red pill
                              GestureDetector(
                                onTap: _endWorkout,
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3A0010),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.close_rounded,
                                          color: Color(0xFFFF3B30),
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'End Workout',
                                          style: TextStyle(
                                            color: Color(0xFFFF3B30),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Check In — dark grey pill
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Check In sent!'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C2E),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Check In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Lock Controls — dark grey pill
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Controls locked'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C2E),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.lock_outline_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Lock Controls',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: color,
            fontSize: 52,
            fontWeight: FontWeight.w200,
            height: 1.0,
            letterSpacing: -1,
          ),
          child: Text(value),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF636366),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required VoidCallback? onTap,
    required Widget child,
    required double size,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3A3A3C), width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ── Mini pink activity ring painter ──
class _MiniRingPainter extends CustomPainter {
  final double progress;
  final bool isDimmed;
  _MiniRingPainter({required this.progress, this.isDimmed = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 5.5;
    const startAngle = -pi / 2;

    final bgPaint = Paint()
      ..color = isDimmed ? const Color(0xFF3A3A3C) : const Color(0xFF5C0020)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final arcPaint = Paint()
      ..color = isDimmed ? const Color(0xFF636366) : const Color(0xFFFF2D55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi * progress.clamp(0.0, 1.0),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_MiniRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDimmed != isDimmed;
}
