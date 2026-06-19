import 'package:flutter/material.dart';

class DailyMoveGoalPage extends StatefulWidget {
  const DailyMoveGoalPage({super.key});

  @override
  State<DailyMoveGoalPage> createState() => _DailyMoveGoalPageState();
}

class _DailyMoveGoalPageState extends State<DailyMoveGoalPage> {
  // Activity level selected index: 0 = Lightly, 1 = Moderately, 2 = Highly
  int _selectedActivityIndex = 0;
  
  // Calorie targets for each activity level
  int _calories = 120;

  // Default values for resetting on tab change
  final List<int> _defaultCalories = [120, 300, 500];

  void _onActivityLevelChanged(int index) {
    setState(() {
      _selectedActivityIndex = index;
      _calories = _defaultCalories[index];
    });
  }

  void _incrementCalories() {
    setState(() {
      if (_calories < 2000) {
        _calories += 10;
      }
    });
  }

  void _decrementCalories() {
    setState(() {
      if (_calories > 10) {
        _calories -= 10;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color activePink = Color(0xFFFF2D55); // Premium vibrant iOS Fitness Move pink
    final Color segmentBg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7); // Light grey pill background

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back Button Row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Main Heading
              Text(
                'Daily Move Goal',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Set a goal based on how active you are, or how active you’d like to be, each day.',
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF636366),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Pill Segmented Control Container
              Container(
                height: 46,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: segmentBg,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    _buildSegmentItem('Lightly', 0),
                    _buildSegmentItem('Moderately', 1),
                    _buildSegmentItem('Highly', 2),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Counter Control Section (Minus, Large Counter, Plus)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Minus Button
                  _buildRoundActionButton(
                    icon: Icons.remove,
                    onTap: _decrementCalories,
                    color: activePink,
                  ),
                  
                  // Calories count display
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_calories',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                          fontSize: 72,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const Text(
                        'CALORIES/DAY',
                        style: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  
                  // Plus Button
                  _buildRoundActionButton(
                    icon: Icons.add,
                    onTap: _incrementCalories,
                    color: activePink,
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Set Move Goal Action Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/fitness-summary', arguments: _calories);
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
                  'Set Move Goal',
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

  // Segmented Control Item Builder
  Widget _buildSegmentItem(String title, int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = _selectedActivityIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onActivityLevelChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? const Color(0xFF2C2C2E) : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? (isDark ? Colors.white : const Color(0xFF1C1C1E)) : const Color(0xFF8E8E93),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // Pink Increment/Decrement Button Builder
  Widget _buildRoundActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
