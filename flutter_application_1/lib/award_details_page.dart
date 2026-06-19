import 'package:flutter/material.dart';

class AwardDetailsPage extends StatefulWidget {
  const AwardDetailsPage({super.key});

  @override
  State<AwardDetailsPage> createState() => _AwardDetailsPageState();
}

class _AwardDetailsPageState extends State<AwardDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 1500ms smooth animation duration for 3D spin on mount
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Smooth cubic ease-out curve to settle slowly facing front
    _animation = Tween<double>(begin: -3.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Play spin animation immediately when screen mounts
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Tactile click triggers a delightful interactive 360-degree spin
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
            // Top Navigation Bar (Back Arrow left, iOS Share Sheet icon right)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular back button
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
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: darkSlateText,
                        size: 16,
                      ),
                    ),
                  ),

                  // Circular iOS Share Sheet button
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
                      child: Icon(
                        Icons.ios_share_rounded,
                        color: darkSlateText,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Center Medal Graphic with gorgeous 3D perspective Y-axis rotation
            Center(
              child: GestureDetector(
                onTap: _triggerTapSpin,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0015) // Deep, realistic perspective depth
                        ..rotateY(_animation.value * 3.14159265), // Y-axis spin angle
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
                          painter: UniqueAwardsMedalPainter(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Description Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Medal Title
                  Text(
                    'Move Goal 200%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkSlateText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Achievement text
                  Text(
                    "You've earned this award 30 times for doubling your daily Move goal. Most recent: 13/05/25. You need another 228 kilocalories to earn this award today.",
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

// Re-using the Move Goal 200% vector badge painter inside detail page for consistency
class UniqueAwardsMedalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path badgePath = Path();
    badgePath.moveTo(size.width * 0.15, size.height * 0.1);
    badgePath.quadraticBezierTo(size.width * 0.5, size.height * 0.05, size.width * 0.85, size.height * 0.1);
    badgePath.lineTo(size.width * 0.85, size.height * 0.75);
    badgePath.lineTo(size.width * 0.5, size.height * 0.6);
    badgePath.lineTo(size.width * 0.15, size.height * 0.75);
    badgePath.close();

    final Paint fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFDF5), Color(0xFFF9F5E3), Color(0xFFEFE8C9)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(badgePath, fillPaint);

    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1), Color(0xFF94A3B8), Color(0xFFCBD5E1)],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(badgePath, borderPaint);

    final circlePaint1 = Paint()
      ..color = const Color(0xFFFF6B57)
      ..style = PaintingStyle.fill;
    final circlePaint2 = Paint()
      ..color = const Color(0xFFFF523B)
      ..style = PaintingStyle.fill;
    final ringStrokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final double centerWidth = size.width * 0.5;
    final double centerHeight = size.height * 0.35;
    final double radius = size.width * 0.22;

    canvas.save();
    canvas.clipPath(badgePath);
    canvas.drawCircle(Offset(centerWidth - 15, centerHeight + 10), radius, circlePaint1);
    canvas.drawCircle(Offset(centerWidth + 15, centerHeight - 10), radius - 4, circlePaint2);
    canvas.drawCircle(Offset(centerWidth - 15, centerHeight + 10), radius, ringStrokePaint);
    canvas.drawCircle(Offset(centerWidth + 15, centerHeight - 10), radius - 4, ringStrokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
