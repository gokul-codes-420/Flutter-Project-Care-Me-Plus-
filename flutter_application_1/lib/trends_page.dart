import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  final int _currentTabIndex = 0; // Sync active index with Summary tab on parent

  void _navigateToTab(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, index);
    }
  }

  // Apple-style custom details dialog on clicking the green 'here' link
  void _showTrendsLearnMoreSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Trends Learn More',
      barrierColor: Colors.black.withAlpha(190), // High density dimmed overlay
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, anim2, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

        return SlideTransition(
          position: slideAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF151517), // Deep dark iOS sheet
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withAlpha(12),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C2C2E),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'About Trends',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 38), // Balancing Spacer
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildInfoBullet(
                    icon: Icons.trending_up_rounded,
                    color: const Color(0xFFA6FF00),
                    title: 'Arrow Up',
                    desc: 'You are doing the same or better in the last 90 days compared to your past 365 days. Keep it up!',
                  ),
                  const Divider(color: Color(0xFF2C2C2E), height: 24),

                  _buildInfoBullet(
                    icon: Icons.trending_down_rounded,
                    color: const Color(0xFFFF2D55),
                    title: 'Arrow Down',
                    desc: 'Your average activity in the last 90 days is lower than the past year. Log more sessions to flip your arrow!',
                  ),
                  const Divider(color: Color(0xFF2C2C2E), height: 24),

                  _buildInfoBullet(
                    icon: Icons.query_stats_rounded,
                    color: const Color(0xFF00C7BE),
                    title: 'Metrics Tracked',
                    desc: 'We analyze your daily Distance, Walking Pace, Running Pace, Stand time, and Active Move Calories automatically.',
                  ),
                  const SizedBox(height: 24),

                  // Capsule close button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Got It',
                        style: TextStyle(
                          fontSize: 16,
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
      },
    );
  }

  Widget _buildInfoBullet({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Builder helper for the upward-trending grid cards
  Widget _buildTrendGridItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151517), // Apple dark card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(8), // subtle border boundary
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Glowing Arrow Circle Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: color,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color distanceCyan = Color(0xFF00E5FF); // Neon cyan
    const Color walkingPurple = Color(0xFFC084FC); // Purple
    const Color runningPink = Color(0xFFFF2D55); // Pink/Red
    const Color neonLime = Color(0xFFA6FF00); // Lime-green accent

    return Scaffold(
      backgroundColor: Colors.black, // Sleek black backdrop
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 64,
                  bottom: 120, // avoid floating bottom tabbar
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Custom Header Row with Back button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1C1C1E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Trends',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Section 1: Keep it Going
                    const Text(
                      'Keep it Going',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Grid arrangement for Keep it Going items (2x2 grid where the 3rd spans half width)
                    Row(
                      children: [
                        Expanded(
                          child: _buildTrendGridItem(
                            label: 'Distance',
                            value: '5.2MI/DAY',
                            color: distanceCyan,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTrendGridItem(
                            label: 'Walking Pace',
                            value: '17:09/MI',
                            color: walkingPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTrendGridItem(
                            label: 'Running Pace',
                            value: '8:49/MI',
                            color: runningPink,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: SizedBox.shrink()), // Half-width placeholder
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Section 2: Worth a Look
                    const Text(
                      'Worth a Look',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Move Red card in the "Worth a Look" section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151517),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withAlpha(8),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              // Down Arrow Circle Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: runningPink.withAlpha(25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: runningPink,
                                    size: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Value descriptions
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Move',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '483CAL/DAY',
                                    style: TextStyle(
                                      color: runningPink,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Descriptive motivational paragraph
                          const Text(
                            'Your arrow is down but not for long, Alexis! Flip it by burning 486 calories a day for the next 7 days.',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 13.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 3: Explanation Footer
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 13.5,
                          height: 1.45,
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          const TextSpan(
                            text: 'Trends compares your last 90 days of activity to the last 365. If you are doing the same or better, your arrow will be up. If you aren\'t doing as well, it will be down. You can learn more about Trends ',
                          ),
                          TextSpan(
                            text: 'here',
                            style: const TextStyle(
                              color: neonLime,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _showTrendsLearnMoreSheet(context),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Floating iOS bottom Tab Bar overlay
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: _buildFloatingBottomTabBar(
                const Color(0xFFFF2D55),
                const Color(0xFF00C7BE),
                const Color(0xFF38D430),
                const Color(0xFF5856D6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Cupertino bottom navigation bar
  Widget _buildFloatingBottomTabBar(
    Color summaryColor, 
    Color fitnessPlusColor, 
    Color workoutColor, 
    Color sharingColor,
  ) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151517).withAlpha(245), // iOS dark frosted tab bg
        borderRadius: BorderRadius.circular(38),
        border: Border.all(
          color: Colors.white.withAlpha(12), 
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(150),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabBarItem(
            icon: Icons.album_outlined,
            label: 'Summary',
            isActive: _currentTabIndex == 0,
            activeColor: summaryColor,
            index: 0,
          ),
          _buildTabBarItem(
            icon: Icons.alarm_rounded,
            label: 'Fitness+',
            isActive: _currentTabIndex == 1,
            activeColor: fitnessPlusColor,
            index: 1,
          ),
          _buildTabBarItem(
            icon: Icons.directions_run_rounded,
            label: 'Workout',
            isActive: _currentTabIndex == 2,
            activeColor: workoutColor,
            index: 2,
          ),
          _buildTabBarItem(
            icon: Icons.people_alt_rounded,
            label: 'Sharing',
            isActive: _currentTabIndex == 3,
            activeColor: sharingColor,
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required int index,
  }) {
    final Color itemColor = isActive ? activeColor : const Color(0xFF8E8E93);

    return Expanded(
      child: GestureDetector(
        onTap: () => _navigateToTab(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: itemColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: itemColor,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
