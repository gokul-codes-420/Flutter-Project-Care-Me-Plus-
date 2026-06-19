import 'package:flutter/material.dart';

class MonthlyChallengeDetailsPage extends StatefulWidget {
  const MonthlyChallengeDetailsPage({super.key});

  @override
  State<MonthlyChallengeDetailsPage> createState() => _MonthlyChallengeDetailsPageState();
}

class _MonthlyChallengeDetailsPageState extends State<MonthlyChallengeDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 1800ms smooth 3D spin on mount
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _animation = Tween<double>(begin: -3.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Kicks off spin animation on screen mount
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Tapping the hexagon triggers a delightful interactive 360 spin
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

            // Center Medal Graphic with 3D Y-axis perspective rotation
            Center(
              child: GestureDetector(
                onTap: _triggerTapSpin,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0015) // Deep perspective matrix entry
                        ..rotateY(_animation.value * 3.14159265), // rotate angle
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                          painter: UniqueMonthlyChallengePainter(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const Spacer(flex: 1),

            // Description details section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Medal Title
                  Text(
                    'April Challenge',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkSlateText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description subtext matching screenshot exactly
                  Text(
                    "You earned this award by doubling your Move goal 3 times in a single month. 24/04/25.",
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

// Re-using the premium Monthly Challenge Painter inside detail screen
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
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(hexPath, borderPaint);

    // 4. Draw large silver stylized number "4" inside
    final numberPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 6.0
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
          fontSize: 10,
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
