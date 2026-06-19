import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Retreiving signed in email from arguments
    final String email = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // High premium success custom icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF3CD49B).withAlpha(30), // soft mint green background
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF3CD49B),
                    size: 64,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              
              Text(
                'Success!',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                'You have successfully logged in using:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF3A5BDB), // Premium Blue
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 48),
              
              // Proceed button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the beautiful Fitness Welcome Screen
                    Navigator.pushReplacementNamed(context, '/fitness-welcome');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3CD49B), // Mint Green Success Color
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Continue to Fitness',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
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
