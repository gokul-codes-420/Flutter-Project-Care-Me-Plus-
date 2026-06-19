import 'package:flutter/material.dart';

class FakeTrainingAppPage extends StatelessWidget {
  const FakeTrainingAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Nav / Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C1C1E),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.favorite_rounded,
                              color: Colors.white, size: 20),
                          Transform.rotate(
                            angle: 0.45,
                            child: Container(
                              width: 2,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  const SizedBox(height: 10),
                  // Title
                  const Text(
                    'Fake Training App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Managed App Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.cyclone_rounded,
                              color: Color(0xFF007AFF),
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'These workouts are managed by Fake Training App',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A3A3C),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Center(
                            child: Text(
                              'Open App',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Today Section
                  const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '23 May',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Workout List
                  _buildWorkoutRow(
                    title: 'Outdoor Cycle',
                    subtitle: 'Sprint Session',
                    icon: Icons.directions_bike_rounded,
                    color: const Color(0xFFA259FF),
                  ),
                  _buildWorkoutRow(
                    title: 'Running',
                    subtitle: 'Alerts!',
                    icon: Icons.directions_run_rounded,
                    color: const Color(0xFFA259FF),
                  ),
                  _buildWorkoutRow(
                    title: 'Cross Country Skiing',
                    subtitle: '1HR',
                    icon: Icons.downhill_skiing_rounded,
                    color: const Color(0xFFFFD60A),
                  ),
                  _buildWorkoutRow(
                    title: 'Running',
                    subtitle: 'Power Alerts',
                    icon: Icons.directions_run_rounded,
                    color: const Color(0xFFA259FF),
                  ),
                  _buildWorkoutRow(
                    title: 'Cycling',
                    subtitle: 'Power Alerts',
                    icon: Icons.directions_bike_rounded,
                    color: const Color(0xFFA259FF),
                  ),
                  
                  const SizedBox(height: 32),

                  // Upcoming Section
                  const Text(
                    'Upcoming',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '7 Days',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildWorkoutRow(
                    title: 'Indoor Run',
                    subtitle: '5,000M',
                    icon: Icons.directions_run_rounded,
                    color: const Color(0xFF32ADE6), // Light blue
                  ),
                  _buildWorkoutRow(
                    title: 'Outdoor Run',
                    subtitle: '2MI • 17MIN',
                    icon: Icons.directions_run_rounded,
                    color: const Color(0xFF00C7BE), // Mint
                  ),
                  _buildWorkoutRow(
                    title: 'High Intensity\nInterval Training',
                    subtitle: '30MIN',
                    icon: Icons.accessibility_new_rounded,
                    color: const Color(0xFFFFD60A), // Yellow
                  ),
                  _buildWorkoutRow(
                    title: 'Functional Strength Training',
                    subtitle: null,
                    icon: Icons.sports_gymnastics_rounded,
                    color: const Color(0xFFC4FF00), // Lime Green
                  ),

                  const SizedBox(height: 24),

                  // Footer text
                  const Text(
                    'These workouts were created by "Fake Training App". Connected Today, 23 May 2026.',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Disconnect button
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: const Color(0xFF1C1C1E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Disconnect from "Fake\nTraining App"?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3A3A3C),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context); // Close dialog
                                            Navigator.pop(context); // Pop fake training app page
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3A3A3C),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Disconnect',
                                                style: TextStyle(
                                                  color: Color(0xFFFF3B30),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A0010), // Dark red background
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: const Center(
                        child: Text(
                          'Disconnect',
                          style: TextStyle(
                            color: Color(0xFFFF3B30), // Bright red text
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // padding for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      // Custom dark bottom navigation bar overlay
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E).withAlpha(240),
          border: const Border(top: BorderSide(color: Color(0xFF3A3A3C), width: 0.5)),
        ),
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.album_outlined, 'Summary', const Color(0xFF8E8E93), false),
            _buildNavItem(Icons.alarm_rounded, 'Fitness+', const Color(0xFF8E8E93), false),
            _buildNavItem(Icons.directions_run_rounded, 'Workout', const Color(0xFFC4FF00), true),
            _buildNavItem(Icons.people_alt_rounded, 'Sharing', const Color(0xFF8E8E93), false),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutRow({
    required String title,
    required String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A3A3C), width: 1),
            ),
            child: Center(
              child: Icon(
                Icons.watch_rounded,
                color: color.withAlpha(150),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, Color color, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isActive)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black, size: 28),
          )
        else
          Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
