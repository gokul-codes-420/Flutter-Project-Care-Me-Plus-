import 'package:flutter/material.dart';

class StepDistancePage extends StatefulWidget {
  const StepDistancePage({super.key});

  @override
  State<StepDistancePage> createState() => _StepDistancePageState();
}

class _StepDistancePageState extends State<StepDistancePage> {
  int _activeTab = 0; // 0: D, 1: W, 2: M, 3: Y
  
  // Custom timeframe data points for both Count and Distance
  final List<String> _tabLabels = ['D', 'W', 'M', 'Y'];
  final List<int> _tabCounts = [0, 38420, 164800, 2185400];
  final List<double> _tabDistances = [0.00, 18.24, 78.40, 1038.50];
  final List<String> _tabSubtitles = ['Today', 'This Week', 'This Month', 'This Year'];

  // Bottom Navigation Bar synchronization active tab index (Summary)
  final int _currentTabIndex = 0;

  void _navigateToTab(int index) {
    if (index == 0) {
      Navigator.pop(context); // Pop back to main
    } else {
      Navigator.pop(context, index); // Pop back and set main active tab
    }
  }

  // Sliding timeframe segmented selector
  Widget _buildTimeframeSelector() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tabWidth = constraints.maxWidth / 4;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: _activeTab * tabWidth,
                width: tabWidth,
                height: 34,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              Row(
                children: List.generate(4, (index) {
                  final bool isActive = _activeTab == index;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _activeTab = index;
                        });
                      },
                      child: Center(
                        child: Text(
                          _tabLabels[index],
                          style: TextStyle(
                            color: isActive ? Colors.white : const Color(0xFF8E8E93),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  // Format steps values
  String _formatSteps(int val) {
    if (val == 0) return '0';
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return val.toString().replaceAllMapped(reg, (Match match) => '${match[1]},');
  }

  // Format distance values
  String _formatDistance(double val) {
    if (val == 0.0) return '0.00';
    return val.toStringAsFixed(2);
  }

  // Combined reusable Card Widget that displays COUNT and DISTANCE metrics and charts
  Widget _buildMetricsCard({
    required String title,
    required Widget valueWidget,
    required Color color,
    required int activeTab,
    required bool isDistance,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151517), // Apple Dark card background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withAlpha(8), // Subtle premium boundary
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Upper label
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),

          // Large glowing numeric values
          valueWidget,
          const SizedBox(height: 18),

          // Graph Grid & Chart Column Layout
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                // Dashed lines background
                Positioned.fill(
                  child: CustomPaint(
                    painter: MiniGridPainter(),
                  ),
                ),
                // Soft glow
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          color.withAlpha(16),
                          Colors.transparent,
                        ],
                        radius: 1.1,
                      ),
                    ),
                  ),
                ),
                // Animated column bars
                Positioned.fill(
                  bottom: 20, // Leave spacing for labels
                  left: 6,
                  right: 6,
                  child: _buildChartColumns(color),
                ),
                // Timeline horizontal labels aligned at bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildTimelineLabels(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Generates timeline columns height transitions
  Widget _buildChartColumns(Color barColor) {
    int columnCount = 24;
    if (_activeTab == 1) columnCount = 7;
    if (_activeTab == 2) columnCount = 15;
    if (_activeTab == 3) columnCount = 12;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(columnCount, (index) {
        double heightFactor = 0.05; // tiny starting height for day (all 0)
        if (_activeTab > 0) {
          // Wave factor math for dynamic representation
          heightFactor = (0.2 + 0.65 * ((index * 9 + 4) % 11 / 11.0));
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              tween: Tween<double>(begin: 0.0, end: heightFactor),
              builder: (context, scale, child) {
                return FractionallySizedBox(
                  heightFactor: scale.clamp(0.04, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          barColor.withAlpha(140),
                          barColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  // Render bottom grid labels
  Widget _buildTimelineLabels() {
    List<String> labels = [];
    if (_activeTab == 0) {
      labels = ['12 am', '6 am', '12 pm', '6 pm'];
    } else if (_activeTab == 1) {
      labels = ['Mon', 'Wed', 'Fri', 'Sun'];
    } else if (_activeTab == 2) {
      labels = ['1st', '10th', '20th', '30th'];
    } else {
      labels = ['Jan', 'Apr', 'Jul', 'Oct'];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        return Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8E8E93),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color premiumPurple = Color(0xFFC084FC); // Count purple
    const Color distanceBlue = Color(0xFF00C7BE); // Distance teal-blue

    return Scaffold(
      backgroundColor: Colors.black, // Dark mode matching screen
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
                  bottom: 120, // avoid floating tabbar
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Custom Header Row with Back Button
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
                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Steps',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                      ),
                    ),
                    
                    // Subtitle "Today / Date range"
                    Text(
                      _tabSubtitles[_activeTab],
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // D-W-M-Y Capsule Selector
                    _buildTimeframeSelector(),
                    const SizedBox(height: 20),

                    // Card 1: COUNT Card (Purple theme)
                    _buildMetricsCard(
                      title: 'COUNT',
                      color: premiumPurple,
                      activeTab: _activeTab,
                      isDistance: false,
                      valueWidget: TweenAnimationBuilder<int>(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        tween: IntTween(begin: 0, end: _tabCounts[_activeTab]),
                        builder: (context, countVal, child) {
                          return Text(
                            _formatSteps(countVal),
                            style: const TextStyle(
                              color: premiumPurple,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              shadows: [
                                Shadow(
                                  color: premiumPurple,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Card 2: DISTANCE Card (Teal-blue theme)
                    _buildMetricsCard(
                      title: 'DISTANCE',
                      color: distanceBlue,
                      activeTab: _activeTab,
                      isDistance: true,
                      valueWidget: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(begin: 0.00, end: _tabDistances[_activeTab]),
                        builder: (context, distVal, child) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                _formatDistance(distVal),
                                style: const TextStyle(
                                  color: distanceBlue,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                  shadows: [
                                    Shadow(
                                      color: distanceBlue,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Text(
                                'MI',
                                style: TextStyle(
                                  color: distanceBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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
        color: const Color(0xFF151517).withAlpha(245), // Frosted dark tabbar bg
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

// Mini Dashed grid painter inside card
class MiniGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(12) // Subtle guidelines inside cards
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;

    // Draw horizontal dashed lines
    final double yStep = (size.height - 20) / 2;
    for (int i = 0; i <= 2; i++) {
      final double y = yStep * i;
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset((startX + dashWidth).clamp(0, size.width), y),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }

    // Draw vertical dashed lines aligned (12am, 6am, 12pm, 6pm)
    final double xStep = size.width / 3;
    for (int i = 0; i <= 3; i++) {
      final double x = xStep * i;
      double startY = 0;
      while (startY < (size.height - 20)) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, (startY + dashWidth).clamp(0, size.height - 20)),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
