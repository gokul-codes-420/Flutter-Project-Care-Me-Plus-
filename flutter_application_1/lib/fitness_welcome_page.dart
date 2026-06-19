import 'package:flutter/material.dart';

class FitnessWelcomePage extends StatelessWidget {
  const FitnessWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 36),
              // Main Title
              Text(
                'Welcome to Fitness',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 48),
              
              // Features List
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Feature 1: See Your Activity
                      _buildFeatureItem(
                        iconWidget: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF38D430), // Crisp exercise green
                              width: 4.5,
                            ),
                          ),
                        ),
                        title: 'See Your Activity',
                        description: 'Keep up with your rings, workouts, awards, and trends.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 32),
                      
                      // Feature 2: Track Your Workouts
                      _buildFeatureItem(
                        iconWidget: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF2D55), // Vibrant Move red/pink
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_run_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: 'Track Your Workouts',
                        description: 'See metrics like your pace and distance, or connect a device with a heart rate sensor for more workout types and data.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 32),
                      
                      // Feature 3: Work Out With Fitness+
                      _buildFeatureItem(
                        iconWidget: const Icon(
                          Icons.add_alarm_rounded,
                          color: Color(0xFF00C7BE), // Premium stand blue
                          size: 38,
                        ),
                        title: 'Work Out With Fitness+',
                        description: '12 workout types and meditation for all levels from friendly, expert trainers.',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 32),
                      
                      // Feature 4: Share With Others
                      _buildFeatureItem(
                        iconWidget: const Icon(
                          Icons.people_alt_rounded,
                          color: Color(0xFF5856D6), // iOS purple
                          size: 38,
                        ),
                        title: 'Share With Others',
                        description: 'Cheer on your friends as everyone closes their rings.',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Continue Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to Personalize Screen
                  Navigator.pushNamed(context, '/fitness-personalize');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : const Color(0xFF1C1C1E), // Dynamic button
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required Widget iconWidget,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customized Icon Container
        SizedBox(
          width: 38,
          child: Center(child: iconWidget),
        ),
        const SizedBox(width: 20),
        
        // Content details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF636366), // iOS Light Mode secondary label grey
                  fontSize: 14.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
