import 'package:flutter/material.dart';
import 'dart:ui';

class ActivityDetailsPage extends StatefulWidget {
  final int calorieTarget;

  const ActivityDetailsPage({
    super.key,
    required this.calorieTarget,
  });

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> with TickerProviderStateMixin {
  late int _calorieTarget;

  // Breathing pulse controller for custom activity ring details page
  late AnimationController _breathController;
  bool _isBreathControllerInitialized = false;

  // Entrance ring full & return animation controller
  late AnimationController _ringAnimController;
  late Animation<double> _ringAnimation;
  bool _isRingAnimationInitialized = false;

  int _selectedDayIndex = 5; // Default Saturday active

  // Mock static day data for realistic metric displays
  final List<DayActivityData> _weeklyData = const [
    DayActivityData(label: 'M', progress: 0.45, caloriesBurned: 315, steps: 4500, distance: 2.1, flights: 4),
    DayActivityData(label: 'T', progress: 0.85, caloriesBurned: 595, steps: 8900, distance: 4.2, flights: 9),
    DayActivityData(label: 'W', progress: 0.30, caloriesBurned: 210, steps: 3200, distance: 1.5, flights: 2),
    DayActivityData(label: 'T', progress: 1.15, caloriesBurned: 805, steps: 12500, distance: 5.9, flights: 14),
    DayActivityData(label: 'F', progress: 0.60, caloriesBurned: 420, steps: 6100, distance: 2.8, flights: 6),
    DayActivityData(label: 'S', progress: 0.95, caloriesBurned: 665, steps: 9800, distance: 4.6, flights: 11), // Saturday index 5
    DayActivityData(label: 'S', progress: 0.05, caloriesBurned: 35, steps: 500, distance: 0.2, flights: 1),  // Sunday index 6
  ];

  void _onDaySelected(int index) {
    if (index == _selectedDayIndex) return;

    double startVal = _weeklyData[_selectedDayIndex].progress;
    double endVal = _weeklyData[index].progress;

    setState(() {
      _selectedDayIndex = index;
    });

    // Reset the controller and build a simple transition tween
    _ringAnimController.stop();
    _ringAnimController.reset();

    _ringAnimation = Tween<double>(
      begin: startVal,
      end: endVal,
    ).animate(CurvedAnimation(
      parent: _ringAnimController,
      curve: Curves.easeOutCubic,
    ));

    // Run transition animation
    _ringAnimController.duration = const Duration(milliseconds: 700);
    _ringAnimController.forward();
  }

  @override
  void initState() {
    super.initState();
    _calorieTarget = widget.calorieTarget;
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _isBreathControllerInitialized = true;

    // Professional entrance animation: goes 0.0 -> 1.0 (full) -> 0.95 (resting Saturday progress)
    _ringAnimController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _ringAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.95)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50.0,
      ),
    ]).animate(_ringAnimController);
    _isRingAnimationInitialized = true;

    _ringAnimController.forward();
  }

  @override
  void dispose() {
    _breathController.dispose();
    _ringAnimController.dispose();
    super.dispose();
  }

  // Stylish Apple-style Change Move Goal Dialog in Dark Mode
  void _showChangeGoalDialog(BuildContext context) {
    const Color fitnessPink = Color(0xFFFF2D55);
    int tempGoal = _calorieTarget;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Goal Dialog',
      barrierColor: Colors.black.withAlpha(160), // Dark overlay
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, anim2, child) {
        // Luxuriously smooth spring scale bounce effect
        final curvedValue = Curves.easeOutBack.transform(anim.value);
        return Transform.scale(
          scale: 0.9 + 0.1 * curvedValue,
          child: Opacity(
            opacity: anim.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 36),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E), // Apple Dark settings background
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withAlpha(20), // subtle 0.08 opacity border
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(150),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Move Icon Container
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: fitnessPink.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_run_rounded,
                            color: fitnessPink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Dialog Title
                        const Text(
                          'Move Goal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Set a daily active calorie goal that fits your fitness level.',
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 14,
                            height: 1.35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Calorie Increment/Decrement Selector Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Minus Button
                            GestureDetector(
                              onTap: () {
                                if (tempGoal > 10) {
                                  setModalState(() {
                                    tempGoal -= 10;
                                  });
                                }
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2C2C2E), // Apple Dark Elevated card bg
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.remove_rounded,
                                  color: fitnessPink,
                                  size: 32,
                                ),
                              ),
                            ),
                            // Calorie Value display
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$tempGoal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const Text(
                                  'CAL / DAY',
                                  style: TextStyle(
                                    color: Color(0xFF8E8E93),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            // Plus Button
                            GestureDetector(
                              onTap: () {
                                if (tempGoal < 3000) {
                                  setModalState(() {
                                    tempGoal += 10;
                                  });
                                }
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2C2C2E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: fitnessPink,
                                  size: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),
                        // Update Goal action button (hot pink/red capsule)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _calorieTarget = tempGoal;
                              });
                              Navigator.pop(context); // Close dialog

                              // Show success notification snackbar (dark mode)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 8,
                                  backgroundColor: const Color(0xFF1C1C1E),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.white.withAlpha(20),
                                      width: 1,
                                    ),
                                  ),
                                  content: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: fitnessPink.withAlpha(25),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: fitnessPink,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Daily Move Goal updated to $tempGoal CAL!',
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
                              backgroundColor: fitnessPink,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: const Text(
                              'Update Move Goal',
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
          ),
        );
      },
    );
  }

  // Beautiful Apple-style slide-up "Pause Move Ring" dialog exactly matching the screenshot
  void _showPauseRingSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Pause Sheet',
      barrierColor: Colors.black.withAlpha(180), // Premium dim overlay
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, anim2, child) {
        // High-fidelity smooth dynamic slide up transition
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

        return SlideTransition(
          position: slideAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF151517), // Deep dark iOS sheet background matching screenshot
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withAlpha(12), // faint premium border
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Top left 'X' Close Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C2C2E), // Apple Dark settings grey button
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
                  const SizedBox(height: 16),

                  // 2. Headings text block
                  const Text(
                    'Pause Move Ring',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Mute coaching and goal tracking while maintaining your Move streak.',
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 15,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 3. Faded Concentric Ring Graphic exactly like the screenshot
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2C2C2E), // Faded Apple ring grey
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 52),

                  // 4. Vertical Stack of Action Option Buttons
                  _buildPauseOptionButton('For Today'),
                  _buildPauseOptionButton('Until Monday'),
                  _buildPauseOptionButton('Until June'),
                  _buildPauseOptionButton('Custom'),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Builder helper for the options in the Pause Ring modal sheet
  Widget _buildPauseOptionButton(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context); // close sheet
          // Show successful pausing confirmation snack bar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 8,
              backgroundColor: const Color(0xFF1C1C1E),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withAlpha(20), width: 1),
              ),
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2C2E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pause_rounded,
                      color: Color(0xFFFF2D55),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Move Ring successfully paused $text!',
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
          backgroundColor: const Color(0xFF2C2C2E), // Apple Dark settings grey button bg
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Stunning Custom Apple-style Fitness History Calendar Dialog
  void _showFitnessCalendar(BuildContext context) {
    const Color fitnessPink = Color(0xFFFF2D55);
    int dialogMonthIndex = 4; // Start at May (index 4)

    const List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const List<int> daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    // Start weekday spacer offsets for each month in 2026 (Mon=0, Tue=1, Wed=2, Thu=3, Fri=4, Sat=5, Sun=6)
    const List<int> firstDayOffsets = [3, 6, 6, 2, 4, 0, 2, 5, 1, 3, 6, 1];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Calendar',
      barrierColor: Colors.black.withAlpha(200), // Rich premium dark backdrop
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, anim2, child) {
        final curvedValue = Curves.easeOutBack.transform(anim.value);
        return Transform.scale(
          scale: 0.9 + 0.1 * curvedValue,
          child: Opacity(
            opacity: anim.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  final String currentMonthName = months[dialogMonthIndex];
                  final int totalDays = daysInMonths[dialogMonthIndex];
                  final int spacerOffset = firstDayOffsets[dialogMonthIndex];
                  final int totalCells = totalDays + spacerOffset;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151517), // Deep dark iOS sheet bg
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withAlpha(20),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(180),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header title & Close Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Fitness History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2C2C2E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Month selector row with functional navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: fitnessPink, size: 14),
                              onPressed: dialogMonthIndex > 0
                                  ? () {
                                      setModalState(() {
                                        dialogMonthIndex--;
                                      });
                                    }
                                  : null,
                              disabledColor: Colors.white30,
                            ),
                            Text(
                              '$currentMonthName 2026',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded, color: fitnessPink, size: 14),
                              onPressed: dialogMonthIndex < 11
                                  ? () {
                                      setModalState(() {
                                        dialogMonthIndex++;
                                      });
                                    }
                                  : null,
                              disabledColor: Colors.white30,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Weekday headers: M, T, W, T, F, S, S
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(child: Center(child: Text('M', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('T', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('W', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('T', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('F', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('S', style: TextStyle(color: Color(0xFFFF2D55), fontSize: 11, fontWeight: FontWeight.bold)))),
                            Expanded(child: Center(child: Text('S', style: TextStyle(color: Color(0xFFFF2D55), fontSize: 11, fontWeight: FontWeight.bold)))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Days grid
                        SizedBox(
                          height: 275, // accommodates up to 6 rows comfortably
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: totalCells,
                            itemBuilder: (context, gridIndex) {
                              if (gridIndex < spacerOffset) {
                                return const SizedBox.shrink();
                              }
                              
                              final int dayNum = gridIndex - spacerOffset + 1;

                              // Generate mock progress ring value for each day of May
                              final double progress = (((dayNum * 7) + (dialogMonthIndex * 13)) % 100) / 100.0;
                              
                              // Active status
                              final bool isToday = (dialogMonthIndex == 4 && dayNum == 23);
                              final bool isSelected = (dialogMonthIndex == 4 && dayNum >= 18 && dayNum <= 24) && (dayNum - 18 == _selectedDayIndex);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (dialogMonthIndex == 4 && dayNum >= 18 && dayNum <= 24) {
                                    _onDaySelected(dayNum - 18);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        elevation: 8,
                                        backgroundColor: const Color(0xFF1C1C1E),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: BorderSide(color: Colors.white.withAlpha(20), width: 1),
                                        ),
                                        content: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF2C2C2E),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.calendar_month_rounded,
                                                color: fitnessPink,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Switched to May $dayNum metrics!',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        elevation: 8,
                                        backgroundColor: const Color(0xFF1C1C1E),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: BorderSide(color: Colors.white.withAlpha(20), width: 1),
                                        ),
                                        content: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: fitnessPink.withAlpha(25),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.fitness_center_rounded,
                                                color: fitnessPink,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                '${months[dialogMonthIndex]} $dayNum: Burned ${(progress * _calorieTarget).round()} active CAL!',
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
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? fitnessPink.withAlpha(40) 
                                        : isToday 
                                            ? Colors.white.withAlpha(20) 
                                            : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: isSelected 
                                        ? Border.all(color: fitnessPink, width: 1.5)
                                        : isToday
                                            ? Border.all(color: Colors.white.withAlpha(100), width: 1)
                                            : null,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Mini progress ring around day number
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: CustomPaint(
                                            painter: MiniCalendarRingPainter(
                                              progress: progress,
                                              ringColor: fitnessPink,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Day number centered
                                      Text(
                                        '$dayNum',
                                        style: TextStyle(
                                          color: isSelected 
                                              ? Colors.white 
                                              : isToday 
                                                  ? fitnessPink 
                                                  : Colors.white.withAlpha(220),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: fitnessPink, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            const Text('Activity Rings show daily achievements', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Stunning Custom iOS-style Share Sheet Pop-up
  void _showShareSheet(BuildContext context) {
    const Color fitnessPink = Color(0xFFFF2D55);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151517), // iPhone deep dark sheet bg
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border.all(
              color: Colors.white.withAlpha(20),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // iOS-style drag handle bar
              Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51), // 0.2 opacity
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 18),
              
              // 1. Activity Ring Preview card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Mini preview square
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withAlpha(25), width: 1),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomPaint(
                                painter: MiniCalendarRingPainter(
                                  progress: _weeklyData[_selectedDayIndex].progress,
                                  ringColor: fitnessPink,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            child: Text(
                              'May ${_selectedDayIndex + 18}',
                              style: TextStyle(
                                color: Colors.white.withAlpha(140),
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Sharing preview text
                    const Expanded(
                      child: Text(
                        'Check out my progress today with the Fitness App! Burned calories and crushed targets!',
                        style: TextStyle(
                          color: Color(0xFFE5E5EA),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFF2C2C2E), height: 1, thickness: 1),
              const SizedBox(height: 20),

              // 2. iOS Apps Icon Row
              SizedBox(
                height: 115,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // AirDrop
                    _buildShareAppIcon(
                      label: 'AirDrop',
                      color: const Color(0xFF007AFF),
                      iconWidget: const Icon(Icons.wifi_tethering_rounded, color: Colors.white, size: 28),
                      onTap: () => _handleShareAction(context, 'AirDrop'),
                    ),
                    // WhatsApp
                    _buildShareAppIcon(
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      iconWidget: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 26),
                      onTap: () => _handleShareAction(context, 'WhatsApp'),
                    ),
                    // Telegram
                    _buildShareAppIcon(
                      label: 'Telegram',
                      color: const Color(0xFF37AEE2),
                      iconWidget: const Icon(Icons.send_rounded, color: Colors.white, size: 26),
                      onTap: () => _handleShareAction(context, 'Telegram'),
                    ),
                    // Reminders (iPhone dot style)
                    _buildShareAppIcon(
                      label: 'Reminders',
                      color: Colors.white,
                      iconWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildReminderDot(Colors.blue),
                          _buildReminderDot(Colors.red),
                          _buildReminderDot(Colors.orange),
                        ],
                      ),
                      onTap: () => _handleShareAction(context, 'Reminders'),
                    ),
                    // Near Me
                    _buildShareAppIcon(
                      label: 'Near Me',
                      color: const Color(0xFF5856D6),
                      iconWidget: const Icon(Icons.radar_rounded, color: Colors.white, size: 28),
                      onTap: () => _handleShareAction(context, 'Near Me'),
                    ),
                    // More icon matching iPhone share sheet
                    _buildShareAppIcon(
                      label: 'More',
                      color: Colors.white,
                      iconWidget: const Icon(Icons.more_horiz_rounded, color: Color(0xFF1C1C1E), size: 30),
                      onTap: () => _showMoreAppsPopup(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFF2C2C2E), height: 1, thickness: 1),
              const SizedBox(height: 20),

              // 3. iPhone Quick Action Buttons (Copy, Save Image, Print, Save to Files)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickActionItem(
                      label: 'Copy',
                      icon: Icons.content_copy_rounded,
                      onTap: () => _handleShareAction(context, 'Copy link'),
                    ),
                    _buildQuickActionItem(
                      label: 'Save Image',
                      icon: Icons.download_rounded,
                      onTap: () => _handleShareAction(context, 'Save Image'),
                    ),
                    _buildQuickActionItem(
                      label: 'Print',
                      icon: Icons.print_rounded,
                      onTap: () => _handleShareAction(context, 'Print'),
                    ),
                    _buildQuickActionItem(
                      label: 'Save to Files',
                      icon: Icons.folder_open_rounded,
                      onTap: () => _handleShareAction(context, 'Save to Files'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builder helper for individual sharing iOS squircle apps
  Widget _buildShareAppIcon({
    required String label,
    required Color color,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 68,
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15), // Apple squircle
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFE5E5EA),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Draw custom iOS reminder dots inside squircle
  Widget _buildReminderDot(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 2.5,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D1D6),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder helper for bottom iPhone quick action circles
  Widget _buildQuickActionItem({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E), // Apple Dark translucent action button bg
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(15), width: 1),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // Show secondary pop-up when iPhone share sheet "More" is clicked
  void _showMoreAppsPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss More Apps',
      barrierColor: Colors.black.withAlpha(200),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, anim2, child) {
        final curvedValue = Curves.easeOutBack.transform(anim.value);
        return Transform.scale(
          scale: 0.9 + 0.1 * curvedValue,
          child: Opacity(
            opacity: anim.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E), // iPhone dark settings cards bg
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withAlpha(20), width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Share App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close_rounded, color: Colors.white60, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildMoreAppListItem(
                      appName: 'Instagram Stories',
                      icon: Icons.camera_alt_outlined,
                      color: const Color(0xFFE1306C),
                      onTap: () {
                        Navigator.pop(context);
                        _handleShareAction(context, 'Instagram Stories');
                      },
                    ),
                    _buildMoreAppListItem(
                      appName: 'Messages',
                      icon: Icons.sms_rounded,
                      color: const Color(0xFF34C759),
                      onTap: () {
                        Navigator.pop(context);
                        _handleShareAction(context, 'Messages');
                      },
                    ),
                    _buildMoreAppListItem(
                      appName: 'Mail',
                      icon: Icons.mail_rounded,
                      color: const Color(0xFF007AFF),
                      onTap: () {
                        Navigator.pop(context);
                        _handleShareAction(context, 'Mail');
                      },
                    ),
                    _buildMoreAppListItem(
                      appName: 'Twitter (X)',
                      icon: Icons.close_rounded,
                      color: Colors.black,
                      onTap: () {
                        Navigator.pop(context);
                        _handleShareAction(context, 'Twitter (X)');
                      },
                    ),
                    _buildMoreAppListItem(
                      appName: 'Slack',
                      icon: Icons.hub_rounded,
                      color: const Color(0xFF4A154B),
                      onTap: () {
                        Navigator.pop(context);
                        _handleShareAction(context, 'Slack');
                      },
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

  // Builder helper for the secondary pop-up list view rows
  Widget _buildMoreAppListItem({
    required String appName,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E), // Translucent iPhone action card list element bg
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withAlpha(10), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 14),
          ],
        ),
      ),
    );
  }

  // Handle dialog dismiss and trigger success toast notification snackbar
  void _handleShareAction(BuildContext context, String actionName) {
    Navigator.pop(context); // close sheet
    const Color fitnessPink = Color(0xFFFF2D55);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 8,
        backgroundColor: const Color(0xFF1C1C1E),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withAlpha(20), width: 1),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: fitnessPink.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: fitnessPink,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Successfully shared via $actionName!',
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
  }


  @override
  Widget build(BuildContext context) {
    const Color fitnessPink = Color(0xFFFF2D55); // Dynamic Pink/Red Apple Ring Color
    final now = DateTime.now();
    final dateStr = "Today, ${now.day} ${_getMonthName(now.month)} ${now.year}";

    return Scaffold(
      backgroundColor: Colors.black, // Dark Mode exactly like screenshot
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top custom Navigation Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular back button
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
                  // Centered Date title
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  // Action buttons (Calendar & Share)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showFitnessCalendar(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1C1C1E),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showShareSheet(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1C1C1E),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.ios_share_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Weekly days row (Fully Interactive)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildWeekDay('M', 0),
                  _buildWeekDay('T', 1),
                  _buildWeekDay('W', 2),
                  _buildWeekDay('T', 3),
                  _buildWeekDay('F', 4),
                  _buildWeekDay('S', 5), // Saturday
                  _buildWeekDay('S', 6), // Sunday
                ],
              ),
              const SizedBox(height: 44),

              // 3. Huge centered Move ring
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Ring Indicator - Custom concentric glowing detailed painter
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: _isRingAnimationInitialized
                        ? AnimatedBuilder(
                            animation: _ringAnimation,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: UniqueDetailedRingPainter(
                                  progress: _ringAnimation.value,
                                  ringColor: fitnessPink,
                                ),
                              );
                            },
                          )
                        : CustomPaint(
                            painter: UniqueDetailedRingPainter(
                              progress: 0.05, // startup target progress fallback
                              ringColor: fitnessPink,
                            ),
                          ),
                    ),
                    // Core circular glowing arrow at top with breathing pulse animation
                    Positioned(
                      top: 0,
                      child: _isBreathControllerInitialized
                        ? AnimatedBuilder(
                            animation: _breathController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 0.94 + 0.12 * _breathController.value,
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: fitnessPink,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: fitnessPink.withAlpha(
                                          (100 + 155 * _breathController.value).round(),
                                        ),
                                        blurRadius: 12 + 12 * _breathController.value,
                                        spreadRadius: 2 * _breathController.value,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: fitnessPink,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: fitnessPink,
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),

              // 4. Move Metric details & Goal selector Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Move',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${_weeklyData[_selectedDayIndex].caloriesBurned}/$_calorieTarget',
                            style: const TextStyle(
                              color: fitnessPink,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const Text(
                            'CAL',
                            style: TextStyle(
                              color: fitnessPink,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_weeklyData[_selectedDayIndex].caloriesBurned}CAL',
                        style: const TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Edit target circular button
                  GestureDetector(
                    onTap: () => _showChangeGoalDialog(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          color: fitnessPink,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFF1C1C1E), height: 1, thickness: 1),
              const SizedBox(height: 20),

              // 5. Red dotted horizontal chart guidelines
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: List.generate(
                      50,
                      (index) => Expanded(
                        child: Container(
                          height: 1.5,
                          color: index % 2 == 0 ? fitnessPink.withAlpha(153) : Colors.transparent, // 0.6 opacity
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('12:00', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('6:00', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('12:00', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('6:00', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TOTAL ${_weeklyData[_selectedDayIndex].caloriesBurned} CAL',
                    style: const TextStyle(
                      color: fitnessPink,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFF1C1C1E), height: 1, thickness: 1),
              const SizedBox(height: 20),

              // 6. Sub metrics details grid (Steps, Distance, Flights Climbed)
              Row(
                children: [
                  Expanded(
                    child: _buildSubMetric(
                      'Steps',
                      '${_weeklyData[_selectedDayIndex].steps}',
                    ),
                  ),
                  Expanded(
                    child: _buildSubMetric(
                      'Distance',
                      '${_weeklyData[_selectedDayIndex].distance}MI',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSubMetric(
                'Flights Climbed',
                '${_weeklyData[_selectedDayIndex].flights}',
              ),
              const SizedBox(height: 36),

              // 7. Bottom action buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _showChangeGoalDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text(
                          'Change Goal',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _showPauseRingSheet(context), // Dynamic sheet matching screenshot
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text(
                          'Pause Ring',
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Builder helper for the day items in the weekly row
  Widget _buildWeekDay(String label, int index) {
    final bool isActive = _selectedDayIndex == index;
    const Color activeColor = Color(0xFFFF2D55);
    return GestureDetector(
      onTap: () => _onDaySelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : const Color(0xFF8E8E93),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.transparent,
              shape: BoxShape.circle,
              border: isActive 
                  ? null 
                  : Border.all(color: activeColor.withAlpha(51), width: 1.5), // 0.2 opacity
            ),
            child: Center(
              child: Text(
                isActive ? label : '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (isActive)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  // Builder helper for steps / distance / flights climbed metrics
  Widget _buildSubMetric(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF8E8E93),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

// Custom Unique Concentric Activity Ring Painter with rounded caps and neon blur glows
class UniqueDetailedRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;

  UniqueDetailedRingPainter({
    required this.progress,
    required this.ringColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 26) / 2; // radius adjusted for strokeWidth: 26

    // 1. Draw base track ring
    final trackPaint = Paint()
      ..color = ringColor.withAlpha(25)
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw ambient outer neon glow under progress
    final glowPaint = Paint()
      ..color = ringColor.withAlpha(45)
      ..strokeWidth = 32 // wider than progress arc for glow effect
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..imageFilter = ImageFilter.blur(sigmaX: 8, sigmaY: 8);

    double sweepAngle = 2 * 3.141592653589793 * progress.clamp(0.01, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2, // Start at top
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
        transform: const GradientRotation(-3.141592653589793 / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant UniqueDetailedRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.ringColor != ringColor;
  }
}

// Data holder class for each weekday activity metrics
class DayActivityData {
  final String label;
  final double progress;
  final int caloriesBurned;
  final int steps;
  final double distance;
  final int flights;

  const DayActivityData({
    required this.label,
    required this.progress,
    required this.caloriesBurned,
    required this.steps,
    required this.distance,
    required this.flights,
  });
}

// Mini Concentric Ring Painter for the custom Fitness Calendar cells
class MiniCalendarRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;

  MiniCalendarRingPainter({
    required this.progress,
    required this.ringColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 4) / 2; // thin 2px spacing

    // 1. Base track ring
    final trackPaint = Paint()
      ..color = ringColor.withAlpha(25)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Glowing progress arc
    final progressPaint = Paint()
      ..color = ringColor
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 2 * 3.141592653589793 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MiniCalendarRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.ringColor != ringColor;
  }
}

