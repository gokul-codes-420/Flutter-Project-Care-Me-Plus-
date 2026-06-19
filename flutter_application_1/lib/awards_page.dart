import 'package:flutter/material.dart';

class AwardsPage extends StatelessWidget {
  const AwardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color activeGreen = Color(0xFF38D430); // Apple active green
    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);
    final Color cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar Navigation & Back Arrow
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

              // Title Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  'Awards',
                  style: TextStyle(
                    color: darkSlateText,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
              ),

              // Card 1: Go For It
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/go_for_it');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left Section: Unique Golden Circular 100 Medal Graphic
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: CustomPaint(
                            painter: Unique100MoveGoalsPainter(),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Middle Section: Award details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Go For It',
                                style: TextStyle(
                                  color: darkSlateText,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '100 Move Goals',
                                style: TextStyle(
                                  color: slateGraySubdued,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '0 of 100',
                                style: TextStyle(
                                  color: slateGraySubdued.withAlpha(180),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Section: Show All trigger text
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/go_for_it');
                          },
                          child: const Text(
                            'Show All',
                            style: TextStyle(
                              color: activeGreen,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Card 2: Close Your Rings
              // Card 2: Close Your Rings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/award_details');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top Left Heading
                        Text(
                          'Close Your Rings',
                          style: TextStyle(
                            color: darkSlateText,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Central Large Shiny Move Goal Medal (Reused high fidelity)
                        Center(
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: CustomPaint(
                              painter: UniqueAwardsMedalPainter(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description beneath the badge
                        Center(
                          child: Text(
                            'Move Goal 200%',
                            style: TextStyle(
                              color: darkSlateText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            '13/05/25',
                            style: TextStyle(
                              color: slateGraySubdued,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Small Dark circular indicator pill representing "30"
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: darkSlateText,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '30',
                              style: TextStyle(
                                color: Color(0xFF1C1C1E),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Bottom preview & show all row
                        Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Stacked preview of other circular progress medals
                            SizedBox(
                              width: 120,
                              height: 36,
                              child: CustomPaint(
                                painter: UniqueMiniMedalsPainter(isDark: isDark),
                              ),
                            ),

                            // +4 more and Show All link
                            Row(
                              children: [
                                 Text(
                                   '+4 more   ',
                                   style: TextStyle(
                                     color: slateGraySubdued,
                                     fontSize: 13,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/award_details');
                                  },
                                  child: Text(
                                    'Show All',
                                    style: TextStyle(
                                      color: activeGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Side-by-side Row: Monthly Challenges & Workouts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Monthly Challenges
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/monthly_challenge_details');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(8),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Monthly\nChallenges',
                                maxLines: 2,
                                style: TextStyle(
                                  color: darkSlateText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Central Badge (Hexagonal Silver & Mint)
                              Center(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CustomPaint(
                                    painter: UniqueMonthlyChallengePainter(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              Text(
                                'April Challenge',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: darkSlateText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '24/04/25',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: slateGraySubdued,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1),
                              const SizedBox(height: 12),
                              
                              // Overlapping stacked badges & Show All row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 22,
                                    child: CustomPaint(
                                      painter: UniqueMonthlyMiniBadgesPainter(),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '+10 more',
                                        style: TextStyle(
                                          color: slateGraySubdued,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/monthly_challenge_details');
                                        },
                                        child: const Text(
                                          'Show All',
                                          style: TextStyle(
                                            color: activeGreen,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Right Column: Workouts
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/workout_details');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(8),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Workouts',
                                style: TextStyle(
                                  color: darkSlateText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 26), // Balance visual alignment
                              
                              // Central Badge (Hexagonal Wireframe outline)
                              Center(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CustomPaint(
                                    painter: UniqueWorkoutsWireframePainter(isDark: isDark),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              Text(
                                'Complete workouts or set personal records.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: slateGraySubdued,
                                  fontSize: 11,
                                  height: 1.3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Caption Guideline
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 32.0),
                child: Text(
                  'New categories of awards will appear here when they\'re available to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: slateGraySubdued,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for the Go For It (100 Goals) circular black & gold badge
class Unique100MoveGoalsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final double r = w * 0.45;

    // Draw solid shadow
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = Colors.black.withAlpha(12)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Draw main badge background (Premium Black)
    final Paint bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1C1C1E), Color(0xFF2C2C2E)],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, bgPaint);

    // Draw 3 overlapping gold thin wireframe rings
    final Paint goldRingPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFE082), Color(0xFFFFB300), Color(0xFFFFA000), Color(0xFFFFE082)],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Ring 1 (Center)
    canvas.drawCircle(center, r * 0.8, goldRingPaint);
    // Ring 2 (Left overlap)
    canvas.drawCircle(Offset(w * 0.4, h * 0.5), r * 0.55, goldRingPaint);
    // Ring 3 (Right overlap)
    canvas.drawCircle(Offset(w * 0.6, h * 0.5), r * 0.55, goldRingPaint);

    // Draw gold typography "100" in the exact center
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '100',
        style: TextStyle(
          color: Color(0xFFFFD54F),
          fontSize: 16,
          fontWeight: FontWeight.w900,
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

// Custom Painter for the Move Goal 200% shiny gold-and-silver shield medal
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
      ..strokeWidth = 5
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
      ..strokeWidth = 5
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

// Custom Painter for overlapping mini circular stacked medal previews
class UniqueMiniMedalsPainter extends CustomPainter {
  final bool isDark;
  UniqueMiniMedalsPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height * 0.45;
    
    // 1. Rightmost Badge (Teal/Blue)
    final Offset center3 = Offset(radius * 2.2, size.height * 0.5);
    _drawMiniBadge(canvas, center3, radius, const Color(0xFF00C7BE), const Color(0xFF30D158));
    
    // 2. Middle Badge (Purple/Silver)
    final Offset center2 = Offset(radius * 1.3, size.height * 0.5);
    _drawMiniBadge(canvas, center2, radius, const Color(0xFF5856D6), const Color(0xFF007AFF));
    
    // 3. Leftmost Badge (Pink/Red Move Ring)
    final Offset center1 = Offset(radius * 0.5, size.height * 0.5);
    _drawMiniBadge(canvas, center1, radius, const Color(0xFFFF2D55), const Color(0xFFFF9500));
  }

  void _drawMiniBadge(Canvas canvas, Offset center, double radius, Color baseColor, Color accentColor) {
    // Base shadow
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black.withAlpha(20)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Background circle
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark ? const [Color(0xFF1C1C1E), Colors.black] : const [Colors.white, Color(0xFFF2F2F7)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, fillPaint);

    // Color concentric rings
    canvas.drawCircle(
      center,
      radius * 0.7,
      Paint()
        ..color = baseColor.withAlpha(50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      center,
      radius * 0.45,
      Paint()
        ..color = accentColor.withAlpha(120)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Outer premium metallic border
    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8), Color(0xFFCBD5E1)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for the Monthly Challenge (April Challenge) hexagon badge
class UniqueMonthlyChallengePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Outer Hexagon Path
    final Path hexPath = Path();
    hexPath.moveTo(w * 0.5, h * 0.05);
    hexPath.lineTo(w * 0.9, h * 0.28);
    hexPath.lineTo(w * 0.9, h * 0.72);
    hexPath.lineTo(w * 0.5, h * 0.95);
    hexPath.lineTo(w * 0.1, h * 0.72);
    hexPath.lineTo(w * 0.1, h * 0.28);
    hexPath.close();

    // 1. Draw Shadow
    canvas.drawPath(
      hexPath,
      Paint()
        ..color = Colors.black.withAlpha(12)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // 2. Fill Hexagon with bright premium neon-mint gradient
    final Paint fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF88FCD4), Color(0xFF00C7BE)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(hexPath, fillPaint);

    // 3. Draw premium metallic silver borders
    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFB8C5D6), Color(0xFF8A9BA8), Color(0xFFFFFFFF)],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(hexPath, borderPaint);

    // 4. Draw large silver stylized number "4" inside
    final numberPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final numPath = Path();
    // Vertical stem of 4
    numPath.moveTo(w * 0.6, h * 0.25);
    numPath.lineTo(w * 0.6, h * 0.75);
    // Diagonal & cross-bar of 4
    numPath.moveTo(w * 0.6, h * 0.25);
    numPath.lineTo(w * 0.35, h * 0.55);
    numPath.lineTo(w * 0.75, h * 0.55);
    
    canvas.drawPath(numPath, numberPaint);

    // 5. Draw diagonal metallic silver strip near the bottom right (with "2025" effect)
    canvas.save();
    canvas.clipPath(hexPath);
    final Paint stripePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFCBD5E1), Color(0xFF64748B), Color(0xFFCBD5E1)],
      ).createShader(Rect.fromLTRB(w * 0.3, h * 0.6, w, h));

    final Path stripePath = Path();
    stripePath.moveTo(w * 0.3, h * 0.9);
    stripePath.lineTo(w * 0.9, h * 0.5);
    stripePath.lineTo(w * 0.95, h * 0.65);
    stripePath.lineTo(w * 0.45, h * 0.95);
    stripePath.close();
    canvas.drawPath(stripePath, stripePaint);

    // Tiny gold border around diagonal strip
    final Paint stripeBorderPaint = Paint()
      ..color = Colors.white.withAlpha(160)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(stripePath, stripeBorderPaint);

    // Text "2025" in mini typography rotated
    canvas.translate(w * 0.6, h * 0.73);
    canvas.rotate(-0.55); // Rotated to match angle of the strip
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '2025',
        style: TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for the incomplete/locked Workouts hexagonal wireframe badge
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
      ..color = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC) // Wireframe outline
      ..strokeWidth = 2.5
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

// Custom Painter for overlapping mini circular stacked hexagon challenge badge previews
class UniqueMonthlyMiniBadgesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height * 0.45;
    
    // 1. Rightmost Mini Hexagon (Teal/Green)
    final Offset center3 = Offset(radius * 2.2, size.height * 0.5);
    _drawMiniHex(canvas, center3, radius, const Color(0xFF00FFD1), const Color(0xFF00C7BE));
    
    // 2. Middle Mini Hexagon (Blue/Purple)
    final Offset center2 = Offset(radius * 1.3, size.height * 0.5);
    _drawMiniHex(canvas, center2, radius, const Color(0xFF3CD49B), const Color(0xFF3A5BDB));
    
    // 3. Leftmost Mini Hexagon (Mint/Green April Theme)
    final Offset center1 = Offset(radius * 0.5, size.height * 0.5);
    _drawMiniHex(canvas, center1, radius, const Color(0xFF88FCD4), const Color(0xFF00C7BE));
  }

  void _drawMiniHex(Canvas canvas, Offset center, double r, Color col1, Color col2) {
    final Path hexPath = Path();
    final double cx = center.dx;
    final double cy = center.dy;
    hexPath.moveTo(cx, cy - r);
    hexPath.lineTo(cx + r * 0.86, cy - r * 0.5);
    hexPath.lineTo(cx + r * 0.86, cy + r * 0.5);
    hexPath.lineTo(cx, cy + r);
    hexPath.lineTo(cx - r * 0.86, cy + r * 0.5);
    hexPath.lineTo(cx - r * 0.86, cy - r * 0.5);
    hexPath.close();

    // Shadow
    canvas.drawPath(
      hexPath,
      Paint()
        ..color = Colors.black.withAlpha(15)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );

    // Gradient Fill
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [col1, col2],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawPath(hexPath, fillPaint);

    // Border
    final Paint borderPaint = Paint()
      ..color = Colors.white.withAlpha(200)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(hexPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

