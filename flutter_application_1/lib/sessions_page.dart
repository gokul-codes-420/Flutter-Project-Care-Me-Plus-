import 'package:flutter/material.dart';

class LoggedSession {
  final String activityType;
  final int duration;
  final int calories;
  final DateTime dateTime;

  LoggedSession({
    required this.activityType,
    required this.duration,
    required this.calories,
    required this.dateTime,
  });
}

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final List<LoggedSession> _sessions = [];
  final int _currentTabIndex = 0; // Aligned with Summary page

  void _navigateToTab(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, index);
    }
  }

  // Activity type icon lookup helper
  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'run':
        return Icons.directions_run_rounded;
      case 'walk':
        return Icons.directions_walk_rounded;
      case 'cycle':
        return Icons.directions_bike_rounded;
      case 'swim':
        return Icons.pool_rounded;
      case 'yoga':
        return Icons.spa_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }

  // Activity type color lookup helper
  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'run':
        return const Color(0xFFFF2D55); // Pink/Red
      case 'walk':
        return const Color(0xFF38D430); // Exercise Green
      case 'cycle':
        return const Color(0xFFFF9500); // Orange
      case 'swim':
        return const Color(0xFF00C7BE); // Teal
      case 'yoga':
        return const Color(0xFFAF52DE); // Purple
      default:
        return const Color(0xFFA6FF00); // Lime
    }
  }

  // Beautiful Apple-style slide-up "Log Workout Session" sheet
  void _showLogSessionSheet(BuildContext context) {
    String selectedActivity = 'Run';
    double selectedDuration = 30.0;
    double selectedCalories = 250.0;

    final List<String> activities = ['Run', 'Walk', 'Cycle', 'Swim', 'Yoga', 'Strength'];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Log Sheet',
      barrierColor: Colors.black.withAlpha(180), // Premium dimmed backdrop
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
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
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
                      // Header Row
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
                            'Log Session',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 38), // balancing Spacer
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 1. Activity Type Horizontal Tapping Selector
                      const Text(
                        'ACTIVITY TYPE',
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: activities.length,
                          itemBuilder: (context, idx) {
                            final String act = activities[idx];
                            final bool isSel = selectedActivity == act;
                            final Color actColor = _getActivityColor(act);
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedActivity = act;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: isSel ? actColor : const Color(0xFF2C2C2E),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    act,
                                    style: TextStyle(
                                      color: isSel ? Colors.white : const Color(0xFF8E8E93),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Duration Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'DURATION',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '${selectedDuration.round()} mins',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: selectedDuration,
                        min: 5,
                        max: 120,
                        activeColor: _getActivityColor(selectedActivity),
                        inactiveColor: const Color(0xFF2C2C2E),
                        onChanged: (val) {
                          setModalState(() {
                            selectedDuration = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 3. Calories Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ACTIVE CALORIES',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '${selectedCalories.round()} kcal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: selectedCalories,
                        min: 50,
                        max: 1000,
                        activeColor: _getActivityColor(selectedActivity),
                        inactiveColor: const Color(0xFF2C2C2E),
                        onChanged: (val) {
                          setModalState(() {
                            selectedCalories = val;
                          });
                        },
                      ),
                      const SizedBox(height: 28),

                      // Log Workout Action Button (Glowing highlight)
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _sessions.insert(
                                0,
                                LoggedSession(
                                  activityType: selectedActivity,
                                  duration: selectedDuration.round(),
                                  calories: selectedCalories.round(),
                                  dateTime: DateTime.now(),
                                ),
                              );
                            });
                            Navigator.pop(context); // Close sheet

                            // High-end dark confirmation toast
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                elevation: 8,
                                backgroundColor: const Color(0xFF151517),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(20),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Colors.white.withAlpha(12),
                                    width: 1,
                                  ),
                                ),
                                content: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: _getActivityColor(selectedActivity).withAlpha(25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _getActivityIcon(selectedActivity),
                                        color: _getActivityColor(selectedActivity),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Logged $selectedActivity Session successfully!',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getActivityColor(selectedActivity),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Log Workout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Clean empty state when no workouts are logged
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF151517),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withAlpha(8),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.fitness_center_rounded,
              color: Color(0xFF48484A),
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'No Sessions Recorded Yet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Tap the compose icon in the top right to log your manual workout sessions and track your daily streak.',
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 14.5,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Generates custom lists items for manually logged sessions
  Widget _buildSessionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sessions.length,
      itemBuilder: (context, idx) {
        final session = _sessions[idx];
        final Color actColor = _getActivityColor(session.activityType);
        final String formattedTime = '${session.dateTime.hour % 12 == 0 ? 12 : session.dateTime.hour % 12}:${session.dateTime.minute.toString().padLeft(2, '0')} ${session.dateTime.hour >= 12 ? 'PM' : 'AM'}';

        return Dismissible(
          key: Key(session.dateTime.millisecondsSinceEpoch.toString() + session.activityType),
          direction: DismissDirection.endToStart, // Swipe left only!
          onDismissed: (direction) {
            final deletedSession = session;
            final originalIndex = idx;

            setState(() {
              _sessions.removeAt(idx);
            });

            // Show a high-fidelity confirmation toast with Undo action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 8,
                backgroundColor: const Color(0xFF151517),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.white.withAlpha(12),
                    width: 1,
                  ),
                ),
                content: Row(
                  children: [
                    const Icon(
                      Icons.delete_sweep_rounded,
                      color: Color(0xFFFF3B30),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Deleted ${session.activityType} Session!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                action: SnackBarAction(
                  label: 'UNDO',
                  textColor: const Color(0xFFA6FF00), // Lime green
                  onPressed: () {
                    setState(() {
                      _sessions.insert(originalIndex, deletedSession);
                    });
                  },
                ),
              ),
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30), // Apple Red
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.delete_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF151517), // iOS Dark card
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withAlpha(8),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                // Left: Icon Circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: actColor.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getActivityIcon(session.activityType),
                    color: actColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Center: Info Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.activityType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFF8E8E93),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${session.duration} mins',
                            style: const TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.access_time_rounded,
                            color: Color(0xFF8E8E93),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right: Burn calories badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${session.calories}',
                      style: TextStyle(
                        color: actColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'CAL',
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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
  }

  @override
  Widget build(BuildContext context) {
    const Color neonLime = Color(0xFFA6FF00); // Lime-green accent

    return Scaffold(
      backgroundColor: Colors.black, // Dark mode Scaffold
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
                    // Top Custom Header Row with Back and Compose buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Back button
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
                        // Right: Compose button
                        GestureDetector(
                          onTap: () => _showLogSessionSheet(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1C1C1E),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.edit_note_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Page Title
                    const Text(
                      'Sessions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // "All" Lime-Green badge pill under header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: neonLime, // Apple Neon lime-green pill
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              'All',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Dynamic body (Empty state or session cards list)
                    _sessions.isEmpty ? _buildEmptyState() : _buildSessionsList(),
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
