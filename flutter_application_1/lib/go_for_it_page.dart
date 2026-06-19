import 'package:flutter/material.dart';

class GoForItPage extends StatelessWidget {
  const GoForItPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color activeGreen = Color(0xFF38D430);
    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Navigation Back Arrow Row
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                child: Row(
                  children: [
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
                  ],
                ),
              ),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  'Go For It',
                  style: TextStyle(
                    color: darkSlateText,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
              ),

              // Subtext Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Awards you\'re close to earning or ones you can complete now.',
                  style: TextStyle(
                    color: slateGraySubdued,
                    fontSize: 16,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Main curved white container grouping the three locked progress items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(6),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item 1: 100 Move Goals
                      Expanded(
                        child: _buildProgressGridItem(
                          painter: Unique100MoveGoalsWireframePainter(isDark: isDark),
                          title: '100 Move Goals',
                          progressText: '0 of 100',
                          activeGreen: activeGreen,
                          slateGraySubdued: slateGraySubdued,
                          darkSlateText: darkSlateText,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Item 2: Longest Move Streak
                      Expanded(
                        child: _buildProgressGridItem(
                          painter: UniqueStreakWireframePainter(isDark: isDark),
                          title: 'Longest Move Streak',
                          progressText: '0 of 8 days',
                          activeGreen: activeGreen,
                          slateGraySubdued: slateGraySubdued,
                          darkSlateText: darkSlateText,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Item 3: 7-Workout Week
                      Expanded(
                        child: _buildProgressGridItem(
                          painter: UniqueWorkoutsWireframePainter(isDark: isDark),
                          title: '7-Workout Week',
                          progressText: '0 of 7 workouts',
                          activeGreen: activeGreen,
                          slateGraySubdued: slateGraySubdued,
                          darkSlateText: darkSlateText,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressGridItem({
    required CustomPainter painter,
    required String title,
    required String progressText,
    required Color activeGreen,
    required Color slateGraySubdued,
    required Color darkSlateText,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Wireframe Badge Graphic
        Center(
          child: SizedBox(
            width: 76,
            height: 76,
            child: CustomPaint(
              painter: painter,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: darkSlateText,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),

        // Sub-text
        Text(
          progressText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: slateGraySubdued,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),

        // Custom Lime Green Horizontal Progress Bar matching screenshot
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), // track
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: 5, // A tiny starting block/dot representing 0% starting tick
              height: 4,
              decoration: BoxDecoration(
                color: activeGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for 100 Move Goals Outline Wireframe
class Unique100MoveGoalsWireframePainter extends CustomPainter {
  final bool isDark;
  Unique100MoveGoalsWireframePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final double r = w * 0.45;

    final Paint outlinePaint = Paint()
      ..color = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC) // outline grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Center circle
    canvas.drawCircle(center, r * 0.8, outlinePaint);
    // Two overlapping offset circles
    canvas.drawCircle(Offset(w * 0.4, h * 0.5), r * 0.55, outlinePaint);
    canvas.drawCircle(Offset(w * 0.6, h * 0.5), r * 0.55, outlinePaint);

    // Text "100" outline style
    final textPainter = TextPainter(
      text: TextSpan(
        text: '100',
        style: TextStyle(
          color: isDark ? const Color(0xFFC7C7CC) : const Color(0xFF8E8E93),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Longest Move Streak Outline Wireframe (Infinity style loop)
class UniqueStreakWireframePainter extends CustomPainter {
  final bool isDark;
  UniqueStreakWireframePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = w * 0.28;

    final Paint outlinePaint = Paint()
      ..color = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Two horizontally overlapping circles representing infinity loop streak
    canvas.drawCircle(Offset(w * 0.38, h * 0.5), r, outlinePaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.5), r, outlinePaint);

    // Add an inner curved crossing stroke representing standard streak rings folds
    final Path path = Path();
    path.moveTo(w * 0.3, h * 0.45);
    path.quadraticBezierTo(w * 0.5, h * 0.62, w * 0.7, h * 0.45);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for 7-Workout Week Outline Wireframe (Hexagonal Wireframe outline)
class UniqueWorkoutsWireframePainter extends CustomPainter {
  final bool isDark;
  UniqueWorkoutsWireframePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Hexagon Path
    final Path hexPath = Path();
    hexPath.moveTo(w * 0.5, h * 0.1);
    hexPath.lineTo(w * 0.85, h * 0.3);
    hexPath.lineTo(w * 0.85, h * 0.7);
    hexPath.lineTo(w * 0.5, h * 0.9);
    hexPath.lineTo(w * 0.15, h * 0.7);
    hexPath.lineTo(w * 0.15, h * 0.3);
    hexPath.close();

    // Draw the outer wireframe border outline
    final Paint outlinePaint = Paint()
      ..color = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC) // Subdued iOS Light Mode outline grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(hexPath, outlinePaint);

    // Inner wireframe folds (lightning/folded shape matching the screenshot)
    final Path foldPath = Path();
    foldPath.moveTo(w * 0.5, h * 0.1);
    foldPath.lineTo(w * 0.35, h * 0.55);
    foldPath.lineTo(w * 0.65, h * 0.45);
    foldPath.lineTo(w * 0.5, h * 0.9);
    
    // Diagonal crossings
    foldPath.moveTo(w * 0.15, h * 0.3);
    foldPath.lineTo(w * 0.85, h * 0.7);
    foldPath.moveTo(w * 0.85, h * 0.3);
    foldPath.lineTo(w * 0.15, h * 0.7);

    canvas.drawPath(foldPath, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
