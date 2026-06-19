import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _agreeToTerms = false; // State for checkbox

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailPasswordSignUp() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms & Conditions')),
      );
      return;
    }

    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A5BDB)),
        ),
      ),
    );

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Update display name
      if (credential.user != null) {
        await credential.user!.updateDisplayName(_nameController.text.trim());
      }
      
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
      
      String message = e.message ?? 'Sign up failed';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      
      _showSignUpErrorDialog(
        title: 'Sign Up Error',
        message: message,
        fallbackEmail: _emailController.text,
      );
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading indicator
      _showSignUpErrorDialog(
        title: 'Error',
        message: e.toString(),
        fallbackEmail: _emailController.text,
      );
    }
  }

  Future<void> _handleGoogleSignUp() async {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3A5BDB)),
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
      
      _showSignUpErrorDialog(
        title: 'Google Sign In Error',
        message: 'Google Sign-In failed or is not configured yet on Firebase Console.\nDetails: ${e.toString()}',
        fallbackEmail: 'gamingtamizha509@gmail.com',
      );
    }
  }

  void _showSignUpErrorDialog({
    required String title,
    required String message,
    required String fallbackEmail,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          '$message\n\nWould you like to bypass this error and proceed in Demo Mode?',
          style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try Again', style: TextStyle(color: Color(0xFF8E8E93), fontWeight: FontWeight.w600)),
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
              backgroundColor: const Color(0xFF9EFF00), // Lime Green
              foregroundColor: Colors.black,
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
    const Color limeGreen = Color(0xFF9EFF00); // Premium neon lime green
    final Color inputBg = isDark ? const Color(0xFF2C2C2E) : Colors.white; // Dynamic input background
    const Color linkColor = Color(0xFF3A5BDB);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded, 
            color: isDark ? Colors.white : const Color(0xFF1C1C1E),  
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Block
                const Text(
                  'Create An Account',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Description block
                const Text(
                  'Create an account to set goals, track your progress, and stay motivated every step of the way.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.5,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Text Fields Form
                // Name Field
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14.5),
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  fontSize: 15),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14.5),
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14.5),
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14.5),
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Checkbox terms row
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _agreeToTerms = !_agreeToTerms;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _agreeToTerms ? limeGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _agreeToTerms ? limeGreen : const Color(0xFFD1D1D6),
                            width: 1.5,
                          ),
                        ),
                        child: _agreeToTerms
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'I agree to the Terms & Condition',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Lime green button: Create an Account
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleEmailPasswordSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: limeGreen,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Divider "Or Login with"
                Row(
                  children: [
                    Expanded(child: Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or Login with',
                        style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF6C6C70), fontSize: 13),
                      ),
                    ),
                    Expanded(child: Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1)),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Badges Row: Google, Facebook, Apple
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularSocialBadge(
                      iconWidget: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                        height: 20,
                        width: 20,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.g_mobiledata_rounded, color: Colors.white,  size: 24),
                      ),
                      onTap: _handleGoogleSignUp,
                      bg: const Color(0xFF1C1C1E),
                    ),
                    const SizedBox(width: 20),
                    _buildCircularSocialBadge(
                      iconWidget: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 22),
                      onTap: () => _simulateSocialSignUp('Facebook'),
                      bg: const Color(0xFF1C1C1E),
                    ),
                    const SizedBox(width: 20),
                    _buildCircularSocialBadge(
                      iconWidget: Icon(Icons.apple_rounded, color: isDark ? Colors.white : Colors.black, size: 24),
                      onTap: () => _simulateSocialSignUp('Apple'),
                      bg: const Color(0xFF1C1C1E),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Already have an account? Login
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to login
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: linkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularSocialBadge({
    required Widget iconWidget,
    required VoidCallback onTap,
    required Color bg,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),
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

  void _simulateSocialSignUp(String provider) {
    Navigator.pushNamed(
      context,
      '/google-mock',
      arguments: provider == 'Apple' ? 'apple.signup@icloud.com' : 'social.signup@gmail.com',
    );
  }
}
