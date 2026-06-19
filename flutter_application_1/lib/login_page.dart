import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailPasswordSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
        ),
      ),
    );

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) Navigator.pop(context); // Close loading indicator
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/success',
          arguments: credential.user?.email ?? _emailController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context); // Close loading indicator
      
      String message = e.message ?? 'Authentication failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email. Register first, or continue in Demo Mode.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      
      _showAuthErrorDialog(
        title: 'Authentication Error',
        message: message,
        fallbackEmail: _emailController.text,
      );
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading indicator
      _showAuthErrorDialog(
        title: 'Error',
        message: e.toString(),
        fallbackEmail: _emailController.text,
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
        ),
      ),
    );

    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) Navigator.pop(context); // Close loading indicator

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/success',
          arguments: userCredential.user?.email ?? googleUser.email,
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading indicator
      
      // If user cancelled, don't show the error dialog
      if (e is GoogleSignInException && e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      
      _showAuthErrorDialog(
        title: 'Google Sign In Error',
        message: 'Google Sign-In failed or is not configured yet on Firebase Console.\nDetails: ${e.toString()}',
        fallbackEmail: 'gamingtamizha509@gmail.com',
      );
    }
  }

  void _showAuthErrorDialog({
    required String title,
    required String message,
    required String fallbackEmail,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF120822),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          '$message\n\nWould you like to bypass this error and proceed in Demo Mode?',
          style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try Again', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Dismiss dialog
              Navigator.pushNamed(
                context,
                '/google-mock',
                arguments: fallbackEmail,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Bypass (Demo Mode)', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme colors matching the premium design mockup
    final Color primaryColor = const Color(0xFF4F46E5); // Indigo/Purple
    final Color sheetBg = isDark ? const Color(0xFF120822) : Colors.white;
    final Color inputBg = isDark ? const Color(0xFF1F1A3A) : const Color(0xFFF8FAFC);
    final Color inputBorder = isDark ? const Color(0xFF3B1E6D) : const Color(0xFFE2E8F0);
    final Color labelColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color welcomeTextColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Top Section: Gradient and DNA Helix Custom Paint Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Container(
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
                  // DNA Helix custom paint
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DNAHelixPainter(),
                    ),
                  ),
                  // CareMe Logo centered in the gradient section
                  SafeArea(
                    child: Align(
                      alignment: const Alignment(0, -0.3),
                      child: _buildCareMeLogo(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Bottom Onboarding / On-top Login Sheet with Rounded Corners
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.28,
            child: Container(
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // "Welcome Back" Header text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome ',
                            style: TextStyle(
                              color: welcomeTextColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Email Address Input Block
                      Text(
                        'Email Address',
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'yourname@example.com',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14.5),
                          filled: true,
                          fillColor: inputBg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorder, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Input Block
                      Text(
                        'Password',
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14.5),
                          filled: true,
                          fillColor: inputBg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: inputBorder, width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 1.5),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF94A3B8),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Remember Me Checkbox and Forgot Password Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: primaryColor,
                                    checkColor: Colors.white,
                                    onChanged: (val) {
                                      setState(() {
                                        _rememberMe = val ?? false;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Forgot Password request sent!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign In Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleEmailPasswordSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Divider "or Sign in with"
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or Sign in with',
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social Login Icons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIconBox(
                            iconWidget: const Icon(
                              Icons.facebook,
                              color: Color(0xFF1877F2),
                              size: 24,
                            ),
                            onTap: () => _simulateSocialLogin('Facebook'),
                          ),
                          const SizedBox(width: 16),
                          _buildSocialIconBox(
                            iconWidget: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                              height: 22,
                              width: 22,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.g_mobiledata_rounded, color: Colors.blue, size: 24),
                            ),
                            onTap: _handleGoogleSignIn,
                          ),
                          const SizedBox(width: 16),
                          _buildSocialIconBox(
                            iconWidget: Icon(
                              Icons.apple_rounded,
                              color: isDark ? Colors.white : Colors.black,
                              size: 26,
                            ),
                            onTap: _handleAppleSignIn,
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),

                      // Sign Up Text link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareMeLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Color(0xFF4F46E5), // Match primary indigo color
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'CareMe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIconBox({
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 54,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1A3A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF3B1E6D) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: iconWidget),
      ),
    );
  }

  void _simulateSocialLogin(String provider) {
    Navigator.pushNamed(
      context,
      '/google-mock',
      arguments: provider == 'Apple' ? 'apple.user@icloud.com' : 'social.user@gmail.com',
    );
  }

  Future<bool> _isIosSimulator() async {
    if (kIsWeb) return false;
    if (!Platform.isIOS) return false;
    try {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleAppleSignIn() async {
    final bool isSim = await _isIosSimulator();
    if (isSim) {
      _showAppleSignInBottomSheet();
    } else {
      _simulateSocialLogin('Apple');
    }
  }

  void _showAppleSignInBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AppleSignInSheet(
          onSignInSuccess: (String email) {
            Navigator.pop(context); // Close bottom sheet
            Navigator.pushReplacementNamed(
              context,
              '/fitness-welcome',
            );
          },
        );
      },
    );
  }
}

// Custom Painter to draw a diagonal glowing DNA helix
class DNAHelixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Gradient strand brush
    final Paint strandPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withAlpha(120), Colors.white.withAlpha(20)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final Paint nodePaint = Paint()
      ..color = Colors.white.withAlpha(180)
      ..style = PaintingStyle.fill;

    // Draw a diagonal double helix along the main angle of the screen
    final int steps = 25;
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
      final double offset = 26.0 * math.sin(i * 0.45);

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
            ..color = Colors.white.withAlpha(30)
            ..strokeWidth = 1.0,
        );
        canvas.drawCircle(Offset(x1, y1), 3.0, nodePaint);
        canvas.drawCircle(Offset(x2, y2), 3.0, nodePaint);
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
      final double offset = 26.0 * math.sin(i * 0.45);

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

// Stateful Widget representing the simulated Apple Sign-In sheet
class _AppleSignInSheet extends StatefulWidget {
  final Function(String email) onSignInSuccess;

  const _AppleSignInSheet({
    required this.onSignInSuccess,
  });

  @override
  State<_AppleSignInSheet> createState() => _AppleSignInSheetState();
}

class _AppleSignInSheetState extends State<_AppleSignInSheet> {
  bool _shareEmail = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Native Apple iOS sheet styling
    final Color backgroundColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final Color cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color secondaryTextColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93);
    final Color dividerColor = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFD1D1D6);
    final Color buttonColor = isDark ? Colors.white : Colors.black;
    final Color buttonTextColor = isDark ? Colors.black : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Grab handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF48484A) : const Color(0xFFC7C7CC),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header: Apple Logo and "Sign in with Apple ID"
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.apple_rounded,
                    color: isDark ? Colors.black : Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in with Apple ID',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'to CareMe',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content section in card style
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Apple ID Account
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'APPLE ID',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gokul Santh',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'gokulsanth@icloud.com',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 0.5, color: dividerColor),

                // Share my email option
                InkWell(
                  onTap: () {
                    setState(() {
                      _shareEmail = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Share My Email',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'gokulsanth@icloud.com',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_shareEmail)
                          Icon(
                            Icons.check_circle_rounded,
                            color: isDark ? Colors.white : Colors.black,
                            size: 24,
                          )
                        else
                          Icon(
                            Icons.circle_outlined,
                            color: secondaryTextColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 0.5, color: dividerColor),

                // Hide my email option
                InkWell(
                  onTap: () {
                    setState(() {
                      _shareEmail = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hide My Email',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Forward to your personal email',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!_shareEmail)
                          Icon(
                            Icons.check_circle_rounded,
                            color: isDark ? Colors.white : Colors.black,
                            size: 24,
                          )
                        else
                          Icon(
                            Icons.circle_outlined,
                            color: secondaryTextColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Action button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        // Simulate Face ID / authentication loading delay
                        await Future.delayed(const Duration(seconds: 2));
                        
                        final finalEmail = _shareEmail
                            ? 'gokulsanth@icloud.com'
                            : 'g.santh123@privaterelay.appleid.com';
                            
                        widget.onSignInSuccess(finalEmail);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? CupertinoActivityIndicator(
                        color: buttonTextColor,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face_retouching_natural_rounded, // Face ID-like icon
                            size: 20,
                            color: buttonTextColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Continue with Password / Face ID',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
