import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FitnessNotificationsPage extends StatefulWidget {
  const FitnessNotificationsPage({super.key});

  @override
  State<FitnessNotificationsPage> createState() => _FitnessNotificationsPageState();
}

class _FitnessNotificationsPageState extends State<FitnessNotificationsPage> {
  bool _dailyCoaching = true;
  bool _goalCompletions = true;
  bool _activitySharing = true;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color iosGreen = Color(0xFF34C759); // Standard iOS Green Switch Color

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7), // Dynamic background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Navigation Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular back button
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
                  // Centered Title
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  // Balanced spacer
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 36),

              // 2. Category Label
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'ACTIVITY',
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Dynamic Setting Cards matching the screenshot in Light Mode
              _buildNotificationSettingCard(
                title: 'Daily Coaching',
                description: 'Get notifications that help you complete your Activity goals.',
                value: _dailyCoaching,
                onChanged: (val) {
                  setState(() {
                    _dailyCoaching = val;
                  });
                },
                switchColor: iosGreen,
              ),
              const SizedBox(height: 24),

              _buildNotificationSettingCard(
                title: 'Goal Completions',
                description: 'Receive a notification when you close your Move ring or earn an award.',
                value: _goalCompletions,
                onChanged: (val) {
                  setState(() {
                    _goalCompletions = val;
                  });
                },
                switchColor: iosGreen,
              ),
              const SizedBox(height: 24),

              _buildNotificationSettingCard(
                title: 'Activity Sharing',
                description: 'Receive a notification when someone who shares Activity with you completes a workout, or earns an award.',
                value: _activitySharing,
                onChanged: (val) {
                  setState(() {
                    _activitySharing = val;
                  });
                },
                switchColor: iosGreen,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Builder helper for a custom notification setting item card in Light Mode
  Widget _buildNotificationSettingCard({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color switchColor,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 1.5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CupertinoSwitch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: switchColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            description,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF636366),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
