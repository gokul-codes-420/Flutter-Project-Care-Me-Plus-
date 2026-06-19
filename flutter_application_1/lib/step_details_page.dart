import 'package:flutter/material.dart';

class StepDetailsPage extends StatefulWidget {
  const StepDetailsPage({super.key});

  @override
  State<StepDetailsPage> createState() => _StepDetailsPageState();
}

class _StepDetailsPageState extends State<StepDetailsPage> with SingleTickerProviderStateMixin {
  int _activeTab = 0; // 0: D, 1: W, 2: M, 3: Y
  late AnimationController _tabSlideController;

  // Custom data states for premium interactivity
  final List<String> _tabLabels = ['D', 'W', 'M', 'Y'];
  final List<int> _tabTotals = [0, 38420, 164800, 2185400];
  final List<String> _tabSubtitles = ['Today', 'This Week', 'This Month', 'This Year'];

  // Bottom Navigation Bar state (aligned with Summary page, where 0 is Summary active)
  final int _currentTabIndex = 0; 

  @override
  void initState() {
    super.initState();
    _tabSlideController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabSlideController.dispose();
    super.dispose();
  }

  // Taps a bottom bar tab and returns the index to the main screen to sync state
  void _navigateToTab(int index) {
    if (index == 0) {
      Navigator.pop(context); // Go back to summary
    } else {
      Navigator.pop(context, index); // Pop back and pass tab index to main page
    }
  }

  // Apple-style custom slider toggle for D, W, M, Y
  Widget _buildTimeframeSelector() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E), // Dark capsule background
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tabWidth = constraints.maxWidth / 4;
          return Stack(
            children: [
              // Sliding selection pill with spring curve
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: _activeTab * tabWidth,
                width: tabWidth,
                height: 34,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3C), // Active slider pill
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              // Tab labels
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

  // View All Steps Metrics custom bottom sheet with Apple premium style
  void _showStepsMetricsSheet(BuildContext context) {
    const Color premiumPurple = Color(0xFFC084FC);
    const Color neonLime = Color(0xFFA6FF00);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Metrics Sheet',
      barrierColor: Colors.black.withAlpha(180), // Deep dimmed backdrop
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
                  // Top close pill/bar row
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
                        'Steps Metrics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 38), // Center balancer
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Interactive stats cards list
                  _buildMetricStatRow(
                    icon: Icons.directions_walk_rounded,
                    title: 'Daily Average',
                    value: '6,480 steps',
                    subtitle: '15% higher than last week',
                    color: premiumPurple,
                  ),
                  const Divider(color: Color(0xFF2C2C2E), height: 24),

                  _buildMetricStatRow(
                    icon: Icons.electric_bolt_rounded,
                    title: 'Peak Activity',
                    value: '5:12 pm',
                    subtitle: 'Average 1,240 steps in this hour',
                    color: neonLime,
                  ),
                  const Divider(color: Color(0xFF2C2C2E), height: 24),

                  _buildMetricStatRow(
                    icon: Icons.map_rounded,
                    title: 'Total Distance Covered',
                    value: '2.84 Miles / Day',
                    subtitle: 'Equivalent to 45 mins walking',
                    color: const Color(0xFF00C7BE),
                  ),
                  const Divider(color: Color(0xFF2C2C2E), height: 24),

                  _buildMetricStatRow(
                    icon: Icons.stairs_rounded,
                    title: 'Flights Climbed',
                    value: '4 Flights',
                    subtitle: 'Climbed today',
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 20),

                  // Capsule button to close sheet
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
                        'Close',
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

  // Inner stats widget builder
  Widget _buildMetricStatRow({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color premiumPurple = Color(0xFFC084FC); // Bright lavender purple
    const Color neonLime = Color(0xFFA6FF00); // Premium neon-green

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
                  bottom: 120, // Avoid bottom bar
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Custom Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Circular dark back button
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

                    // Big Left-Aligned Title
                    const Text(
                      'Step Count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Timeframe D-W-M-Y Selector
                    _buildTimeframeSelector(),
                    const SizedBox(height: 28),

                    // Steps Counter & Metric labels
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Large steps value with dynamic counter transitions
                    TweenAnimationBuilder<int>(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      tween: IntTween(begin: 0, end: _tabTotals[_activeTab]),
                      builder: (context, value, child) {
                        return Text(
                          _formatSteps(value),
                          style: const TextStyle(
                            color: premiumPurple,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                            shadows: [
                              Shadow(
                                color: premiumPurple,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),

                    Text(
                      _tabSubtitles[_activeTab],
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Custom Dashed Grid Chart with Glow & Interactive Columns
                    Container(
                      height: 250,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Stack(
                        children: [
                          // Background grid & Neon Purple glow layer
                          Positioned.fill(
                            child: CustomPaint(
                              painter: DashedGridPainter(),
                            ),
                          ),
                          
                          // Soft Ambient Glow underneath the chart
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    premiumPurple.withAlpha(24),
                                    Colors.transparent,
                                  ],
                                  radius: 0.9,
                                  center: Alignment.center,
                                ),
                              ),
                            ),
                          ),

                          // Dynamic columns based on active tab
                          Positioned.fill(
                            bottom: 24, // Keep spacing for timeline labels
                            left: 10,
                            right: 10,
                            child: _buildChartColumns(),
                          ),

                          // Bottom timeline labels positioned carefully
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: _buildTimelineLabels(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Lime-Green Capsule Action Button: "View All Steps Metrics"
                    GestureDetector(
                      onTap: () => _showStepsMetricsSheet(context),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withAlpha(8),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'View All Steps Metrics',
                            style: TextStyle(
                              color: neonLime,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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

  // Format integer steps with commas
  String _formatSteps(int val) {
    if (val == 0) return '0';
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return val.toString().replaceAllMapped(reg, (Match match) => '${match[1]},');
  }

  // Renders dynamic interactive bars representing steps distribution
  Widget _buildChartColumns() {
    int columnCount = 24;
    if (_activeTab == 1) columnCount = 7;
    if (_activeTab == 2) columnCount = 15;
    if (_activeTab == 3) columnCount = 12;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(columnCount, (index) {
        // Compute realistic height ratios
        double heightFactor = 0.0;
        if (_activeTab > 0) {
          // Add some fun wavy math for high fidelity visual representation
          heightFactor = (0.2 + 0.6 * ((index * 7 + 3) % 9 / 9.0));
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutBack,
              tween: Tween<double>(begin: 0.0, end: heightFactor),
              builder: (context, scale, child) {
                return FractionallySizedBox(
                  heightFactor: scale.clamp(0.02, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFF5856D6), // Deep purple
                          Color(0xFFC084FC), // Glowing lavender
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
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

  // Render bottom timeline labels aligned perfectly with active tab
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
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }

  // Mirror the floating premium bottom navigation bar
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

// Dashed grid custom painter matching Apple style precisely
class DashedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(16) // Subtle lines
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.5;
    const dashSpace = 3.5;

    // Draw horizontal dashed lines
    final double yStep = (size.height - 24) / 3;
    for (int i = 0; i <= 3; i++) {
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

    // Draw vertical dashed lines aligned to key indices (12am, 6am, 12pm, 6pm etc)
    final double xStep = size.width / 3;
    for (int i = 0; i <= 3; i++) {
      final double x = xStep * i;
      double startY = 0;
      while (startY < (size.height - 24)) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, (startY + dashWidth).clamp(0, size.height - 24)),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
