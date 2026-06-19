import 'package:flutter/material.dart';

class WorkoutDetailsPage extends StatefulWidget {
  const WorkoutDetailsPage({super.key});

  @override
  State<WorkoutDetailsPage> createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 1800ms smooth animation for 3D spin on mount
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    // Cubic ease-out from -3 rad to 0 rad (facing front)
    _animation = Tween<double>(begin: -3.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Interactive tap spin
  void _triggerTapSpin() {
    if (!_controller.isAnimating) {
      _controller.forward(from: -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top navigation bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: darkSlateText, size: 16),
                    ),
                  ),
                  // Share button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening sharing options...'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF38D430),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                      ),
                      child: Icon(Icons.ios_share_rounded,
                          color: darkSlateText, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
            // Center badge with 3D rotation
            Center(
              child: GestureDetector(
                onTap: _triggerTapSpin,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0015)
                        ..rotateY(_animation.value * 3.14159265),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        width: 250,
                        height: 250,
                        child: CustomPaint(
                          painter: UniqueWorkoutsWireframePainter(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Spacer(flex: 1),
            // Description section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text(
                    'Workouts',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkSlateText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                   Text(
                    "Complete personal record workouts or achieve set milestones. Track your progress and stay motivated.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: slateGraySubdued,
                      fontSize: 15,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// Re‑using the wireframe badge painter defined in awards_page.dart for consistency
class UniqueWorkoutsWireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Path badgePath = Path();
    // Hexagonal wireframe outline similar to the card preview
    badgePath.moveTo(w * 0.5, h * 0.05);
    badgePath.lineTo(w * 0.9, h * 0.28);
    badgePath.lineTo(w * 0.9, h * 0.72);
    badgePath.lineTo(w * 0.5, h * 0.95);
    badgePath.lineTo(w * 0.1, h * 0.72);
    badgePath.lineTo(w * 0.1, h * 0.28);
    badgePath.close();

    // Shadow
    canvas.drawPath(
      badgePath,
      Paint()
        ..color = Colors.black.withAlpha(12)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Gradient fill (premium teal/blue)
    final Paint fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF00C7BE), Color(0xFF88FCD4)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(badgePath, fillPaint);

    // Metallic border
    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFB8C5D6), Color(0xFF8A9BA8), Color(0xFFFFFFFF)],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(badgePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
