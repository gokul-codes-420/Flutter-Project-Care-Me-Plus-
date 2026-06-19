import 'package:flutter/material.dart';
import 'dart:ui';

class FitnessPersonalizePage extends StatefulWidget {
  const FitnessPersonalizePage({super.key});

  @override
  State<FitnessPersonalizePage> createState() => _FitnessPersonalizePageState();
}

class _FitnessPersonalizePageState extends State<FitnessPersonalizePage> {
  String _dob = 'Not Set';
  String _sex = 'Not Set';
  String _height = 'Not Set';
  String _weight = 'Not Set';

  // Open Date Picker
  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3A5BDB), // Premium Blue
              onPrimary: Colors.white,
              surface: Color(0xFF1C1C1E),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3A5BDB),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dob = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  // Open Sex Chooser Bottom Sheet
  void _selectSex() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Sex',
                  style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSexOption('Female'),
                _buildSexOption('Male'),
                _buildSexOption('Other'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSexOption(String value) {
    final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      title: Text(value, style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 16)),
      onTap: () {
        setState(() {
          _sex = value;
        });
        Navigator.pop(context);
      },
    );
  }

  // Open Height Chooser Sheet
  void _selectHeight() {
    int selectedHeight = _height == 'Not Set' ? 170 : int.parse(_height.replaceAll(' cm', ''));
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Height',
                      style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$selectedHeight cm',
                      style: const TextStyle(color: Color(0xFF3A5BDB), fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: selectedHeight.toDouble(),
                      min: 100,
                      max: 230,
                      activeColor: const Color(0xFF3A5BDB),
                      inactiveColor: const Color(0xFF2C2C2E),
                      onChanged: (val) {
                        setModalState(() {
                          selectedHeight = val.round();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _height = '$selectedHeight cm';
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSheetDark ? Colors.white : const Color(0xFF1C1C1E),
                        foregroundColor: isSheetDark ? Colors.black : Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Set Height'),
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

  // Open Weight Chooser Sheet
  void _selectWeight() {
    int selectedWeight = _weight == 'Not Set' ? 65 : int.parse(_weight.replaceAll(' kg', ''));
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Weight',
                      style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$selectedWeight kg',
                      style: const TextStyle(color: Color(0xFF3A5BDB), fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: selectedWeight.toDouble(),
                      min: 30,
                      max: 180,
                      activeColor: const Color(0xFF3A5BDB),
                      inactiveColor: const Color(0xFF2C2C2E),
                      onChanged: (val) {
                        setModalState(() {
                          selectedWeight = val.round();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _weight = '$selectedWeight kg';
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSheetDark ? Colors.white : const Color(0xFF1C1C1E),
                        foregroundColor: isSheetDark ? Colors.black : Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Set Weight'),
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

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color activeBlue = const Color(0xFF3A5BDB);
    final Color cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7), // iOS Group Background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Main Heading
              Text(
                'Personalize Fitness and Health',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              const Text(
                'This information ensures Fitness and Health data are as accurate as possible. These details are not shared with Apple.',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              
              // List Box Container
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildRowItem(
                      label: 'Date of Birth',
                      value: _dob,
                      onTap: _selectDateOfBirth,
                    ),
                    Divider(height: 1, color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), indent: 16, endIndent: 16),
                    _buildRowItem(
                      label: 'Sex',
                      value: _sex,
                      onTap: _selectSex,
                    ),
                    Divider(height: 1, color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), indent: 16, endIndent: 16),
                    _buildRowItem(
                      label: 'Height',
                      value: _height,
                      onTap: _selectHeight,
                    ),
                    Divider(height: 1, color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), indent: 16, endIndent: 16),
                    _buildRowItem(
                      label: 'Weight',
                      value: _weight,
                      onTap: _selectWeight,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Add a Pregnancy Container
              InkWell(
                onTap: () {
                  _showCustomPremiumDialog(
                    context: context,
                    title: 'Pregnancy Logged',
                    message: 'Pregnancy tracking activated! Your details will be synchronized with Health.',
                    icon: Icons.favorite_rounded,
                    iconColor: Colors.purpleAccent,
                    buttonText: 'Got It',
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Add a Pregnancy in Health',
                    style: TextStyle(
                      color: activeBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Dark Grey Continue Button
              ElevatedButton(
                onPressed: () {
                  if (_dob == 'Not Set' ||
                      _sex == 'Not Set' ||
                      _height == 'Not Set' ||
                      _weight == 'Not Set') {
                    _showCustomPremiumDialog(
                      context: context,
                      title: 'Personalization Required',
                      message: 'Please personalize all health details (DOB, Sex, Height, Weight) to continue.',
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFFF453A), // iOS Premium Red
                      buttonText: 'Got It',
                    );
                    return;
                  }

                  _showCustomPremiumDialog(
                    context: context,
                    title: 'Profile Customized',
                    message: 'Your personalized health and fitness profile is fully set up!',
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: const Color(0xFF38D430), // Crisp Green
                    buttonText: 'Continue',
                    onButtonPressed: () {
                      Navigator.pushNamed(context, '/daily-move-goal');
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : const Color(0xFF1C1C1E), // Dynamic button background
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

  // Stylish, high-fidelity premium custom center dialog with frosted glass blur
  void _showCustomPremiumDialog({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    required String buttonText,
    Color? buttonColor,
    VoidCallback? onButtonPressed,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss Alert',
      barrierColor: Colors.black.withAlpha(89), // 0.35 opacity
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, anim2, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        // Highly refined spring scale + fade transition
        final curvedValue = Curves.easeOutBack.transform(anim.value);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12 * anim.value, sigmaY: 12 * anim.value),
          child: Transform.scale(
            scale: 0.92 + 0.08 * curvedValue,
            child: Opacity(
              opacity: anim.value,
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E).withAlpha(245) : Colors.white.withAlpha(245), // 0.96 opacity
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10), // 0.04 opacity
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withAlpha(40) : Colors.black.withAlpha(20), // opacity
                        blurRadius: 30,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modern Embedded Squircle Icon Container
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: iconColor.withAlpha(23), // 0.09 opacity
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: iconColor.withAlpha(38), // 0.15 opacity
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Title Text
                      Text(
                        title,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Message Text
                      Text(
                        message,
                        style: const TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 14.5,
                          height: 1.45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Sleek, Clean Filled Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Dismiss dialog
                            if (onButtonPressed != null) {
                              onButtonPressed();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor ?? iconColor,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRowItem({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: value == 'Not Set'
                        ? (isDark ? const Color(0xFF48484A) : const Color(0xFF8E8E93))
                        : const Color(0xFF0A84FF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFC7C7CC),
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
