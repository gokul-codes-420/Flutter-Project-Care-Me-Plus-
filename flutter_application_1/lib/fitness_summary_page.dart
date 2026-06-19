import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_mock_page.dart';
import 'workout_countdown_page.dart';
import 'fake_training_app_page.dart';

class FitnessSummaryPage extends StatefulWidget {
  final int calorieTarget;

  const FitnessSummaryPage({
    super.key,
    required this.calorieTarget,
  });

  @override
  State<FitnessSummaryPage> createState() => _FitnessSummaryPageState();
}

class _FitnessSummaryPageState extends State<FitnessSummaryPage> with TickerProviderStateMixin {
  Color get darkSlateText => Theme.of(context).brightness == Brightness.dark ? Colors.white : Color(0xFF1C1C1E);

  bool _showCustomizableBanner = true;
  int _currentTabIndex = 0; // 0 for Summary, 1 for Fitness+
  int _workoutSubPage = 0; // 0 for Workouts Onboarding, 1 for Workout Buddy, 2 for Dashboard
  String _selectedFitnessPill = 'For You';
  bool _isFitnessSearchActive = false;
  // ignore: unused_field
  bool _showSharingOnboarding = true;
  // ignore: unused_field, prefer_final_fields
  bool _hasSharingFriendsAdded = false;
  // ignore: unused_field
  bool _hasCompletedPlanBeenShown = false;
  bool _showWatchBanner = true;

  // Scroll controllers for frosted glass status bar blur effect
  late ScrollController _summaryScrollController;
  late ScrollController _fitnessScrollController;
  late ScrollController _workoutScrollController;
  late ScrollController _sharingScrollController;

  double _summaryScrollOffset = 0.0;
  double _fitnessScrollOffset = 0.0;
  double _workoutScrollOffset = 0.0;
  double _sharingScrollOffset = 0.0;

  // Breathing pulse controller for custom activity ring
  late AnimationController _ringPulseController;
  bool _isRingPulseControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _ringPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _isRingPulseControllerInitialized = true;

    _summaryScrollController = ScrollController();
    _summaryScrollController.addListener(() {
      if (_summaryScrollController.hasClients) {
        setState(() {
          _summaryScrollOffset = _summaryScrollController.offset;
        });
      }
    });

    _fitnessScrollController = ScrollController();
    _fitnessScrollController.addListener(() {
      if (_fitnessScrollController.hasClients) {
        setState(() {
          _fitnessScrollOffset = _fitnessScrollController.offset;
        });
      }
    });

    _workoutScrollController = ScrollController();
    _workoutScrollController.addListener(() {
      if (_workoutScrollController.hasClients) {
        setState(() {
          _workoutScrollOffset = _workoutScrollController.offset;
        });
      }
    });

    _sharingScrollController = ScrollController();
    _sharingScrollController.addListener(() {
      if (_sharingScrollController.hasClients) {
        setState(() {
          _sharingScrollOffset = _sharingScrollController.offset;
        });
      }
    });
  }

  @override
  void dispose() {
    _ringPulseController.dispose();
    _summaryScrollController.dispose();
    _fitnessScrollController.dispose();
    _workoutScrollController.dispose();
    _sharingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color fitnessPink = Color(0xFFFF2D55); // Premium iOS Fitness Move Pink
    const Color activeTeal = Color(0xFF00C7BE); // Fitness+ Teal
    const Color exerciseGreen = Color(0xFF38D430); // Workout exercise green
    const Color sharingPurple = Color(0xFF5856D6); // Sharing Purple
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDarkTheme ? Color(0xFF1C1C1E) : Colors.white; // Dynamic card background
    final Color pageBg = isDarkTheme ? Colors.black : Color(0xFFF2F2F7); // Dynamic scaffold background
    // Removed local darkSlateText variable
    const Color slateGraySubdued = Color(0xFF8E8E93); // Subdued slate-grey text

    double activeOffset = 0.0;
    if (_currentTabIndex == 0) {
      activeOffset = _summaryScrollOffset;
    } else if (_currentTabIndex == 1) {
      activeOffset = _fitnessScrollOffset;
    } else if (_currentTabIndex == 2) {
      if (_workoutSubPage == 2) {
        activeOffset = _workoutScrollOffset;
      }
    } else if (_currentTabIndex == 3) {
      activeOffset = _sharingScrollOffset;
    }

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        top: false,
        bottom: false, // Ensure custom floating tabbar is clean at bottom
        child: Stack(
          children: [
            // Scrollable Content
            Positioned.fill(
              child: _currentTabIndex == 0
                  ? SingleChildScrollView(
                      controller: _summaryScrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 64,
                        bottom: 120, // Padding to avoid overlap with floating tabbar
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top Custom Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Summary',
                                    style: TextStyle(
                                      color: darkSlateText,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getFormattedDate(),
                                    style: TextStyle(
                                      color: slateGraySubdued,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              // Profile Avatar Styled like iOS Fitness
                              GestureDetector(
                                onTap: () => _showAccountBottomSheet(context),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: fitnessPink, width: 2),
                                    color: const Color(0xFF2C2C2E),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: _buildProfileAvatar(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 1. Dismissible "A Customizable Summary" Card
                          if (_showCustomizableBanner) ...[
                            _buildCustomizableSummaryBanner(cardBg, fitnessPink),
                            const SizedBox(height: 20),
                          ],

                          // 2. Activity Ring Card
                          _buildActivityRingCard(cardBg, fitnessPink),
                          const SizedBox(height: 20),

                          // 3. Metric cards row (Step Count & Step Distance)
                          Row(
                            children: [
                              Expanded(child: _buildStepCountCard(cardBg)),
                              const SizedBox(width: 14),
                              Expanded(child: _buildStepDistanceCard(cardBg)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 4. Sessions Card (half-width, left aligned)
                          _buildSessionsRow(cardBg),
                          const SizedBox(height: 20),

                          // 5. Fitness+ Content Unavailable Card
                          _buildFitnessPlusCard(cardBg, activeTeal),
                          const SizedBox(height: 20),

                          // 6. Trends Card
                          _buildTrendsCard(cardBg),
                          const SizedBox(height: 20),

                          _buildTrainerTipsRow(cardBg),
                          const SizedBox(height: 32),
                          const Divider(color: Color(0xFF2C2C2E), height: 1, thickness: 1),
                          const SizedBox(height: 24),

                          // 8. Edit Summary Pill Button
                          _buildActionPillButton(
                            label: 'Edit Summary',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit Summary Mode Active'),
                                  backgroundColor: fitnessPink,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            cardBg: cardBg,
                            accentColor: fitnessPink,
                          ),
                          const SizedBox(height: 14),

                          // 9. See All Categories Pill Button
                          _buildActionPillButton(
                            label: 'See All Categories',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('See All Categories Clicked'),
                                  backgroundColor: fitnessPink,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            cardBg: cardBg,
                            accentColor: fitnessPink,
                          ),
                        ],
                      ),
                    )
                  : _currentTabIndex == 1
                      ? _buildFitnessPlusDashboard(activeTeal, cardBg)
                      : _currentTabIndex == 2
                          ? (_workoutSubPage == 0
                              ? _buildWorkoutOnboarding(exerciseGreen, cardBg)
                              : _workoutSubPage == 1
                                  ? _buildWorkoutBuddyScreen(exerciseGreen, cardBg)
                                  : _buildWorkoutDashboard(exerciseGreen, cardBg))
                          : _buildSharingDashboard(sharingPurple, cardBg),
            ),

             // Floating iOS bottom Tab Bar
             if (!(_currentTabIndex == 2 && _workoutSubPage == 1))
               Positioned(
                 left: 20,
                 right: 20,
                 bottom: 24,
                 child: _buildFloatingBottomTabBar(
                   fitnessPink,
                   activeTeal,
                   exerciseGreen,
                   _currentTabIndex == 3 ? const Color(0xFFA6FF00) : sharingPurple,
                 ),
               ),

             // Dynamic Frosted Glass Status Bar Blur Overlay on Scroll
             if (activeOffset > 0.5)
               Positioned(
                 top: 0,
                 left: 0,
                 right: 0,
                 height: 54, // Covers status bar, notch, and Dynamic Island perfectly!
                 child: ClipRect(
                   child: BackdropFilter(
                     filter: ImageFilter.blur(
                       sigmaX: ((activeOffset / 20.0).clamp(0.0, 1.0) * 15.0),
                       sigmaY: ((activeOffset / 20.0).clamp(0.0, 1.0) * 15.0),
                     ),
                     child: Container(
                       decoration: BoxDecoration(
                         gradient: LinearGradient(
                           begin: Alignment.topCenter,
                           end: Alignment.bottomCenter,
                           colors: [
                             Colors.black.withAlpha(
                               ((activeOffset / 20.0).clamp(0.0, 1.0) * 230).round(),
                             ),
                             Colors.black.withAlpha(
                               ((activeOffset / 20.0).clamp(0.0, 1.0) * 0).round(), // Fades completely to transparent!
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
           ],
        ),
      ),
    );
  }

  // Returns formatted date like "Friday 22 May"
  String _getFormattedDate() {
    final now = DateTime.now();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    // Safety check for weekday bounds
    final dayName = days[(now.weekday - 1) % 7];
    final monthName = months[(now.month - 1) % 12];
    
    return '$dayName ${now.day} $monthName';
  }

  // "A Customizable Summary" banner widget
  Widget _buildCustomizableSummaryBanner(Color cardBg, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customizable icon (Nested concentric circles mockup)
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.album_outlined,
                  color: Color(0xFF8E8E93),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              // Header title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A Customizable Summary',
                      style: TextStyle(
                        color: darkSlateText,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You can make your Summary tab your own, with custom views of everything from your distance totals and average pace to expanded views of trends and tips.',
                      style: TextStyle(
                        color: const Color(0xFF48484A),
                        fontSize: 14.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              // Close Icon Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showCustomizableBanner = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF48484A),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Large grey pill button: "Edit Your Summary"
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Customize Mode Activated!'),
                  backgroundColor: accentColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C2C2E),
              foregroundColor: accentColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Edit Your Summary',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Large Move Activity Ring Card
  Widget _buildActivityRingCard(Color cardBg, Color fitnessPink) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/activity-details',
          arguments: widget.calorieTarget,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Activity Ring',
              style: TextStyle(
                color: darkSlateText,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Ring Graphic Stack
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular Progress custom painter with neon glow and sweep gradient
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CustomPaint(
                        painter: UniqueActivityRingPainter(
                          progress: 0.05, // startup mockup progress
                          ringColor: fitnessPink,
                        ),
                      ),
                    ),
                    // Breathing pulse Apple circular arrow at top of ring
                    Positioned(
                      top: 0,
                      child: _isRingPulseControllerInitialized
                        ? AnimatedBuilder(
                            animation: _ringPulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 0.94 + 0.12 * _ringPulseController.value,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: fitnessPink,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: fitnessPink.withAlpha(
                                          (100 + 155 * _ringPulseController.value).round(),
                                        ),
                                        blurRadius: 6.0 + 8.0 * _ringPulseController.value,
                                        spreadRadius: 1.0 * _ringPulseController.value,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: fitnessPink,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                // Move Labels
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Move',
                      style: TextStyle(
                        color: darkSlateText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                            color: fitnessPink,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '/${widget.calorieTarget} CAL',
                          style: TextStyle(
                            color: fitnessPink,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Side-by-side Card: Step Count
  Widget _buildStepCountCard(Color cardBg) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(context, '/step-details');
        if (result is int) {
          setState(() {
            _currentTabIndex = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 180,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step Count',
                  style: TextStyle(
                    color: darkSlateText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color(0xFF8E8E93).withAlpha(150),
                  size: 12,
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Today',
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              '0',
              style: TextStyle(
                color: darkSlateText,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Hourly vertical bar chart
            _buildHourlyBarChart(const Color(0xFF5856D6).withAlpha(40)),
          ],
        ),
      ),
    );
  }

  // Side-by-side Card: Step Distance
  Widget _buildStepDistanceCard(Color cardBg) {
    const Color distanceBlue = Color(0xFF00C7BE); // Premium teal-cyan

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(context, '/step-distance');
        if (result is int) {
          setState(() {
            _currentTabIndex = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 180,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step Distance',
                  style: TextStyle(
                    color: darkSlateText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color(0xFF8E8E93).withAlpha(150),
                  size: 12,
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Today',
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
            ),
            const SizedBox(height: 6),
            const Text(
              '0.00 MI',
              style: TextStyle(
                color: distanceBlue,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Hourly vertical bar chart
            _buildHourlyBarChart(distanceBlue.withAlpha(40)),
          ],
        ),
      ),
    );
  }

  // Draw 24-column vertical hourly chart
  Widget _buildHourlyBarChart(Color barColor) {
    return Column(
      children: [
        // Bar Rows
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(24, (index) {
              // Create dynamic variations in default track bars
              final double heightPct = (index % 4 == 0) ? 0.3 : 0.12;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.2),
                  child: Container(
                    height: 40 * heightPct,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 6),
        // Chart Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('12 am', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 8)),
            Text('6 am', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 8)),
            Text('12 pm', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 8)),
            Text('6 pm', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 8)),
          ],
        ),
      ],
    );
  }

  // Floating Cupertino bottom navigation bar (frosted white light theme or dark theme dynamically)
  Widget _buildFloatingBottomTabBar(Color summaryColor, Color fitnessPlusColor, Color workoutColor, Color sharingColor) {
    final bool isSystemDark = Theme.of(context).brightness == Brightness.dark;
    final bool isDark = isSystemDark || _currentTabIndex == 3;

    final Color barBgColor = isDark ? const Color(0xDD1C1C1E) : const Color(0xDDFFFFFF);
    final Border barBorder = Border.all(
      color: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(20),
      width: 1,
    );
    final List<BoxShadow> barShadow = [
      BoxShadow(
        color: isDark ? Colors.black.withAlpha(40) : Colors.black.withAlpha(15),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ];

    // Sliding liquid glass pill background styling:
    final Color pillColor = isDark ? Colors.white.withAlpha(30) : Colors.black.withAlpha(15);
    final Border pillBorder = Border.all(
      color: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(15),
      width: 1.2,
    );
    final List<BoxShadow> pillShadow = [
      BoxShadow(
        color: isDark ? Colors.black.withAlpha(40) : Colors.black.withAlpha(15),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ];

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: barBgColor,
        borderRadius: BorderRadius.circular(38),
        border: barBorder,
        boxShadow: barShadow,
      ),
      child: Stack(
        children: [
          // 1. Sliding Liquid Glass Pill Background
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / 4;
                  return AnimatedAlign(
                    alignment: Alignment(-1.0 + (_currentTabIndex * 2.0 / 3.0), 0.0),
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutBack, // Springy bounce "liquid glass" curve!
                    child: Container(
                      width: itemWidth - 4, // slight margin inside item
                      height: 58, // height of active pill
                      decoration: BoxDecoration(
                        color: pillColor,
                        borderRadius: BorderRadius.circular(29),
                        border: pillBorder,
                        boxShadow: pillShadow,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // 2. Tab Bar Items Row (placed in front of the sliding pill)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabBarItem(
                  icon: Icons.album_outlined,
                  label: 'Summary',
                  isActive: _currentTabIndex == 0,
                  activeColor: summaryColor,
                  index: 0,
                  isDark: isDark,
                ),
                _buildTabBarItem(
                  icon: Icons.alarm_rounded,
                  label: 'Fitness+',
                  isActive: _currentTabIndex == 1,
                  activeColor: fitnessPlusColor,
                  index: 1,
                  isDark: isDark,
                ),
                _buildTabBarItem(
                  icon: Icons.directions_run_rounded,
                  label: 'Workout',
                  isActive: _currentTabIndex == 2,
                  activeColor: workoutColor,
                  index: 2,
                  isDark: isDark,
                ),
                _buildTabBarItem(
                  icon: Icons.people_alt_rounded,
                  label: 'Sharing',
                  isActive: _currentTabIndex == 3,
                  activeColor: sharingColor,
                  index: 3,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab Item Builder
  Widget _buildTabBarItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required int index,
    required bool isDark,
  }) {
    final Color itemColor = isActive 
        ? activeColor 
        : (isDark ? Colors.white60 : Colors.black54);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == 'Fitness+') {
            _showWelcomeToFitnessPlusModal(context);
          } else if (index == 0) {
            setState(() {
              _currentTabIndex = 0;
            });
          } else if (index == 2) {
            setState(() {
              _currentTabIndex = 2;
            });
          } else if (index == 3) {
            setState(() {
              _currentTabIndex = 3;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label tab clicked!'),
                backgroundColor: activeColor.withAlpha(150),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: AnimatedScale(
          scale: isActive ? 1.05 : 0.94,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack, // Playful premium springy spring bounce effect!
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic, // Smooth premium curve
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (label == 'Fitness+' && isActive)
                  ? _buildActiveFitnessPlusIcon(activeColor)
                  : (label == 'Workout' && isActive)
                      ? _buildActiveWorkoutIcon(activeColor)
                      : Icon(
                          icon,
                          color: itemColor,
                          size: 24,
                        ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: itemColor,
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sessions & Awards row Widget (side-by-side equal-width cards in Light Mode)
  Widget _buildSessionsRow(Color cardBg) {
    return Row(
      children: [
        // 1. Sessions Card
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/sessions');
              if (result is int) {
                setState(() {
                  _currentTabIndex = result;
                });
              }
            },
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sessions',
                        style: TextStyle(
                          color: darkSlateText,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C2C2E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF8E8E93),
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No sessions recorded.',
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        
        // 2. High-Fidelity Awards Card matching the screenshot
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/awards');
            },
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Title & trailing iOS Chevron
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Awards',
                        style: TextStyle(
                          color: darkSlateText,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C2C2E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF8E8E93),
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  // Vector Badge Medal Graphic and description
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 4),
                        // Premium Custom Vector Medal Shape
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: CustomPaint(
                            painter: UniqueAwardsMedalPainter(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Move Goal 200%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF636366),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Fitness+ Card Widget — Rich full-width banner matching iOS Fitness app screenshot (Light Mode)
  Widget _buildFitnessPlusCard(Color cardBg, Color activeColor) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Opening Fitness+...'),
            backgroundColor: activeColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient simulating gym/workout scene
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3A1C1C), // Deep warm brown
                      Color(0xFF5C2B2B), // Warm burgundy
                      Color(0xFF2E1A1A), // Dark shadow
                    ],
                  ),
                ),
              ),
              // Decorative silhouette figures (light columns suggesting gym background)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 160,
                child: CustomPaint(
                  painter: _GymBackgroundPainter(),
                ),
              ),
              // Bottom gradient fade for text readability
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 140,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xCC1A0A0A),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Top-left: Apple Fitness+ branding
              Positioned(
                top: 16,
                left: 16,
                child: Row(
                  children: const [
                    Icon(Icons.apple, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Fitness+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Top-right: Chevron arrow
              Positioned(
                top: 16,
                right: 16,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF9EFF00),
                  size: 22,
                ),
              ),
              // Bottom-left: Content labels
              Positioned(
                bottom: 40,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "FREE MONTHLY SAMPLER" badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FREE MONTHLY SAMPLER',
                        style: TextStyle(
                          color: Color(0xFF9EFF00),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Strength with Gregg',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '10min · Upbeat Anthems',
                      style: TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Page indicator dots
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == 0 ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == 0 ? Colors.white : Colors.white.withAlpha(80),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Trends Card Widget — iOS Fitness-style onboarding with walking figure & Get Started CTA (Light Mode)
  Widget _buildTrendsCard(Color cardBg) {
    const Color activeGreen = Color(0xFF38D430);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(context, '/trends');
        if (result is int) {
          setState(() {
            _currentTabIndex = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header row: "Trends" + chevron
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trends',
                  style: TextStyle(
                    color: darkSlateText,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8E8E93),
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Trend arrow icon (upward, pink/red circle)
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                  shape: BoxShape.circle,
                  border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: Color(0xFFFF2D55),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Walking figure illustration
            Center(
              child: SizedBox(
                width: 72,
                height: 72,
                child: CustomPaint(
                  painter: _WalkingFigurePainter(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Descriptive text
            Text(
              'Closing your rings every day is a great way to stay active. Trend arrows help you stay motivated by showing even more details.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: darkSlateText,
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            // Get Started link
            GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, '/trends');
                if (result is int) setState(() => _currentTabIndex = result);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: activeGreen,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Trend Item Grid Element Helper
  // ignore: unused_element
  Widget _buildTrendItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF636366),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Trainer Tips Card Widget — full width with descriptive content (Light Mode)
  Widget _buildTrainerTipsRow(Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trainer Tips',
                style: TextStyle(
                  color: darkSlateText,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8E8E93),
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Great phrases for your next workout',
            style: TextStyle(
              color: Color(0xFF3C3C43),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Motivation is what gets you started. Habit is what keeps you going. Use these trainer-approved phrases to stay on track.',
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // Large custom-styled iOS pill button
  Widget _buildActionPillButton({
    required String label,
    required VoidCallback onPressed,
    required Color cardBg,
    required Color accentColor,
  }) {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cardBg,
          foregroundColor: accentColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
            side: const BorderSide(color: Color(0xFF2C2C2E), width: 1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accentColor,
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Pixel-perfect premium "Welcome to Fitness+" Cupertino onboarding Modal matching the screenshot
  void _showWelcomeToFitnessPlusModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF151517), // Apple standard pure dark gray background for modal sheets
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          height: MediaQuery.of(context).size.height * 0.90, // Covers 90% screen height matching the screenshot
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              
              // 1. Header Title: Welcome to Fitness+
              const Text(
                'Welcome to Fitness+',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 36),

              // 2. Feature Items Scrollable List
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Feature 1: Workouts for Everyone
                      _buildFitnessPlusFeatureRow(
                        iconWidget: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF9EFF00), // Vibrant neon green
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_run_rounded,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                        title: 'Workouts for Everyone',
                        description: 'Twelve different types from HIIT to Yoga.',
                      ),
                      const SizedBox(height: 28),

                      // Feature 2: Guided Meditations
                      _buildFitnessPlusFeatureRow(
                        iconWidget: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Center(
                            child: Icon(
                              Icons.spa_rounded,
                              color: Color(0xFF9EFF00), // Vibrant neon green sprout
                              size: 32,
                            ),
                          ),
                        ),
                        title: 'Guided Meditations',
                        description: 'Practise mindfulness in as little as five minutes',
                      ),
                      const SizedBox(height: 28),

                      // Feature 3: Programmes, Custom Plans and More
                      _buildFitnessPlusFeatureRow(
                        iconWidget: SizedBox(
                          width: 36,
                          height: 36,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Back card layer
                              Positioned(
                                top: 4,
                                child: Container(
                                  width: 26,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9EFF00).withAlpha(120),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              // Middle card layer
                              Positioned(
                                top: 2,
                                child: Container(
                                  width: 30,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9EFF00).withAlpha(180),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              // Front card with play button
                              Container(
                                width: 34,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9EFF00),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: 'Programmes, Custom Plans and More',
                        description: 'Find the right workouts and meditations for you. Set up a routine and go after your goals.',
                      ),
                      
                      const SizedBox(height: 48),

                      // Privacy Footer Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.people_alt_rounded,
                            color: Color(0xFF9EFF00),
                            size: 26,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Color(0xFFA2A2A7), // Muted grey
                                  fontSize: 12.5,
                                  height: 1.45,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'When you explore the Apple Fitness+ service prior to subscribing, Apple may use your browsing activity in the Fitness+ tab to improve the service. Once you subscribe, your browsing and workout data is associated with a random identifier. Your account, subscription status and workouts may be used to send you notifications. ',
                                  ),
                                  TextSpan(
                                    text: 'See how your data is managed...',
                                    style: TextStyle(
                                      color: Color(0xFF9EFF00),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // 3. Continue Pill Button at bottom
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Dismiss modal
                    setState(() {
                      _currentTabIndex = 1; // Open Fitness+ tab
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9EFF00), // Vibrant neon green matching the Continue button
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
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
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // Feature Row Item Builder helper
  Widget _buildFitnessPlusFeatureRow({
    required Widget iconWidget,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Center(child: iconWidget),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Color(0xFFA2A2A7), // Apple light gray secondary label
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

  // High-fidelity Plan Completion Cupertino Modal
  // ignore: unused_element
  void _showCustomPlanCompletionModal(BuildContext context, Color limeGreen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white, // Dynamic background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          height: MediaQuery.of(context).size.height * 0.90, // Covers 90% screen height nicely
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Drag Handle mockup
              Center(
                child: Container(
                  width: 38,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7C7CC),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // 1. Glossy award badge graphic container
              Expanded(
                child: Center(
                  child: _buildGlossyAwardBadge(),
                ),
              ),
              const SizedBox(height: 28),

              // 2. Header Text
              Text(
                'You completed your custom plan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkSlateText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'January 1, 2001',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),

              const Divider(color: Color(0xFF2C2C2E), height: 1, thickness: 1),
              const SizedBox(height: 24),

              // 3. Grid of metrics (2 Columns x 2 Rows)
              Row(
                children: [
                  Expanded(
                    child: _buildModalMetricItem(
                      label: 'Total Workout Time',
                      value: '3:25:45',
                      valueColor: const Color(0xFFFF9500), // Apple premium Orange
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModalMetricItem(
                      label: 'Total Active Calories',
                      value: '9,283CAL',
                      valueColor: const Color(0xFFFF2D55), // Move Pink
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildModalMetricItem(
                      label: 'Total Workouts',
                      value: '22',
                      valueColor: limeGreen, // Current limeGreen/activeColor accent
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModalMetricItem(
                      label: 'Total Meditations',
                      value: '2',
                      valueColor: const Color(0xFF5856D6), // Purple
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 4. Action Buttons Stacked
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _hasCompletedPlanBeenShown = true;
                      _currentTabIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: limeGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _hasCompletedPlanBeenShown = true;
                      _currentTabIndex = 1;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Repeating your custom plan!'),
                        backgroundColor: limeGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2C2E),
                    foregroundColor: limeGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    ),
                  ),
                  child: Text(
                    'Repeat Plan',
                    style: TextStyle(
                      color: limeGreen,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Draw stunning concentric metallic Apple Plan Medal
  Widget _buildGlossyAwardBadge() {
    const Color silverBorder = Color(0xFFC0C0C0);
    const Color cyanFill = Color(0x7F4DD0E1); // Glassmorphic translucent cyan

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Metallic Bezel - Horizontal Shape
          Container(
            width: 170,
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0E0E0), Color(0xFF9E9E9E), Color(0xFFF5F5F5), Color(0xFF757575)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // Outer Metallic Bezel - Vertical Shape
          Container(
            width: 140,
            height: 170,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF5F5F5), Color(0xFF757575), Color(0xFFE0E0E0), Color(0xFF9E9E9E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          // Inner Dark Bezel Card Background
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: darkSlateText,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2C2C2E), width: 2),
            ),
          ),
          
          // Concentric overlapping glassmorphic squares
          Stack(
            children: [
              // Square 1: Bottom-Left (underneath)
              Transform.translate(
                offset: const Offset(-12, 12),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cyanFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: silverBorder, width: 2),
                  ),
                ),
              ),
              // Square 2: Top-Right (middle-layer)
              Transform.translate(
                offset: const Offset(12, -12),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cyanFill.withAlpha(140),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                ),
              ),
              // Square 3: Center (top-layer)
              Transform.translate(
                offset: const Offset(0, 0),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cyanFill.withAlpha(200),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to build a metric key-value column inside modal
  Widget _buildModalMetricItem({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF8E8E93),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  // Active composite circular Fitness+ icon in bottom bar
  Widget _buildActiveFitnessPlusIcon(Color activeColor) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: activeColor, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.directions_run_rounded,
            color: activeColor,
            size: 16,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.add,
              color: activeColor,
              size: 7,
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal scrollable categories chip builder (Light Mode Settings Style)
  Widget _buildCategoryPill(String label) {
    final bool isActive = _selectedFitnessPill == label;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFitnessPill = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF00C7BE)
              : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA)), // Fitness+ Teal for active, light grey/dark grey for inactive
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : (isDark ? const Color(0xFF8E8E93) : const Color(0xFF48484A)), // White for active, grey for inactive
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Beautiful layout for active Fitness+ Dashboard Page in premium Light Mode
  Widget _buildFitnessPlusDashboard(Color limeGreen, Color cardBg) {
    return SingleChildScrollView(
      controller: _fitnessScrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 64,
        bottom: 120, // Padding to avoid overlap with floating tabbar
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Brand Title Row with Fitness+ (Dynamic text color!)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1C1C1E),
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Fitness+',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1C1C1E),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Animated switcher for Horizontal Category pills / Expanded search bar
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  child: child,
                ),
              );
            },
            child: !_isFitnessSearchActive
                ? Row(
                    key: const ValueKey('normal_pills_header'),
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildCategoryPill('For You'),
                              const SizedBox(width: 10),
                              _buildCategoryPill('Explore'),
                              const SizedBox(width: 10),
                              _buildCategoryPill('Plans'),
                              const SizedBox(width: 10),
                              _buildCategoryPill('Library'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFitnessSearchActive = true;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2C2C2E)
                                : const Color(0xFFE5E5EA), // Light grey search icon bg
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.search_rounded,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF1C1C1E),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    key: const ValueKey('search_header'),
                    children: [
                      // Grid/Apps button to toggle back to normal mode
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFitnessSearchActive = false;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2C2C2E)
                                : const Color(0xFFE5E5EA), // Light grey bg
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.apps_rounded,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF1C1C1E),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Beautiful search text field container
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF8E8E93),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : const Color(0xFF1C1C1E),
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Workouts, Trainers, Music and...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF8E8E93),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
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
          const SizedBox(height: 24),
          
          // Dynamic dashboard body with fade and slide transition animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.04),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _isFitnessSearchActive
                ? Container(
                    key: const ValueKey('search_dashboard_body'),
                    child: _buildFitnessSearchDashboard(limeGreen, cardBg),
                  )
                : Container(
                    key: ValueKey(_selectedFitnessPill),
                    child: _selectedFitnessPill == 'For You'
                        ? _buildForYouDashboard()
                        : _selectedFitnessPill == 'Plans'
                            ? _buildPlansDashboard()
                            : _selectedFitnessPill == 'Library'
                                ? _buildLibraryDashboard()
                                : _buildExploreDashboard(limeGreen, cardBg),
                  ),
          ),
        ],
      ),
    );
  }

  // Beautiful Plans Dashboard in Light Mode matching the screenshot
  Widget _buildPlansDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Made For You Section ──
        Text(
          'Made For You',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pre-built plans to keep your momentum or push your routine. Edit the plans to perfection before starting.',
          style: TextStyle(
            color: Color(0xFF636366),
            fontSize: 14.5,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 16),
        
        // "Get Started" Card
        _buildGetStartedCard(),
        
        const SizedBox(height: 32),

        // ── 2. Build Your Own Section ──
        Text(
          'Build Your Own',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose the activities and set your schedule.',
          style: TextStyle(
            color: Color(0xFF636366),
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 16),
        
        // "Build Your Own" Custom Plan Card
        _buildBuildYourOwnCard(),
        const SizedBox(height: 24),
      ],
    );
  }

  // Elegant settings-style Library Dashboard in premium Light Mode
  Widget _buildLibraryDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Settings Card grouping the options
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                _buildLibraryRowItem(
                  icon: Icons.directions_run_rounded,
                  label: 'Workouts',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Workouts Library...'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF00C7BE),
                      ),
                    );
                  },
                ),
                _buildLibraryRowItem(
                  icon: Icons.self_improvement_rounded,
                  label: 'Meditations',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Meditations Library...'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF00C7BE),
                      ),
                    );
                  },
                ),
                _buildLibraryRowItem(
                  icon: Icons.login_rounded,
                  label: 'Programs',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Programs Library...'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF00C7BE),
                      ),
                    );
                  },
                ),
                _buildLibraryRowItem(
                  icon: Icons.video_collection_rounded,
                  label: 'Collections',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Collections Library...'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF00C7BE),
                      ),
                    );
                  },
                ),
                _buildLibraryRowItem(
                  icon: Icons.layers_rounded,
                  label: 'Stacks',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Stacks Library...'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF00C7BE),
                      ),
                    );
                  },
                ),
                _buildLibraryRowItem(
                  icon: Icons.cloud_download_rounded,
                  label: 'Downloaded',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Downloaded Items...'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF00C7BE),
                      ),
                    );
                  },
                  showDivider: false, // No divider on the last item
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 48),

        // Centered Empty State for Recently Added items
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular grey clock icon matching premium iOS layout
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
                shape: BoxShape.circle,
                border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1.5) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.access_time_rounded,
                  color: Color(0xFF8E8E93),
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Your Recently Added',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkSlateText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Recently added items will show up\nin your Library.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 14.5,
                height: 1.35,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Premium list item row builder representing a settings-like dashboard row
  Widget _buildLibraryRowItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Soft teal circular icon background container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C7BE).withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF00C7BE),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Item label
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: darkSlateText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Trailing 0 indicator and chevron
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '0',
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFC7C7CC),
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 64, right: 16),
              child: Divider(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
                height: 1,
                thickness: 0.8,
              ),
            ),
        ],
      ),
    );
  }

  // Premium iOS Light Mode Search Dashboard with Category slider and Discover grid
  Widget _buildFitnessSearchDashboard(Color limeGreen, Color cardBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 1. Activity Types Section ──
        Text(
          'Activity Types',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=150&q=80',
                label: 'Meditation',
              ),
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=150&q=80',
                label: 'Strength',
              ),
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=150&q=80',
                label: 'Yoga',
              ),
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=150&q=80',
                label: 'Core',
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ── 2. Discover Section ──
        Text(
          'Discover',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.5,
          children: [
            _buildDiscoverCard(
              label: 'Free Monthly Sampler',
              colors: const [
                Color(0xFFFFB300), // Rich Gold
                Color(0xFFD84315), // Deep Sunset Orange
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Free Monthly Sampler...'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF00C7BE),
                  ),
                );
              },
            ),
            _buildDiscoverCard(
              label: 'Build a Yoga Habit',
              colors: const [
                Color(0xFFFF5252), // Coral Red
                Color(0xFFC62828), // Crimson Red
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Build a Yoga Habit...'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF00C7BE),
                  ),
                );
              },
            ),
            _buildDiscoverCard(
              label: 'Get Your Abs in Great Shape',
              colors: const [
                Color(0xFFEC407A), // Hot Pink
                Color(0xFF9C27B0), // Vivid Purple
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Abs workouts...'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF00C7BE),
                  ),
                );
              },
            ),
            _buildDiscoverCard(
              label: 'Run Your First 5K',
              colors: const [
                Color(0xFF7E57C2), // Bright Violet
                Color(0xFF4527A0), // Deep Indigo
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening First 5K Plan...'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF00C7BE),
                  ),
                );
              },
            ),
            _buildDiscoverCard(
              label: 'Restart Your Fitness',
              colors: const [
                Color(0xFF42A5F5), // Sky Blue
                Color(0xFF1565C0), // Deep Ocean Blue
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Restart Fitness Plan...'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF00C7BE),
                  ),
                );
              },
            ),
            _buildDiscoverCard(
              label: 'Workouts for Beginners',
              colors: const [
                Color(0xFF26A69A), // Light Teal
                Color(0xFF00695C), // Dark Teal/Green
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Workouts for Beginners...'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF00C7BE),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // Helper card builder for premium colorful linear gradient boxes inside Discover section
  Widget _buildDiscoverCard({
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.last.withAlpha(50),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  // "Get Started" high-fidelity gradient card with a calendar "Plan Preview" button
  Widget _buildGetStartedCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B), // Slate blue
            Color(0xFF475569), // Grey blue
            Color(0xFF8B5CF6), // Violet
            Color(0xFFEC4899), // Pink
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'HIIT, Strength, and Yoga',
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '3 DAYS • 10MIN/DAY',
            style: TextStyle(
              color: Color(0xFF9EFF00), // Vibrant neon green
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Plan Preview Button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Plan Preview...'),
                    backgroundColor: Color(0xFF9EFF00),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withAlpha(25), // Translucent card button
                foregroundColor: const Color(0xFF9EFF00),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                  side: BorderSide(color: Colors.white.withAlpha(15), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFF9EFF00),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Plan Preview',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // "Custom Plan" gold-themed card with a "Build Your Own" button
  Widget _buildBuildYourOwnCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A3E25), // Dark Gold
            Color(0xFF24221E), // Olive Dark Brown
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Custom Plan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your activities, workout length, days of the week, trainers and music.',
            style: TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          
          // Build Your Own Button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Custom Plan Builder...'),
                    backgroundColor: Color(0xFF9EFF00),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withAlpha(25),
                foregroundColor: const Color(0xFF9EFF00),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                  side: BorderSide(color: Colors.white.withAlpha(15), width: 1),
                ),
              ),
              child: const Center(
                child: Text(
                  'Build Your Own',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pixel-perfect "For You" Apple Fitness+ Free Month Promo dashboard (Light Mode)
  Widget _buildForYouDashboard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white, // Dynamic Card Background
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. High-fidelity Grid of Diverse Workout/Athlete Images
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
            child: Column(
              children: [
                // Top Row: 2 Images (Meditation, Squatting)
                Row(
                  children: [
                    Expanded(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=350&q=80',
                        height: 125,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 125,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                          child: const Icon(Icons.spa_rounded, color: Color(0xFF00C7BE)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=350&q=80',
                        height: 125,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 125,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                          child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF00C7BE)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Bottom Row: 3 Images (Running, Lunging, Cycling)
                Row(
                  children: [
                    Expanded(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=250&q=80',
                        height: 105,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 105,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                          child: const Icon(Icons.directions_run_rounded, color: Color(0xFF00C7BE)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1599058917212-d750089bc07e?auto=format&fit=crop&w=250&q=80',
                        height: 105,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 105,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                          child: const Icon(Icons.flash_on_rounded, color: Color(0xFF00C7BE)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1518310383802-640c2de311b2?auto=format&fit=crop&w=250&q=80',
                        height: 105,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 105,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                          child: const Icon(Icons.directions_bike_rounded, color: Color(0xFF00C7BE)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 2. Premium Promotion Text and Actions details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Try 1 Month Free',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkSlateText, // Dark slate text
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Discover new workouts and meditations designed for all levels.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF636366), // Muted secondary gray
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                
                // Neon Green Trial Action Button
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      _showSubscriptionSuccessDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9EFF00), // Vibrant neon green
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: const Text(
                      'Try It Free',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Fine Print details
                const Text(
                  '1 month free, then ₹ 149.00/month.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 28),
                
                // Link to annual subscriptions (Teal Accent Link in Light Mode!)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Annual plan option selected!'),
                        backgroundColor: Color(0xFF00C7BE),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'or Try an Annual Plan and Save',
                        style: TextStyle(
                          color: Color(0xFF00C7BE), // Beautiful clickable teal link
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_circle_right_rounded,
                        color: Color(0xFF00C7BE),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // A premium success modal to celebrate trial subscription activation
  void _showSubscriptionSuccessDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(120),
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white, // Dynamic background for Dialog
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF00C7BE), // Teal color
                    size: 64,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Subscription Activated!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkSlateText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Welcome to Apple Fitness+. You now have unlimited access to all workouts, plans, and meditations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF636366),
                    fontSize: 14.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C7BE), // Teal
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Exercising', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Beautiful Explore Dashboard in Light Mode matching the screenshot
  Widget _buildExploreDashboard(Color limeGreen, Color cardBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Free Monthly Sampler Section ──
        Text(
          'Free Monthly Sampler',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Try these episodes one time—no trial or subscription required.',
          style: TextStyle(
            color: Color(0xFF636366),
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 165,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildExploreSamplerCard(
                imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=350&q=80',
                title: 'Strength with Gregg',
                subtitle: '10min • Upbeat Anthems',
              ),
              _buildExploreSamplerCard(
                imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?auto=format&fit=crop&w=350&q=80',
                title: 'Core with Kyle',
                subtitle: '10min • Hip-Hop/R&B',
              ),
              _buildExploreSamplerCard(
                imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=350&q=80',
                title: 'Yoga with Jon',
                subtitle: '10min • Chill Vibes',
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),

        // ── 2. Activity Types Section ──
        Text(
          'Activity Types',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=150&q=80',
                label: 'Meditation',
              ),
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=150&q=80',
                label: 'Strength',
              ),
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=150&q=80',
                label: 'Yoga',
              ),
              _buildActivityTypeCard(
                imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=150&q=80',
                label: 'Core',
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ── 3. Workouts Section ──
        Text(
          'Workouts',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'New and picked for you',
          style: TextStyle(
            color: Color(0xFF636366),
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 215,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildExploreWorkoutCard(
                imageUrl: 'https://images.unsplash.com/photo-1518310383802-640c2de311b2?auto=format&fit=crop&w=400&q=80',
                title: 'HIIT with Bakari',
                subtitle: '20min • Pure Dance',
              ),
              _buildExploreWorkoutCard(
                imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=400&q=80',
                title: 'Strength with Gregg',
                subtitle: '30min • Latest Hits',
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),

        // ── 4. Meditations Section ──
        Text(
          'Meditations',
          style: TextStyle(
            color: darkSlateText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'New and picked for you',
          style: TextStyle(
            color: Color(0xFF636366),
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildExploreMeditationCard(
                imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=350&q=80',
                title: 'Meditation with Jonelle',
                subtitle: '5min • Breath',
                isNew: true,
              ),
              _buildExploreMeditationCard(
                imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=350&q=80',
                title: 'Meditation with Jessica',
                subtitle: '5min • Awareness',
                isNew: true,
              ),
              _buildExploreMeditationCard(
                imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&w=350&q=80',
                title: 'Meditation with Christian',
                subtitle: '10min • Calm',
                isNew: false,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),

        // ── 5. Custom Plans Section ──
        _buildCustomPlansCard(),
        
        const SizedBox(height: 32),

        // ── 6. Programs Section ──
        _buildProgramsSection(),
      ],
    );
  }

  // Pixel-perfect "Custom Plans" gold-themed premium promotion card
  Widget _buildCustomPlansCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF24221E), // Olive-gold dark background matching screenshot
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Graphic: Gold banner with three circular athletes
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A3E25),
                  Color(0xFF24221E),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stylized gold oval background designs
                Positioned(
                  left: -40,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4AF37).withAlpha(15),
                    ),
                  ),
                ),
                Positioned(
                  right: -40,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4AF37).withAlpha(15),
                    ),
                  ),
                ),
                
                // Three overlapping circular athlete images against gold circles
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCustomPlanAthleteCircle(
                      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=150&q=80',
                      offsetX: 15,
                    ),
                    _buildCustomPlanAthleteCircle(
                      imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?auto=format&fit=crop&w=150&q=80',
                      offsetX: 0,
                      isMiddle: true,
                    ),
                    _buildCustomPlanAthleteCircle(
                      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=150&q=80',
                      offsetX: -15,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom Text and Button section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Custom Plans',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pick your activities and set your schedule to stay motivated week after week. Complete your plan and you’ll earn a special award.',
                  style: TextStyle(
                    color: Color(0xFFC7C7CC), // Soft light grey/gold description text
                    fontSize: 14.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Translucent View All Plans button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening Custom Plans...'),
                          backgroundColor: Color(0xFF9EFF00),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withAlpha(20), // Translucent black background
                      foregroundColor: const Color(0xFF9EFF00), // Vibrant neon green accent
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                        side: BorderSide(color: Colors.white.withAlpha(15), width: 1),
                      ),
                    ),
                    child: const Text(
                      'View All Plans',
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
        ],
      ),
    );
  }

  // Builder helper for the gold circular athlete icons on the Custom Plans banner
  Widget _buildCustomPlanAthleteCircle({
    required String imageUrl,
    required double offsetX,
    bool isMiddle = false,
  }) {
    final double size = isMiddle ? 100 : 85;
    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD4AF37), width: 2.5), // Beautiful gold metallic bezel
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Builder helper for Programs Section (Light Mode)
  Widget _buildProgramsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Programs',
              style: TextStyle(
                color: darkSlateText,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF8E8E93),
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Created to help you improve your fitness, prepare for new adventures, and focus on mindfulness',
          style: TextStyle(
            color: Color(0xFF636366),
            fontSize: 14.5,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildProgramCard(
                imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=400&q=80',
                title: '12 Stretchy\nYoga Flows',
                subtitle: 'for Relaxation',
                cardColor: const Color(0xFF1A1A40), // Dark Navy blue
              ),
              _buildProgramCard(
                imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=400&q=80',
                title: '4 Weeks to\nStrength',
                subtitle: 'Build Muscle and Burn',
                cardColor: const Color(0xFF3E1F1F), // Dark Red/Brown
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Builder helper for individual fade-overlay program cards
  Widget _buildProgramCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    required Color cardColor,
  }) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background athlete overlay on the right with a smooth fade gradient
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 140,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(18)),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      cardColor,
                      Colors.transparent,
                    ],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcOver,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Content text on the left
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builder helper for high-fidelity landscape Meditation cards with dynamic "NEW" overlay badge
  Widget _buildExploreMeditationCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    bool isNew = false,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  imageUrl,
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 125,
                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                    child: const Icon(Icons.spa_rounded, color: Color(0xFF00C7BE)),
                  ),
                ),
              ),
              if (isNew)
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(140), // Translucent dark pill badge matching screenshot
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: darkSlateText,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  // Builder helper for the Free Monthly Sampler item card
  Widget _buildExploreSamplerCard({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 105,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 105,
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF00C7BE)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: darkSlateText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Builder helper for isolated Activity Type cards (matching screenshot)
  Widget _buildActivityTypeCard({
    required String imageUrl,
    required String label,
  }) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                  child: const Icon(Icons.directions_run_rounded, color: Color(0xFF00C7BE)),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2C2C2E), // Cupertino light grey label bar matching the screenshot
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkSlateText,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder helper for high-fidelity large Workout cards
  Widget _buildExploreWorkoutCard({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              height: 135,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 135,
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                child: const Icon(Icons.flash_on_rounded, color: Color(0xFF00C7BE)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: darkSlateText,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Active solid circular Workout icon in bottom bar matching the mockup
  Widget _buildActiveWorkoutIcon(Color activeColor) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activeColor,
      ),
      child: const Center(
        child: Icon(
          Icons.directions_run_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  // Feature row helper for Workouts Page
  Widget _buildWorkoutFeatureRow({
    required Widget icon,
    required String title,
    required String subtext,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkSlateText,
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtext,
                  style: TextStyle(
                    color: Color(0xFF48484A),
                    fontSize: 14.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Workouts on iPhone onboarding screen dashboard matching the screenshot
  Widget _buildWorkoutOnboarding(Color limeGreen, Color cardBg) {
    const Color neonLimeGreen = Color(0xFFA6FF00); // Apple Fitness super vibrant neon lime-green
    const Color charcoalText = Color(0xFF1C1C1E); // Apple Fitness high contrast charcoal text
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 120, // Keep tabbar offset padding in mind
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 56,
                  bottom: 120, // Leave enough space for bottom floating tabbar
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    
                    // Large main bold title (centered)
                    const Text(
                      'Workouts on iPhone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: charcoalText,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Subtitle (centered)
                    const Text(
                      'Record your workouts and close your Move ring.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Features List Rows (exactly 2 features matching the user screenshot)
                    _buildWorkoutFeatureRow(
                      icon: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: neonLimeGreen,
                          boxShadow: [
                            BoxShadow(
                              color: neonLimeGreen.withAlpha(60),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_run_rounded,
                            color: charcoalText,
                            size: 26,
                          ),
                        ),
                      ),
                      title: 'Track Your Data',
                      subtext: 'See metrics like your distance and pace, or connect a device with a heart rate sensor to unlock more workout types and data.',
                    ),
                    const SizedBox(height: 8),
                    _buildWorkoutFeatureRow(
                      icon: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: neonLimeGreen,
                          boxShadow: [
                            BoxShadow(
                              color: neonLimeGreen.withAlpha(60),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.music_note_rounded,
                            color: charcoalText,
                            size: 24,
                          ),
                        ),
                      ),
                      title: 'Music and Media',
                      subtext: 'During your workouts, automatically play your favourite music, podcasts or recommended songs based on your listening history.',
                    ),
                    
                    const Spacer(),
                    const SizedBox(height: 36),

                    // Centered Footnote / Disclaimer text
                    const Text(
                      "While you're recording a workout, the Fitness app will have access to your HealthKit data when your iPhone is locked. You can manage Lock Screen in Settings.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // "Continue" pill-shaped neon button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _workoutSubPage = 1; // Transition to Workout Buddy
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: neonLimeGreen,
                          foregroundColor: charcoalText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          shadowColor: neonLimeGreen.withAlpha(40),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Workout Buddy feature detail screen matching the new mockup
  Widget _buildWorkoutBuddyScreen(Color limeGreen, Color cardBg) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white, // Dynamic background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Row with Back Button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _workoutSubPage = 0; // Go back to Workouts onboarding
                                  });
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(12),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: limeGreen,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          // Main Title
                          Text(
                            'Workout Buddy',
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Description Text
                          Text(
                            'Workout Buddy helps you stay motivated with generative audio built with voice data from Fitness+ trainers. Get encouragement during your workout with a pep talk to kick things off, highlights along the way, and a summary.',
                            style: TextStyle(
                              color: isDark ? const Color(0xFFE5E5EA) : const Color(0xFF48484A),
                              fontSize: 19.5,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                      
                      // Bottom Section: Footnotes and OK button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                          // Footnote 1
                          Text(
                            'You can turn on Workout Buddy for each available workout type. AirPods or other wireless headphones must be connected to use Workout Buddy.',
                            style: TextStyle(
                              color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF636366),
                              fontSize: 13.5,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Footnote 2
                          Text(
                            'Announcements from Workout Buddy may occasionally contain unexpected results.',
                            style: TextStyle(
                              color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF636366),
                              fontSize: 13.5,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Apple Privacy Link
                          GestureDetector(
                            onTap: () {
                              _showPrivacyDialog(context, limeGreen);
                            },
                            child: Text(
                              'About Apple Intelligence & Privacy...',
                              style: TextStyle(
                                color: limeGreen,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 44),
                          
                          // Large premium "OK" pill button
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                    _workoutSubPage = 2; // Transition to Workout Dashboard
                                });
                                
                                // Show premium iOS-styled floating notification pill SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.only(bottom: 120, left: 24, right: 24),
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
                                        width: 1,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                    content: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            color: limeGreen, // limeGreen
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Workouts setup complete!',
                                            style: TextStyle(
                                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: limeGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(29),
                                ),
                              ),
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        return Image.network(
          user.photoURL!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackInitials(user.displayName ?? user.email ?? 'U');
          },
        );
      } else {
        return _buildFallbackInitials(user.displayName ?? user.email ?? 'U');
      }
    }
    
    final mockUser = GoogleMockPage.selectedAccount;
    if (mockUser != null) {
      final initial = mockUser['initial'] ?? 'U';
      final colorStr = mockUser['color'] ?? '0xFF3A5BDB';
      Color avatarColor;
      try {
        avatarColor = Color(int.parse(colorStr));
      } catch (_) {
        avatarColor = const Color(0xFF3A5BDB);
      }
      return Container(
        color: avatarColor,
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    
    return Container(
      color: const Color(0xFF3A5BDB),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackInitials(String nameOrEmail) {
    final String initial = nameOrEmail.isNotEmpty ? nameOrEmail[0].toUpperCase() : 'U';
    return Container(
      color: const Color(0xFF3A5BDB),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLargeFallbackAvatar(String nameOrEmail) {
    final String initial = nameOrEmail.isNotEmpty ? nameOrEmail[0].toUpperCase() : 'U';
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF3A5BDB),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Display a premium iOS-style Account Settings bottom sheet
  void _showAccountBottomSheet(BuildContext context) {
    const Color exerciseGreen = Color(0xFF38D430); // Workout exercise green
    final user = FirebaseAuth.instance.currentUser;
    final mockUser = GoogleMockPage.selectedAccount;
    
    String displayName = 'Gokul Santh';
    String email = 'gokulsanth@gmail.com';
    Widget avatarWidget;
    
    if (user != null) {
      displayName = user.displayName ?? (user.email != null ? user.email!.split('@')[0] : 'User');
      email = user.email ?? 'No email';
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        avatarWidget = ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            user.photoURL!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildLargeFallbackAvatar(displayName),
          ),
        );
      } else {
        avatarWidget = _buildLargeFallbackAvatar(displayName);
      }
    } else if (mockUser != null) {
      displayName = mockUser['name'] ?? 'Mock User';
      email = mockUser['email'] ?? 'mock@healthcare.org';
      final initial = mockUser['initial'] ?? 'U';
      final colorStr = mockUser['color'] ?? '0xFF3A5BDB';
      Color avatarColor;
      try {
        avatarColor = Color(int.parse(colorStr));
      } catch (_) {
        avatarColor = const Color(0xFF3A5BDB);
      }
      avatarWidget = Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: avatarColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      avatarWidget = _buildLargeFallbackAvatar(displayName);
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // to support rounded top corners via container decoration
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2E), // Apple's standard light grey settings background
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Slide down indicator drag bar
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFC7C7CC),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 16),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 44), // Spacer to balance close button
                    Text(
                      'Account',
                      style: TextStyle(
                        color: darkSlateText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(sheetContext),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C2C2E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF48484A),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // List Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // User Profile Section
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          avatarWidget,
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Group 1
                    _buildSettingsGroup([
                      _buildSettingsItem(
                        title: 'Notifications',
                        hasChevron: true,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          Navigator.pushNamed(context, '/fitness-notifications').then((_) {
                            if (context.mounted) {
                              _showAccountBottomSheet(context);
                            }
                          });
                        },
                      ),
                      _buildSettingsItem(
                        title: 'Health Details',
                        hasChevron: true,
                        onTap: () {
                          _showHealthDetailsDialog(context);
                        },
                      ),
                      _buildSettingsItem(
                        title: 'Change Move Goal',
                        hasChevron: true,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          Navigator.pushNamed(context, '/daily-move-goal').then((_) {
                            if (context.mounted) {
                              _showAccountBottomSheet(context);
                            }
                          });
                        },
                      ),
                      _buildSettingsItem(
                        title: 'Units of Measure',
                        hasChevron: true,
                        onTap: () {
                          _showUnitsOfMeasureDialog(context);
                        },
                      ),
                      _buildSettingsItem(
                        title: 'Privacy',
                        hasChevron: true,
                        onTap: () {
                          _showPrivacyDialog(context, exerciseGreen);
                        },
                      ),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    // Group 2
                    _buildSettingsGroup([
                      _buildSettingsItem(
                        title: 'Workout',
                        titleColor: exerciseGreen,
                        hasChevron: false,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          setState(() {
                            _currentTabIndex = 2; // Workouts
                            _workoutSubPage = 2;  // Dashboard
                          });
                        },
                      ),
                      _buildSettingsItem(
                        title: 'Fitness+',
                        titleColor: exerciseGreen,
                        hasChevron: false,
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _showWelcomeToFitnessPlusModal(context);
                        },
                      ),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    // Group 3
                    _buildSettingsGroup([
                      _buildSettingsItem(
                        title: 'Redeem Gift Card or Code',
                        titleColor: exerciseGreen,
                        hasChevron: false,
                        onTap: () {
                          _showGiftCardDialog(context, 'Redeem Gift Card');
                        },
                      ),
                      _buildSettingsItem(
                        title: 'Send Gift Card by Email',
                        titleColor: exerciseGreen,
                        hasChevron: false,
                        onTap: () {
                          _showGiftCardDialog(context, 'Send Gift Card');
                        },
                      ),
                    ]),
                    
                    const SizedBox(height: 20),
                    
                    // Group 4 (Sign Out)
                    _buildSettingsGroup([
                      _buildSettingsItem(
                        title: 'Sign Out',
                        titleColor: Colors.redAccent,
                        hasChevron: false,
                        onTap: () async {
                          Navigator.pop(sheetContext);
                          // Sign out from FirebaseAuth
                          await FirebaseAuth.instance.signOut();
                          // Sign out from GoogleSignIn
                          try {
                            await GoogleSignIn.instance.signOut();
                          } catch (_) {}
                          // Clear mock selection
                          GoogleMockPage.selectedAccount = null;
                          
                          // Navigate back to Login Page
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ]),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2C2C2E), width: 0.5),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          if (index == items.length - 1) {
            return items[index];
          }
          return Column(
            children: [
              items[index],
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Divider(
                  color: Color(0xFF2C2C2E),
                  height: 0.5,
                  thickness: 0.5,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    Color? titleColor,
    required bool hasChevron,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor ?? Colors.white,
                fontSize: 16,
                fontWeight: titleColor != null ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (hasChevron)
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF8E8E93),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showHealthDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(80),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Health Details',
          style: TextStyle(
            color: darkSlateText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Age', '25 years'),
            _buildDetailRow('Weight', '68 kg'),
            _buildDetailRow('Height', '174 cm'),
            _buildDetailRow('Sex', 'Female'),
            _buildDetailRow('Blood Type', 'O+'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFF38D430),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF636366),
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: darkSlateText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showUnitsOfMeasureDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(80),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Units of Measure',
          style: TextStyle(
            color: darkSlateText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUnitRow('Energy', 'Calories (kcal)'),
            _buildUnitRow('Pool Length', 'Meters'),
            _buildUnitRow('Cycling Work', 'Kilojoules (kJ)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFF38D430),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitRow(String label, String currentUnit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Color(0xFF636366), fontSize: 15),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              currentUnit,
              style: TextStyle(
                color: darkSlateText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGiftCardDialog(BuildContext context, String actionTitle) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(80),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          actionTitle,
          style: TextStyle(
            color: darkSlateText,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your code or details below to proceed.',
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: actionTitle.contains('Redeem') ? 'X-XXXX-XXXX-XXXX' : 'Recipient Email',
                hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                fillColor: const Color(0xFF2C2C2E),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF8E8E93)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    actionTitle.contains('Redeem')
                        ? 'Gift Card redeemed successfully!'
                        : 'Gift Card details sent successfully!',
                  ),
                  backgroundColor: const Color(0xFF38D430),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Color(0xFF38D430),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display a premium Apple Intelligence & Privacy details modal dialog
  void _showPrivacyDialog(BuildContext context, Color limeGreen) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Workout Buddy & Privacy',
                style: TextStyle(
                  color: darkSlateText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Workout Buddy utilizes advanced on-device generative models to synthesize training pep-talks. Your personal audio preferences and voice parameters remain securely stored on your device and are never shared without your permission.',
                style: TextStyle(
                  color: Color(0xFFE5E5EA),
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: limeGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Dismiss',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Beautiful layout for the Workout Dashboard
  Widget _buildWorkoutDashboard(Color limeGreen, Color cardBg) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      controller: _workoutScrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 64,
        bottom: 120, // Padding to avoid overlap with floating tabbar
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: "Workout" and two top-right circular buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Workout',
                style: TextStyle(
                  color: darkSlateText,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.8,
                ),
              ),
              Row(
                children: [
                  // Circular Edit Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Edit Workout Mode Active'),
                          backgroundColor: limeGreen,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                        shape: BoxShape.circle,
                        border: isDark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit_outlined,
                          color: isDark ? Colors.white : const Color(0xFF48484A),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Circular Heart Disconnect Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Apple Watch connection status'),
                          backgroundColor: Colors.white24,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                        shape: BoxShape.circle,
                        border: isDark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              color: limeGreen,
                              size: 20,
                            ),
                            Transform.rotate(
                              angle: -0.5,
                              child: Container(
                                width: 2,
                                height: 22,
                                color: isDark ? const Color(0xFF2C2C2E) : Colors.white, // Match background circle to create slash effect
                              ),
                            ),
                            Transform.rotate(
                              angle: -0.5,
                              child: Container(
                                width: 1,
                                height: 22,
                                color: const Color(0xFF8E8E93),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 1. Connection Banner (Dismissible)
          if (_showWatchBanner) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lime Green Circle with heart
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: limeGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To track other workout types, connect Apple Watch, AirPods with heart rate detection, or a device with a heart rate sensor.',
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF48484A),
                            fontSize: 14.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dismiss Close Circle Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showWatchBanner = false;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C2C2E),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close_rounded,
                          color: Color(0xFF8E8E93),
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 2. Fake Training App Card - Beautifully styled purple design
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF120822) : const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? const Color(0xFF3B1E6D) : const Color(0xFFD8B4FE), 
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Swirl Icon
                    Icon(
                      Icons.cyclone,
                      color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF7C3AED), // Neon blue in dark, deep purple in light
                      size: 40,
                    ),
                    // Circle Watch Outline
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF3B1E6D) : const Color(0xFFD8B4FE), 
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.watch_rounded,
                          color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Fake Training App',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF581C87), // Bold white in dark mode
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.directions_bike_rounded,
                      color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Sprint Session',
                      style: TextStyle(
                        color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // "View Schedule" Full Width Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: true,
                          pageBuilder: (ctx, anim, secAnim) => const FakeTrainingAppPage(),
                          transitionsBuilder: (ctx, anim, secAnim, child) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeIn,
                              ),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF24163F) : const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      'View Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Outdoor Walk Card
          _buildWorkoutCard(
            sportIcon: Icons.directions_walk_rounded,
            title: 'Outdoor Walk',
            limeGreen: limeGreen,
            onPlayPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (ctx, anim, secAnim) => WorkoutCountdownPage(
                    workoutName: 'Outdoor Walk',
                    workoutIcon: Icons.directions_walk_rounded,
                    accentColor: limeGreen,
                  ),
                  transitionsBuilder: (ctx, anim, secAnim, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 350),
                ),
              ).then((started) {
                if (started == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Outdoor Walk started! 🚶'),
                      backgroundColor: limeGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
            },
            onMutePressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout Buddy speech muted for Outdoor Walk'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onTimerPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stopwatch opened for Outdoor Walk'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // 4. Outdoor Run Card
          _buildWorkoutCard(
            sportIcon: Icons.directions_run_rounded,
            title: 'Outdoor Run',
            limeGreen: limeGreen,
            onPlayPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (ctx, anim, secAnim) => WorkoutCountdownPage(
                    workoutName: 'Outdoor Run',
                    workoutIcon: Icons.directions_run_rounded,
                    accentColor: limeGreen,
                  ),
                  transitionsBuilder: (ctx, anim, secAnim, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 350),
                ),
              ).then((started) {
                if (started == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Outdoor Run started! 🏃'),
                      backgroundColor: limeGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
            },
            onMutePressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout Buddy speech muted for Outdoor Run'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onTimerPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stopwatch opened for Outdoor Run'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // 5. Outdoor Cycle Card
          _buildWorkoutCard(
            sportIcon: Icons.directions_bike_rounded,
            title: 'Outdoor Cycle',
            limeGreen: limeGreen,
            onPlayPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (ctx, anim, secAnim) => WorkoutCountdownPage(
                    workoutName: 'Outdoor Cycle',
                    workoutIcon: Icons.directions_bike_rounded,
                    accentColor: limeGreen,
                  ),
                  transitionsBuilder: (ctx, anim, secAnim, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 350),
                ),
              ).then((started) {
                if (started == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Outdoor Cycle started! 🚴‍♂️'),
                      backgroundColor: limeGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
            },
            onMutePressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout Buddy speech muted for Outdoor Cycle'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onTimerPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stopwatch opened for Outdoor Cycle'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // 6. Hiking Card
          _buildWorkoutCard(
            sportIcon: Icons.hiking_rounded,
            title: 'Hiking',
            limeGreen: limeGreen,
            onPlayPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (ctx, anim, secAnim) => WorkoutCountdownPage(
                    workoutName: 'Hiking',
                    workoutIcon: Icons.hiking_rounded,
                    accentColor: limeGreen,
                  ),
                  transitionsBuilder: (ctx, anim, secAnim, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeIn,
                      ),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 350),
                ),
              ).then((started) {
                if (started == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Hiking started! 🥾'),
                      backgroundColor: limeGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
            },
            onMutePressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout Buddy speech muted for Hiking'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onTimerPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stopwatch opened for Hiking'),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 28),

          // ── Fitness+ Free Sampler Section ──
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top: centered green + add button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 4),
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Added Fitness+ to Workout'),
                            backgroundColor: limeGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: limeGreen.withAlpha(100),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: limeGreen.withAlpha(40),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            color: limeGreen,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Header Row: Apple Fitness+ title + more button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🍎 Fitness+ title
                      Row(
                        children: [
                          Icon(
                            Icons.apple,
                            color: darkSlateText,
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Fitness+',
                            style: TextStyle(
                              color: darkSlateText,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      // Three-dot more button (dark circle with green dots)
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Fitness+ options'),
                              backgroundColor: limeGreen,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (i) => Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                decoration: BoxDecoration(
                                  color: limeGreen,
                                  shape: BoxShape.circle,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Subtitle
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 16),
                  child: Text(
                    'Free Sampler',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Horizontal scrollable workout sample cards
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildFitnessSampleCard(
                        limeGreen: limeGreen,
                        label: 'HIIT',
                        duration: '20 min',
                      ),
                      const SizedBox(width: 12),
                      _buildFitnessSampleCard(
                        limeGreen: limeGreen,
                        label: 'Yoga',
                        duration: '15 min',
                      ),
                      const SizedBox(width: 12),
                      _buildFitnessSampleCard(
                        limeGreen: limeGreen,
                        label: 'Core',
                        duration: '10 min',
                      ),
                      const SizedBox(width: 12),
                      _buildFitnessSampleCard(
                        limeGreen: limeGreen,
                        label: 'Dance',
                        duration: '25 min',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: small fitness sample card for the Free Sampler row
  Widget _buildFitnessSampleCard({
    required Color limeGreen,
    required String label,
    required String duration,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label - $duration class starting...'),
            backgroundColor: limeGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2C2C2E), width: 1),
        ),
        child: Stack(
          children: [
            // Green left accent strip
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  color: limeGreen,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                ),
              ),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 12, top: 14, bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    duration,
                    style: TextStyle(
                      color: limeGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.play_circle_filled_rounded, color: limeGreen, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'Free',
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build standard Olive-colored sport card widget re-themed to Light Theme
  Widget _buildWorkoutCard({
    required IconData sportIcon,
    required String title,
    required Color limeGreen,
    required VoidCallback onPlayPressed,
    required VoidCallback onMutePressed,
    required VoidCallback onTimerPressed,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0E1A04) : Colors.white, // Olive-black in dark mode, white in light mode
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: const Color(0xFF1F380A), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sport Icon
              Icon(
                sportIcon,
                color: limeGreen,
                size: 44,
              ),
              // Play Badge
              GestureDetector(
                onTap: onPlayPressed,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: limeGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: limeGreen.withAlpha(80),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: isDark ? Colors.black : Colors.white, // Black play arrow in dark mode, white in light mode
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : darkSlateText,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Left action button (Mute voice)
              Expanded(
                child: GestureDetector(
                  onTap: onMutePressed,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F3C0F) : const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.speaker_notes_off_rounded,
                        color: isDark ? Colors.white : const Color(0xFF48484A),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Right action button (Stopwatch)
              Expanded(
                child: GestureDetector(
                  onTap: onTimerPressed,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F3C0F) : const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.timer_outlined,
                        color: isDark ? Colors.white : const Color(0xFF48484A),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SHARING TAB INTEGRATION ---
  Widget _buildSharingDashboard(Color sharingPurple, Color cardBg) {
    const Color darkCardBg = Color(0xFF1C1C1E); // Apple dark card background
    const Color goldPointsColor = Color(0xFFE5C158); // Gold/Bronze points text color
    const Color goldSubPointsColor = Color(0xFFB39250); // Muted gold today points text color
    const Color greyText = Color(0xFF8E8E93); // Apple grey text

    return SingleChildScrollView(
      controller: _sharingScrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 64, // Keep top bleed status bar space
        bottom: 120, // Avoid bottom floating tab bar overlap
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Row: "Sharing" Title and Right Circular "Add Friend" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sharing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.8,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showInviteFriendBottomSheet(context, sharingPurple);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2E), // Dark grey button background
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // 2. Competitions Section Header
          const Text(
            'Competitions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // 3. Competitions Cards List
          _buildCompetitionCard(
            friendName: 'Jane',
            friendPoints: '1,030PTS',
            friendToday: '10 Today',
            mePoints: '1,161PTS',
            meToday: '41 Today',
            bottomText: 'Ends Today',
            darkCardBg: darkCardBg,
            goldPointsColor: goldPointsColor,
            goldSubPointsColor: goldSubPointsColor,
            greyText: greyText,
          ),
          _buildCompetitionCard(
            friendName: 'Doug',
            friendPoints: '910PTS',
            friendToday: '100 Today',
            mePoints: '500PTS',
            meToday: '80 Today',
            bottomText: '4 Days Left',
            darkCardBg: darkCardBg,
            goldPointsColor: goldPointsColor,
            goldSubPointsColor: goldSubPointsColor,
            greyText: greyText,
          ),
          _buildCompetitionCard(
            friendName: 'Allen',
            friendPoints: '325PTS',
            friendToday: '110 Today',
            mePoints: '420PTS',
            meToday: '70 Today',
            bottomText: '5 Days Left',
            darkCardBg: darkCardBg,
            goldPointsColor: goldPointsColor,
            goldSubPointsColor: goldSubPointsColor,
            greyText: greyText,
          ),
          _buildCompetitionCard(
            friendName: 'Emily',
            friendPoints: '7PTS',
            friendToday: '',
            mePoints: '24PTS',
            meToday: '',
            bottomText: '7 Days Left',
            darkCardBg: darkCardBg,
            goldPointsColor: goldPointsColor,
            goldSubPointsColor: goldSubPointsColor,
            greyText: greyText,
          ),
          const SizedBox(height: 28),

          // 4. Highlights Section Header
          const Text(
            'Highlights',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // 5. Highlights Horizontal ListView
          SizedBox(
            height: 330,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHighlightCard(
                  name: 'Jane finished a workout',
                  time: '7m ago',
                  accentColor: const Color(0xFFFFD600), // Apple Walk/Run Yellow
                  innerIcon: Icons.directions_walk_rounded,
                  valueText: '0:30',
                  labelText: 'Outdoor Walk',
                  darkCardBg: darkCardBg,
                  greyText: greyText,
                ),
                const SizedBox(width: 14),
                _buildHighlightCard(
                  name: 'Allen earned an award',
                  time: 'today',
                  accentColor: const Color(0xFFFFC04D), // Warm Amber Gold
                  innerIcon: Icons.workspace_premium_rounded,
                  valueText: 'Perfect Week',
                  labelText: 'Activity',
                  darkCardBg: darkCardBg,
                  greyText: greyText,
                ),
                const SizedBox(width: 14),
                _buildHighlightCard(
                  name: 'Doug completed a workout',
                  time: '2h ago',
                  accentColor: const Color(0xFF38D430), // Exercise Green
                  innerIcon: Icons.directions_run_rounded,
                  valueText: '0:45',
                  labelText: 'Outdoor Run',
                  darkCardBg: darkCardBg,
                  greyText: greyText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 6. Activity Rings Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activity Rings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Color(0xFFA6FF00),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.unfold_more_rounded,
                    color: Color(0xFFA6FF00),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'TODAY, 16 JUNE 2026',
            style: TextStyle(
              color: greyText,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),

          // 7. Activity Rings Cards List
          _buildActivityRingCardItem(
            name: 'Allen',
            percentage: '108%',
            fraction: '923/850CAL',
            moveProgress: 1.08,
            exerciseProgress: 0.85,
            standProgress: 0.70,
          ),
          _buildActivityRingCardItem(
            name: 'Doug',
            percentage: '101%',
            fraction: '122/120MIN',
            moveProgress: 0.88,
            exerciseProgress: 1.01,
            standProgress: 0.90,
          ),
          _buildActivityRingCardItem(
            name: 'Emily',
            percentage: '40%',
            fraction: '100/250CAL',
            moveProgress: 0.40,
            exerciseProgress: 0.30,
            standProgress: 0.50,
          ),
          _buildActivityRingCardItem(
            name: 'Jane',
            percentage: '157%',
            fraction: '630/400CAL',
            moveProgress: 1.57,
            exerciseProgress: 0.95,
            standProgress: 0.80,
          ),
          _buildActivityRingCardItem(
            name: 'Me',
            percentage: '68%',
            fraction: '410/600CAL',
            moveProgress: 0.68,
            exerciseProgress: 0.60,
            standProgress: 0.50,
            isMe: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionCard({
    required String friendName,
    required String friendPoints,
    required String friendToday,
    required String mePoints,
    required String meToday,
    required String bottomText,
    required Color darkCardBg,
    required Color goldPointsColor,
    required Color goldSubPointsColor,
    required Color greyText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Friend Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friendName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      friendPoints,
                      style: TextStyle(
                        color: goldPointsColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),
                    if (friendToday.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        friendToday,
                        style: TextStyle(
                          color: goldSubPointsColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Me Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Me',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mePoints,
                      style: TextStyle(
                        color: goldPointsColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),
                    if (meToday.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        meToday,
                        style: TextStyle(
                          color: goldSubPointsColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (bottomText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              bottomText,
              style: TextStyle(
                color: greyText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightCard({
    required String name,
    required String time,
    required Color accentColor,
    required IconData innerIcon,
    required String valueText,
    required String labelText,
    required Color darkCardBg,
    required Color greyText,
  }) {
    return Container(
      width: 290,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Avatar, Info, Chat Icon
          Row(
            children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF3A3A3C),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: Color(0xFF8E8E93),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name and Time ago
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(
                        color: greyText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Chat bubble icon
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Central Progress Ring Stack
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Background track ring
                  SizedBox(
                    width: 124,
                    height: 124,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 11,
                      color: accentColor.withAlpha(30),
                    ),
                  ),
                  // Outer Active progress ring (almost complete)
                  SizedBox(
                    width: 124,
                    height: 124,
                    child: CircularProgressIndicator(
                      value: 0.92,
                      strokeWidth: 11,
                      color: accentColor,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Icon(
                    innerIcon,
                    color: accentColor,
                    size: 50,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Workout Time / Award Text
          Center(
            child: Text(
              valueText,
              style: TextStyle(
                color: accentColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const SizedBox(height: 2),
          // Workout Name / Award Title
          Center(
            child: Text(
              labelText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildActivityRingCardItem({
    required String name,
    required String percentage,
    required String fraction,
    required double moveProgress,
    required double exerciseProgress,
    required double standProgress,
    bool isMe = false,
  }) {
    const Color darkCardBg = Color(0xFF1C1C1E);
    const Color pinkAccent = Color(0xFFFF2D55);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Info Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + Name Row
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3A3A3C),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF8E8E93),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (isMe) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: pinkAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Me',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else ...[
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // Percentage
              Text(
                percentage,
                style: TextStyle(
                  color: pinkAccent,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              // Fraction
              Text(
                fraction,
                style: TextStyle(
                  color: pinkAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Right Concentric Rings
          _buildTripleConcentricRings(
            moveProgress: moveProgress,
            exerciseProgress: exerciseProgress,
            standProgress: standProgress,
          ),
        ],
      ),
    );
  }

  Widget _buildTripleConcentricRings({
    required double moveProgress,
    required double exerciseProgress,
    required double standProgress,
  }) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Ring (Move - Red/Pink)
          SizedBox(
            width: 54,
            height: 54,
            child: CustomPaint(
              painter: MiniRingPainter(
                progress: moveProgress,
                ringColor: const Color(0xFFFF2D55),
                strokeWidth: 5.5,
              ),
            ),
          ),
          // Middle Ring (Exercise - Neon Green)
          SizedBox(
            width: 40,
            height: 40,
            child: CustomPaint(
              painter: MiniRingPainter(
                progress: exerciseProgress,
                ringColor: const Color(0xFF38D430),
                strokeWidth: 5.5,
              ),
            ),
          ),
          // Inner Ring (Stand - Cyan/Teal)
          SizedBox(
            width: 26,
            height: 26,
            child: CustomPaint(
              painter: MiniRingPainter(
                progress: standProgress,
                ringColor: const Color(0xFF00C7BE),
                strokeWidth: 5.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Beautiful, centered Share Activity onboarding screen in Light Mode matching the screenshot
  // ignore: unused_element
  Widget _buildSharingOnboarding(Color sharingPurple, Color cardBg) {
    const Color neonLimeGreen = Color(0xFFA6FF00); // Super vibrant Apple Fitness neon lime-green
    const Color charcoalText = Color(0xFF1C1C1E); // Apple Fitness high contrast charcoal text
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 120, // Leave floating bottom tabbar space
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 56,
                  bottom: 120, // Avoid overlap with floating bottom tab bar
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),

                    // 1. Playful Apple-Style Floating Composite Graphic Stack
                    Center(
                      child: SizedBox(
                        width: 240,
                        height: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Central Salmon-Pink Memoji Avatar Circle
                            Container(
                              width: 130,
                              height: 130,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF8577), // Salmon-Pink
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=180&q=80',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Icon(
                                      Icons.face_retouching_natural_rounded,
                                      color: Colors.white,
                                      size: 70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Top-Left Floating Circle (Blue Swim Icon)
                            Positioned(
                              top: 24,
                              left: 12,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF00D2FF), // Vivid Sky Blue
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.pool_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),

                            // Top-Right Floating Circle (Gold/White Achievement Medal Shield)
                            Positioned(
                              top: 24,
                              right: 12,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFF9F9FB), // White/Gold
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.workspace_premium_rounded,
                                    color: Color(0xFFFFC04D), // Warm Amber Gold
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),

                            // Bottom-Left Floating Circle (Dark Grey/Green Running Person)
                            Positioned(
                              bottom: 24,
                              left: 12,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF1E293B), // Slate Dark
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.directions_run_rounded,
                                    color: Color(0xFF38D430), // Active green
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),

                            // Middle-Right Floating Circle (Activity concentric rings)
                            Positioned(
                              bottom: 40,
                              right: 0,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7), // Light grey
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.donut_large_rounded,
                                    color: Color(0xFFFF2D55), // Active ring pink
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 2. Bold Title
                    const Text(
                      'Share Activity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: charcoalText,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 3. Subtitle / Prompt
                    const Text(
                      'Invite friends to support, challenge and cheer each other on. Share workouts, receive progress notifications and send messages — direct from the Fitness app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF636366),
                        fontSize: 15.5,
                        height: 1.38,
                      ),
                    ),
                    
                    const Spacer(),
                    const SizedBox(height: 40),

                    // 4. Footnote Section with People Icon & Detailed Disclaimer
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38D430).withAlpha(24),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.people_alt_rounded,
                            color: Color(0xFF30B02A), // Soft active green
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Activity data like workout types and titles, active calories or kilojoules, exercise minutes, stand or roll hours, steps and time zone will be securely shared with the people you choose.',
                                style: TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 12.5,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  _showSharingPrivacyModal(context, sharingPurple);
                                },
                                child: const Text(
                                  'See how your data is managed...',
                                  style: TextStyle(
                                    color: Color(0xFF30B02A),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 5. Centered pill-shaped "Get Started" Neon Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showSharingOnboarding = false; // Transition to Active dashboard charts
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: neonLimeGreen,
                          foregroundColor: charcoalText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          shadowColor: neonLimeGreen.withAlpha(40),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Premium iOS Light Mode active sharing friends list page
  // ignore: unused_element
  Widget _buildSharingFriendsList(Color sharingPurple, Color cardBg) {
    const Color charcoalText = Color(0xFF1C1C1E); // Apple Fitness high contrast charcoal text
    
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 64, // Keep top bleed status bar space
        bottom: 120, // Avoid bottom floating tab bar overlap
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Row: "Sharing" Title and Right Circular "Add Friend" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sharing',
                style: TextStyle(
                  color: charcoalText,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.8,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showInviteFriendBottomSheet(context, sharingPurple);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2E), // Light grey button
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_add_rounded,
                      color: charcoalText,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 2. Section Title
          const Text(
            'FRIENDS',
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Settings-like Card Container grouping the added friends
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _buildSharingFriendRowItem(
                    name: 'Gokul',
                    email: 'gokulsanth33010@gmail.com',
                    initial: 'G',
                    avatarColor: const Color(0xFF00C7BE), // Teal
                    moveProgress: '520 / 600 kcal',
                    exerciseProgress: '35 / 30 min',
                    ringProgress: 0.85,
                    ringColor: const Color(0xFFFF2D55), // Pink
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 72, right: 16),
                    child: Divider(color: Color(0xFF2C2C2E), height: 1, thickness: 0.8),
                  ),
                  _buildSharingFriendRowItem(
                    name: 'Sant',
                    email: 'sant.fitness@apple.com',
                    initial: 'S',
                    avatarColor: const Color(0xFFFF585D), // Salmon Red
                    moveProgress: '310 / 500 kcal',
                    exerciseProgress: '15 / 30 min',
                    ringProgress: 0.60,
                    ringColor: const Color(0xFF38D430), // Exercise Green
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),

          // 4. Centered hyperlink see how data is managed
          Center(
            child: GestureDetector(
              onTap: () {
                _showSharingPrivacyModal(context, sharingPurple);
              },
              child: const Text(
                'See how your data is managed...',
                style: TextStyle(
                  color: Color(0xFF30B02A), // Apple green
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder helper for individual added friend row inside the Friends List
  Widget _buildSharingFriendRowItem({
    required String name,
    required String email,
    required String initial,
    required Color avatarColor,
    required String moveProgress,
    required String exerciseProgress,
    required double ringProgress,
    required Color ringColor,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Viewing $name's activity details..."),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF30B02A),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Circular Avatar Container with a smaller concentric progress ring indicator
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Small Activity Ring outline overlay in the bottom right corner
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          value: ringProgress,
                          strokeWidth: 2,
                          color: ringColor,
                          backgroundColor: ringColor.withAlpha(40),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            
            // Friend's Name and Ring Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: darkSlateText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Move: $moveProgress • Exercise: $exerciseProgress',
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Trailing Chevron
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFC7C7CC),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // Intermediate Sharing Friends Empty State Dashboard screen in premium Light Mode
  // ignore: unused_element
  Widget _buildSharingFriendsEmptyState(Color sharingPurple, Color cardBg) {
    const Color charcoalText = Color(0xFF1C1C1E); // Apple Fitness high contrast charcoal text
    
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 64, // Keep top bleed status bar space
        bottom: 120, // Avoid bottom floating tab bar overlap
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Row: "Sharing" Title and Right Circular "Add Friend" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sharing',
                style: TextStyle(
                  color: charcoalText,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.8,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showInviteFriendBottomSheet(context, sharingPurple);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2E), // Light grey button
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_add_rounded,
                      color: charcoalText,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // 2. Beautiful Central Onboarding Empty-State Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: const Color(0xFF2C2C2E), width: 1) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Three People Icon
                const Icon(
                  Icons.people_alt_rounded,
                  color: Color(0xFF8E8E93),
                  size: 64,
                ),
                const SizedBox(height: 18),
                
                // Card Title
                const Text(
                  'Share Activity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: charcoalText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),

                // Card Subtext
                const Text(
                  'Invite friends to share workouts, get inspired and cheer each other on.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF636366),
                    fontSize: 14.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),

                // Dark Pill-Shaped "Invite a Friend" Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      _showInviteFriendBottomSheet(context, sharingPurple);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: charcoalText,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      'Invite a Friend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // 3. Centered hyperlink see how data is managed
          Center(
            child: GestureDetector(
              onTap: () {
                _showSharingPrivacyModal(context, sharingPurple);
              },
              child: const Text(
                'See how your data is managed...',
                style: TextStyle(
                  color: Color(0xFF30B02A), // Apple green
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Premium, stateful Cupertino bottom sheet modal for search and inviting friends
  void _showInviteFriendBottomSheet(BuildContext context, Color activeColor) {
    const Color neonLimeGreen = Color(0xFFA6FF00); // Lime green matching screenshot
    const Color goldHeaderColor = Color(0xFFE5C158); // Gold color for Currently Competing
    const Color darkCardBg = Color(0xFF1C1C1E); // Apple dark card background
    const Color darkSheetBg = Color(0xFF151517); // Apple dark sheet background
    const Color dividerColor = Color(0xFF2C2C2E); // Dark divider

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: darkSheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Covers 90% of screen to look like a dedicated modal view
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header: Close Button and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 42), // Spacer to balance the close button
                    const Text(
                      'Sharing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
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
                  ],
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 2. Currently Competing Section
                        const Text(
                          'Currently Competing',
                          style: TextStyle(
                            color: goldHeaderColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: darkCardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildModalPersonRow('Jane', isFirst: true),
                              _buildDivider(dividerColor),
                              _buildModalPersonRow('Doug'),
                              _buildDivider(dividerColor),
                              _buildModalPersonRow('Allen'),
                              _buildDivider(dividerColor),
                              _buildModalPersonRow('Emily', isLast: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3. Sharing With Section
                        const Text(
                          'Sharing With',
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: darkCardBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Invite a Friend row
                              InkWell(
                                onTap: () {
                                  _showShareActivityBottomSheet(context);
                                },
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Invite a Friend',
                                        style: TextStyle(
                                          color: neonLimeGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.add_circle_rounded,
                                        color: neonLimeGreen,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildDivider(dividerColor),
                              _buildModalPersonRow('Allen'),
                              _buildDivider(dividerColor),
                              _buildModalPersonRow('Doug'),
                              _buildDivider(dividerColor),
                              _buildModalPersonRow('Emily'),
                              _buildDivider(dividerColor),
                              _buildModalPersonRow('Jane', isLast: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 4. Bottom Data Privacy Link
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showSharingPrivacyModal(context, neonLimeGreen);
                            },
                            child: const Text(
                              'See how your data is managed...',
                              style: TextStyle(
                                color: neonLimeGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalPersonRow(String name, {bool isFirst = false, bool isLast = false}) {
    return InkWell(
      onTap: () {
        // Person detail click
      },
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(16) : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Circular Avatar Placeholder
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF3A3A3C),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF8E8E93),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Right Chevron
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF8E8E93),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 66),
      child: Divider(
        color: color,
        height: 1,
        thickness: 0.8,
      ),
    );
  }

  void _showShareActivityBottomSheet(BuildContext context) {
    const Color darkSheetBg = Color(0xFF151517); // Apple dark sheet background
    const Color neonLimeGreen = Color(0xFFA6FF00); // Lime green
    final TextEditingController toController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: darkSheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter sheetSetState) {
            final bool isSendActive = toController.text.trim().isNotEmpty;

            return FractionallySizedBox(
              heightFactor: 0.9, // Covers 90% of screen
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Header Row: Cancel button, Title, Send button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withAlpha(40), width: 1),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        // Title
                        const Text(
                          'Share Activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Send Button
                        GestureDetector(
                          onTap: isSendActive
                              ? () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Invitation sent to ${toController.text}!'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFF30B02A),
                                    ),
                                  );
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSendActive ? Colors.white : Colors.white.withAlpha(30),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Send',
                              style: TextStyle(
                                color: isSendActive ? Colors.black : Colors.white60,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. "To:" Input Row
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Text(
                            'To: ',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: toController,
                              autofocus: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              cursorColor: neonLimeGreen, // Green cursor from the screenshot
                              onChanged: (text) {
                                sheetSetState(() {});
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 4),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Action to select from contacts list
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2C2C2E),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      color: Color(0xFF2C2C2E),
                      height: 1,
                      thickness: 0.8,
                    ),
                    const SizedBox(height: 20),

                    // 3. Suggestions Header
                    const Text(
                      'SUGGESTIONS',
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),

                    // 4. Centered "No Suggestions" Section
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No Suggestions',
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  // Show standard data privacy details
  void _showSharingPrivacyModal(BuildContext context, Color limeGreen) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.security_rounded,
                color: limeGreen,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text(
                'Activity Sharing & Privacy',
                style: TextStyle(
                  color: darkSlateText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your Activity data is shared securely with the people you invite. You can choose to mute notifications from any friend, hide your activity progress from them, or stop sharing completely at any time from the sharing detail screen.',
                style: TextStyle(
                  color: Color(0xFF48484A),
                  fontSize: 14,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: limeGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Dismiss',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Custom Unique Concentric Activity Ring Painter with rounded caps and neon blur glows
class UniqueActivityRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;

  UniqueActivityRingPainter({
    required this.progress,
    required this.ringColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 14) / 2;

    // 1. Draw base track ring
    final trackPaint = Paint()
      ..color = ringColor.withAlpha(25)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw ambient outer neon glow under progress
    final glowPaint = Paint()
      ..color = ringColor.withAlpha(40)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..imageFilter = ImageFilter.blur(sigmaX: 5, sigmaY: 5);

    double sweepAngle = 2 * 3.14159265 * progress.clamp(0.01, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265 / 2, // Start at top
      sweepAngle,
      false,
      glowPaint,
    );

    // 3. Draw premium high-fidelity sweep gradient progress arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          ringColor.withAlpha(140),
          ringColor,
          ringColor.withAlpha(255),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-3.14159265 / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant UniqueActivityRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.ringColor != ringColor;
  }
}

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
      ..strokeWidth = 3
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
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final double centerWidth = size.width * 0.5;
    final double centerHeight = size.height * 0.35;
    final double radius = size.width * 0.22;

    canvas.save();
    canvas.clipPath(badgePath);
    canvas.drawCircle(Offset(centerWidth - 10, centerHeight + 5), radius, circlePaint1);
    canvas.drawCircle(Offset(centerWidth + 10, centerHeight - 5), radius - 2, circlePaint2);
    canvas.drawCircle(Offset(centerWidth - 10, centerHeight + 5), radius, ringStrokePaint);
    canvas.drawCircle(Offset(centerWidth + 10, centerHeight - 5), radius - 2, ringStrokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GymBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(15)
      ..style = PaintingStyle.fill;
    
    // Draw some vertical/diagonal decorative stripes/bars representing gym/columns
    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.7, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.6, 0);
    path2.lineTo(size.width * 0.9, 0);
    path2.lineTo(size.width * 1.3, size.height);
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WalkingFigurePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF2D55) // Premium iOS Move Pink/Red
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Draw a head
    final headPaint = Paint()
      ..color = const Color(0xFFFF2D55)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy - 18), 5.5, headPaint);

    // Draw torso (body line)
    canvas.drawLine(Offset(cx, cy - 12), Offset(cx - 2, cy + 5), paint);

    // Draw left leg (forward)
    canvas.drawLine(Offset(cx - 2, cy + 5), Offset(cx - 10, cy + 22), paint);

    // Draw right leg (backward)
    canvas.drawLine(Offset(cx - 2, cy + 5), Offset(cx + 8, cy + 22), paint);

    // Draw left arm (swinging backward)
    canvas.drawLine(Offset(cx - 1, cy - 8), Offset(cx - 12, cy + 2), paint);

    // Draw right arm (swinging forward)
    canvas.drawLine(Offset(cx - 1, cy - 8), Offset(cx + 8, cy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MiniRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final double strokeWidth;

  MiniRingPainter({
    required this.progress,
    required this.ringColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 1. Draw base track ring
    final trackPaint = Paint()
      ..color = ringColor.withAlpha(30)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw progress arc
    final progressPaint = Paint()
      ..color = ringColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 2 * 3.14159265 * progress.clamp(0.0, 2.0); // Allow overflow arcs
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265 / 2, // Start at top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MiniRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.ringColor != ringColor || oldDelegate.strokeWidth != strokeWidth;
  }
}



