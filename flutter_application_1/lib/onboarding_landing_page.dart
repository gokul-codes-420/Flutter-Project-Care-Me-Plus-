import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingLandingPage extends StatelessWidget {
  const OnboardingLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = const Color(0xFF4F46E5); // Indigo/Purple

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E1B4B)]
                : [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // 1. DNA Helix Custom Paint Background
            Positioned.fill(
              child: CustomPaint(
                painter: DiagonalDNAHelixPainter(),
              ),
            ),

            // 2. Main Layout Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top: Skip button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withAlpha(50),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Centered CareMe Logo
                    Align(
                      alignment: Alignment.topCenter,
                      child: _buildCareMeLogo(),
                    ),

                    const Spacer(),

                    // Bottom: "Smart Health, Smarter You" layout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Smart Health,\nSmarter You',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Personalized wellness plans powered by advanced AI analysis.',
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 16,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // "Get started! ->" Button
                        SizedBox(
                          height: 58,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Get started!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareMeLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Color(0xFF4F46E5), // Match primary indigo color
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'CareMe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// Custom Painter to draw a diagonal glowing DNA helix
class DiagonalDNAHelixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Gradient strand brush
    final Paint strandPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withAlpha(140), Colors.white.withAlpha(15)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final Paint nodePaint = Paint()
      ..color = Colors.white.withAlpha(190)
      ..style = PaintingStyle.fill;

    // Draw a diagonal double helix along the main angle of the screen
    final int steps = 28;
    final double dx = w / steps;
    final double dy = h / steps;

    for (int i = 0; i <= steps; i++) {
      // Current point along the diagonal line
      final double xBase = i * dx;
      final double yBase = i * dy;

      // Perpendicular unit vector to the diagonal
      final double len = math.sqrt(dx * dx + dy * dy);
      final double px = -dy / len;
      final double py = dx / len;

      // Sinusoidal offset perpendicular to the line
      final double offset = 32.0 * math.sin(i * 0.45);

      final double x1 = xBase + px * offset;
      final double y1 = yBase + py * offset;

      final double x2 = xBase - px * offset;
      final double y2 = yBase - py * offset;

      // Draw horizontal connector rungs (bars) between nodes
      if (i % 2 == 0) {
        canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..color = Colors.white.withAlpha(35)
            ..strokeWidth = 1.2,
        );
        canvas.drawCircle(Offset(x1, y1), 3.5, nodePaint);
        canvas.drawCircle(Offset(x2, y2), 3.5, nodePaint);
      }
    }

    // Draw the continuous outer strands
    final Path path1 = Path();
    final Path path2 = Path();
    
    for (int i = 0; i <= steps; i++) {
      final double xBase = i * dx;
      final double yBase = i * dy;
      final double len = math.sqrt(dx * dx + dy * dy);
      final double px = -dy / len;
      final double py = dx / len;
      final double offset = 32.0 * math.sin(i * 0.45);

      final double x1 = xBase + px * offset;
      final double y1 = yBase + py * offset;
      final double x2 = xBase - px * offset;
      final double y2 = yBase - py * offset;

      if (i == 0) {
        path1.moveTo(x1, y1);
        path2.moveTo(x2, y2);
      } else {
        path1.lineTo(x1, y1);
        path2.lineTo(x2, y2);
      }
    }

    canvas.drawPath(path1, strandPaint);
    canvas.drawPath(path2, strandPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
