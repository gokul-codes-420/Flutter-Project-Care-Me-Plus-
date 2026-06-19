import os

def replace_in_file(filepath, replacements):
    if not os.path.exists(filepath):
        print(f"Warning: File {filepath} does not exist.")
        return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    orig_content = content
    for old, new in replacements:
        content = content.replace(old, new)
        
    if content != orig_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Successfully updated {os.path.basename(filepath)}")
    else:
        print(f"No changes made to {os.path.basename(filepath)}")

def main():
    lib_dir = "lib"
    
    # 1. fitness_summary_page.dart
    replace_in_file(
        os.path.join(lib_dir, "fitness_summary_page.dart"),
        [
            (
                "    const Color cardBg = Color(0xFF1C1C1E); // Apple dark card background\n    const Color pageBg = Colors.black; // Apple dark scaffold background\n    const Color darkSlateText = Colors.white; // Primary dark text",
                "    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;\n    final Color cardBg = isDarkTheme ? const Color(0xFF1C1C1E) : Colors.white; // Dynamic card background\n    final Color pageBg = isDarkTheme ? Colors.black : const Color(0xFFF2F2F7); // Dynamic scaffold background\n    final Color darkSlateText = isDarkTheme ? Colors.white : const Color(0xFF1C1C1E); // Dynamic text color"
            ),
            (
                "      backgroundColor: const Color(0xFF1C1C1E), // Dark background",
                "      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white, // Dynamic background"
            ),
            (
                "        color: const Color(0xFF1C1C1E), // Dark Card Background",
                "        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white, // Dynamic Card Background"
            ),
            (
                "          backgroundColor: const Color(0xFF1C1C1E), // Dark background for Dialog",
                "          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white, // Dynamic background for Dialog"
            ),
            (
                "              color: const Color(0xFF2C2C2E),",
                "              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),"
            ),
            (
                "                  color: const Color(0xFF2C2C2E),",
                "                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),"
            )
        ]
    )

    # 2. fitness_personalize_page.dart
    replace_in_file(
        os.path.join(lib_dir, "fitness_personalize_page.dart"),
        [
            (
                "    const Color activeBlue = Color(0xFF3A5BDB);\n    const Color cardBg = Color(0xFF1C1C1E);",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    final Color activeBlue = const Color(0xFF3A5BDB);\n    final Color cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;"
            ),
            (
                "      backgroundColor: Colors.black, // iOS Dark Group Background",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7), // iOS Group Background"
            ),
            (
                "                  color: Colors.white,",
                "                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                  color: const Color(0xFF8E8E93),",
                "                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF636366),"
            ),
            (
                "                  backgroundColor: Colors.white, // Apple Premium White button",
                "                  backgroundColor: isDark ? Colors.white : const Color(0xFF1C1C1E), // Dynamic button background"
            ),
            (
                "                  foregroundColor: Colors.black,",
                "                  foregroundColor: isDark ? Colors.black : Colors.white,"
            ),
            # Bottom sheet Sex chooser adjustments to follow theme
            (
                "      backgroundColor: Colors.white,\n      shape: const RoundedRectangleBorder(\n        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),\n      ),\n      builder: (context) {\n        return SafeArea(\n          child: Padding(\n            padding: const EdgeInsets.symmetric(vertical: 20),\n            child: Column(\n              mainAxisSize: MainAxisSize.min,\n              children: [\n                const Text(\n                  'Select Sex',\n                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),\n                ),",
                "      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,\n      shape: const RoundedRectangleBorder(\n        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),\n      ),\n      builder: (context) {\n        final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;\n        return SafeArea(\n          child: Padding(\n            padding: const EdgeInsets.symmetric(vertical: 20),\n            child: Column(\n              mainAxisSize: MainAxisSize.min,\n              children: [\n                Text(\n                  'Select Sex',\n                  style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),\n                ),"
            ),
            (
                "  Widget _buildSexOption(String value) {\n    return ListTile(\n      title: Text(value, style: const TextStyle(color: Colors.black, fontSize: 16)),",
                "  Widget _buildSexOption(String value) {\n    final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;\n    return ListTile(\n      title: Text(value, style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 16)),"
            ),
            # Height Sheet dynamic adjustments
            (
                "      backgroundColor: Colors.white,\n      shape: const RoundedRectangleBorder(\n        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),\n      ),\n      builder: (context) {\n        return StatefulBuilder(\n          builder: (context, setModalState) {\n            return SafeArea(\n              child: Padding(\n                padding: const EdgeInsets.all(24.0),\n                child: Column(\n                  mainAxisSize: MainAxisSize.min,\n                  children: [\n                    const Text(\n                      'Select Height',\n                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),\n                    ),",
                "      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,\n      shape: const RoundedRectangleBorder(\n        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),\n      ),\n      builder: (context) {\n        final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;\n        return StatefulBuilder(\n          builder: (context, setModalState) {\n            return SafeArea(\n              child: Padding(\n                padding: const EdgeInsets.all(24.0),\n                child: Column(\n                  mainAxisSize: MainAxisSize.min,\n                  children: [\n                    Text(\n                      'Select Height',\n                      style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),\n                    ),"
            ),
            (
                "                      style: ElevatedButton.styleFrom(\n                        backgroundColor: const Color(0xFF1C1C1E),\n                        foregroundColor: Colors.white,",
                "                      style: ElevatedButton.styleFrom(\n                        backgroundColor: isSheetDark ? Colors.white : const Color(0xFF1C1C1E),\n                        foregroundColor: isSheetDark ? Colors.black : Colors.white,"
            ),
            # Weight Sheet dynamic adjustments
            (
                "      backgroundColor: Colors.white,\n      shape: const RoundedRectangleBorder(\n        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),\n      ),\n      builder: (context) {\n        return StatefulBuilder(\n          builder: (context, setModalState) {\n            return SafeArea(\n              child: Padding(\n                padding: const EdgeInsets.all(24.0),\n                child: Column(\n                  mainAxisSize: MainAxisSize.min,\n                  children: [\n                    const Text(\n                      'Select Weight',\n                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),\n                    ),",
                "      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,\n      shape: const RoundedRectangleBorder(\n        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),\n      ),\n      builder: (context) {\n        final bool isSheetDark = Theme.of(context).brightness == Brightness.dark;\n        return StatefulBuilder(\n          builder: (context, setModalState) {\n            return SafeArea(\n              child: Padding(\n                padding: const EdgeInsets.all(24.0),\n                child: Column(\n                  mainAxisSize: MainAxisSize.min,\n                  children: [\n                    Text(\n                      'Select Weight',\n                      style: TextStyle(color: isSheetDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),\n                    ),"
            )
        ]
    )

    # 3. daily_move_goal_page.dart
    replace_in_file(
        os.path.join(lib_dir, "daily_move_goal_page.dart"),
        [
            (
                "  Widget build(BuildContext context) {\n    const Color activePink = Color(0xFFFF2D55); // Premium vibrant iOS Fitness Move pink\n    const Color segmentBg = Color(0xFF1C1C1E);",
                "  Widget build(BuildContext context) {\n    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    const Color activePink = Color(0xFFFF2D55); // Premium vibrant iOS Fitness Move pink\n    final Color segmentBg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : Colors.white,"
            ),
            (
                "                        color: const Color(0xFF1C1C1E),",
                "                        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),"
            ),
            (
                "                          color: Colors.white,",
                "                          color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                style: TextStyle(\n                  color: Colors.white,",
                "                style: TextStyle(\n                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                style: TextStyle(\n                  color: Colors.white70,",
                "                style: TextStyle(\n                  color: isDark ? Colors.white70 : const Color(0xFF636366),"
            ),
            (
                "            color: isSelected ? const Color(0xFF2C2C2E) : Colors.transparent,",
                "            color: isSelected ? (isDark ? const Color(0xFF2C2C2E) : Colors.white) : Colors.transparent,"
            ),
            (
                "              color: isSelected ? Colors.white : const Color(0xFF8E8E93),",
                "              color: isSelected ? (isDark ? Colors.white : const Color(0xFF1C1C1E)) : const Color(0xFF8E8E93),"
            ),
            (
                "                  color: Colors.white,",
                "                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                  backgroundColor: Colors.white, // White button",
                "                  backgroundColor: isDark ? Colors.white : const Color(0xFF1C1C1E), // Dynamic button"
            ),
            (
                "                  foregroundColor: Colors.black,",
                "                  foregroundColor: isDark ? Colors.black : Colors.white,"
            )
        ]
    )

    # 4. fitness_notifications_page.dart
    replace_in_file(
        os.path.join(lib_dir, "fitness_notifications_page.dart"),
        [
            (
                "  Widget build(BuildContext context) {\n    const Color iosGreen = Color(0xFF34C759); // Standard iOS Green Switch Color\n\n    return Scaffold(\n      backgroundColor: Colors.black, // Apple's standard dark settings background",
                "  Widget build(BuildContext context) {\n    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    const Color iosGreen = Color(0xFF34C759); // Standard iOS Green Switch Color\n\n    return Scaffold(\n      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7), // Dynamic background"
            ),
            (
                "                        color: const Color(0xFF1C1C1E),",
                "                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                          color: Colors.white,",
                "                          color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                    color: Colors.white,",
                "                    color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "            color: const Color(0xFF1C1C1E),",
                "            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                  color: Colors.white,",
                "                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "              color: Colors.white70,",
                "              color: isDark ? Colors.white70 : const Color(0xFF636366),"
            )
        ]
    )

    # 5. awards_page.dart
    replace_in_file(
        os.path.join(lib_dir, "awards_page.dart"),
        [
            (
                "    const Color activeGreen = Color(0xFF38D430); // Apple active green\n    const Color darkSlateText = Colors.white;\n    const Color slateGraySubdued = Colors.white70;\n    const Color cardBg = Color(0xFF1C1C1E);",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    const Color activeGreen = Color(0xFF38D430); // Apple active green\n    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);\n    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);\n    final Color cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "                          color: const Color(0xFF1C1C1E),",
                "                          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                          border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                          border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            ),
            (
                "                      border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                      border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            ),
            (
                "                        const Divider(color: Color(0xFF2C2C2E), height: 1),",
                "                        Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1),"
            ),
            (
                "                            border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                            border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            ),
            (
                "                              const Divider(color: Color(0xFF2C2C2E), height: 1),",
                "                              Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1),"
            ),
            (
                "        colors: [Color(0xFF1C1C1E), Colors.black],",
                "        colors: isDark ? [Color(0xFF1C1C1E), Colors.black] : [Colors.white, const Color(0xFFF2F2F7)],"
            ),
            (
                "      ..color = const Color(0xFF3A3A3C) // Subdued Dark Mode outline grey",
                "      ..color = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC) // Wireframe outline"
            )
        ]
    )

    # 6. award_details_page.dart
    replace_in_file(
        os.path.join(lib_dir, "award_details_page.dart"),
        [
            (
                "    const Color darkSlateText = Colors.white;\n    const Color slateGraySubdued = Colors.white70;",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);\n    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "                        color: const Color(0xFF1C1C1E),",
                "                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                        border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                        border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            )
        ]
    )

    # 7. monthly_challenge_details_page.dart
    replace_in_file(
        os.path.join(lib_dir, "monthly_challenge_details_page.dart"),
        [
            (
                "    const Color darkSlateText = Colors.white;\n    const Color slateGraySubdued = Colors.white70;",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);\n    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "                        color: const Color(0xFF1C1C1E),",
                "                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                        border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                        border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            )
        ]
    )

    # 8. workout_details_page.dart
    replace_in_file(
        os.path.join(lib_dir, "workout_details_page.dart"),
        [
            (
                "    const Color darkSlateText = Colors.white;\n    const Color slateGraySubdued = Colors.white70;",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);\n    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "                        color: const Color(0xFF1C1C1E),",
                "                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                        border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                        border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            )
        ]
    )

    # 9. go_for_it_page.dart
    replace_in_file(
        os.path.join(lib_dir, "go_for_it_page.dart"),
        [
            (
                "    const Color darkSlateText = Colors.white;\n    const Color slateGraySubdued = Colors.white70;\n    const Color activeGreen = Color(0xFF38D430);",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    const Color activeGreen = Color(0xFF38D430);\n    final Color darkSlateText = isDark ? Colors.white : const Color(0xFF1C1C1E);\n    final Color slateGraySubdued = isDark ? Colors.white70 : const Color(0xFF8E8E93);"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "                        color: const Color(0xFF1C1C1E),",
                "                        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                        border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                        border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            ),
            (
                "                  decoration: BoxDecoration(\n                    color: const Color(0xFF1C1C1E),",
                "                  decoration: BoxDecoration(\n                    color: isDark ? const Color(0xFF1C1C1E) : Colors.white,"
            ),
            (
                "                    border: Border.all(color: const Color(0xFF2C2C2E), width: 1),",
                "                    border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1),"
            ),
            (
                "              color: const Color(0xFF2C2C2E), // Dark Gray track",
                "              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), // track"
            ),
            (
                "..color = const Color(0xFF3A3A3C) // Wireframe outline grey",
                "..color = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC) // outline grey"
            ),
            (
                "..color = const Color(0xFF3A3A3C)",
                "..color = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC7C7CC)"
            ),
            (
                "          color: Color(0xFFC7C7CC),",
                "          color: isDark ? Color(0xFFC7C7CC) : Color(0xFF8E8E93),"
            )
        ]
    )

    # 10. onboarding_landing_page.dart
    replace_in_file(
        os.path.join(lib_dir, "onboarding_landing_page.dart"),
        [
            (
                "  Widget build(BuildContext context) {\n    const Color limeGreen = Color(0xFF9EFF00); // Premium iOS Fitness lime green\n\n    return Scaffold(\n      backgroundColor: Colors.black,",
                "  Widget build(BuildContext context) {\n    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    const Color limeGreen = Color(0xFF9EFF00); // Premium iOS Fitness lime green\n\n    return Scaffold(\n      backgroundColor: isDark ? Colors.black : Colors.white,"
            ),
            (
                "                  colors: [\n                    Colors.black.withAlpha(20),\n                    Colors.black.withAlpha(180),\n                    Colors.black,",
                "                  colors: [\n                    (isDark ? Colors.black : Colors.white).withAlpha(20),\n                    (isDark ? Colors.black : Colors.white).withAlpha(180),\n                    isDark ? Colors.black : Colors.white,"
            ),
            (
                "                          decoration: BoxDecoration(\n                            color: Colors.black.withAlpha(220),",
                "                          decoration: BoxDecoration(\n                            color: (isDark ? Colors.black : Colors.white).withAlpha(220),"
            ),
            (
                "                            border: Border.all(\n                              color: const Color(0xFF2C2C2E),",
                "                            border: Border.all(\n                              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                color: Colors.white70,",
                "                                color: isDark ? Colors.white70 : const Color(0xFF48484A),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                              color: Colors.white70,",
                "                              color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                              color: Colors.white,",
                "                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                                color: Colors.white,",
                "                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                                    color: Colors.white70,",
                "                                    color: isDark ? Colors.white70 : const Color(0xFF8E8E93),"
            ),
            (
                "                            color: isActive ? Colors.white : const Color(0xFF48484A), // White for active, dark grey for inactive",
                "                            color: isActive ? (isDark ? Colors.white : const Color(0xFF1C1C1E)) : (isDark ? const Color(0xFF48484A) : const Color(0xFFD1D1D6)),"
            )
        ]
    )

    # 11. success_page.dart
    replace_in_file(
        os.path.join(lib_dir, "success_page.dart"),
        [
            (
                "  Widget build(BuildContext context) {\n    // Retreiving signed in email from arguments\n    final String email = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';\n\n    return Scaffold(\n      backgroundColor: Colors.black,",
                "  Widget build(BuildContext context) {\n    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    // Retreiving signed in email from arguments\n    final String email = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';\n\n    return Scaffold(\n      backgroundColor: isDark ? Colors.black : Colors.white,"
            ),
            (
                "                style: TextStyle(\n                  color: Colors.white,",
                "                style: TextStyle(\n                  color: isDark ? Colors.white : Colors.black87,"
            ),
            (
                "                style: TextStyle(\n                  color: Colors.white70,",
                "                style: TextStyle(\n                  color: isDark ? Colors.white70 : Colors.grey[600],"
            )
        ]
    )

    # 12. fitness_welcome_page.dart
    replace_in_file(
        os.path.join(lib_dir, "fitness_welcome_page.dart"),
        [
            (
                "  Widget build(BuildContext context) {\n    return Scaffold(\n      backgroundColor: Colors.black,",
                "  Widget build(BuildContext context) {\n    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    return Scaffold(\n      backgroundColor: isDark ? Colors.black : Colors.white,"
            ),
            (
                "                style: TextStyle(\n                  color: Colors.white,",
                "                style: TextStyle(\n                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                style: const TextStyle(\n                  color: Colors.white,",
                "                style: TextStyle(\n                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                style: const TextStyle(\n                  color: Colors.white.withAlpha(160),",
                "                style: TextStyle(\n                  color: isDark ? Colors.white.withAlpha(160) : const Color(0xFF636366),"
            ),
            (
                "                  backgroundColor: Colors.white, // Sleek white button\n                  foregroundColor: Colors.black,",
                "                  backgroundColor: isDark ? Colors.white : const Color(0xFF1C1C1E), // Dynamic button\n                  foregroundColor: isDark ? Colors.black : Colors.white,"
            ),
            (
                "                  style: TextStyle(\n                    color: isDark ? Colors.white : const Color(0xFF1C1C1E),",
                "                  style: TextStyle(\n                    color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            )
        ]
    )

    # 13. google_mock_page.dart
    replace_in_file(
        os.path.join(lib_dir, "google_mock_page.dart"),
        [
            (
                "  Widget build(BuildContext context) {\n    // Standard beautiful mock Google Accounts page\n    final List<Map<String, String>> mockAccounts = [",
                "  Widget build(BuildContext context) {\n    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    // Standard beautiful mock Google Accounts page\n    final List<Map<String, String>> mockAccounts = ["
            ),
            (
                "    return Scaffold(\n      backgroundColor: const Color(0xFF202124),",
                "    return Scaffold(\n      backgroundColor: isDark ? const Color(0xFF202124) : const Color(0xFFF2F2F2),"
            ),
            (
                "            decoration: BoxDecoration(\n              color: const Color(0xFF303134),",
                "            decoration: BoxDecoration(\n              color: isDark ? const Color(0xFF303134) : Colors.white,"
            ),
            (
                "                  color: Colors.black.withAlpha(40),",
                "                  color: Colors.black.withAlpha(isDark ? 40 : 20),"
            ),
            (
                "                  style: TextStyle(\n                    fontSize: 22,\n                    fontWeight: FontWeight.w400,\n                    color: Colors.white,",
                "                  style: TextStyle(\n                    fontSize: 22,\n                    fontWeight: FontWeight.w400,\n                    color: isDark ? Colors.white : Colors.black87,"
            ),
            (
                "                    text: 'to continue to ',\n                    style: TextStyle(color: Colors.white70, fontSize: 14),",
                "                    text: 'to continue to ',\n                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14),"
            ),
            (
                "                                      style: const TextStyle(\n                                        fontSize: 14,\n                                        fontWeight: FontWeight.w600,\n                                        color: Colors.white,",
                "                                      style: TextStyle(\n                                        fontSize: 14,\n                                        fontWeight: FontWeight.w600,\n                                        color: isDark ? Colors.white : Colors.black87,"
            ),
            (
                "                                      style: const TextStyle(\n                                        fontSize: 13,\n                                        color: Colors.white70,",
                "                                      style: TextStyle(\n                                        fontSize: 13,\n                                        color: isDark ? Colors.white70 : Colors.black54,"
            ),
            (
                "                 const Divider(height: 24, thickness: 0.8, color: Color(0xFF3C4043)),",
                "                 Divider(height: 24, thickness: 0.8, color: isDark ? const Color(0xFF3C4043) : const Color(0xFFE5E5EA)),"
            ),
            (
                "                          backgroundColor: Colors.grey[800],",
                "                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],"
            ),
            (
                "                            color: Colors.white70,",
                "                            color: isDark ? Colors.white70 : Colors.black54,"
            ),
            (
                "                          style: TextStyle(\n                            fontSize: 14,\n                            fontWeight: FontWeight.w500,\n                            color: Colors.white,",
                "                          style: TextStyle(\n                            fontSize: 14,\n                            fontWeight: FontWeight.w500,\n                            color: isDark ? Colors.white : Colors.black87,"
            ),
            (
                "                    color: Colors.grey[400],",
                "                    color: isDark ? Colors.grey[400] : Colors.grey[600],"
            )
        ]
    )

    # 14. login_page.dart
    replace_in_file(
        os.path.join(lib_dir, "login_page.dart"),
        [
            (
                "    const Color limeGreen = Color(0xFF9EFF00); // Vibrant neon lime green\n    const Color cardBg = Color(0xFF1C1C1E); // Apple dark card background\n    const Color inputBg = Color(0xFF2C2C2E); // Dark input background\n    const Color linkColor = Color(0xFF3A5BDB); // High contrast premium blue for links",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    const Color limeGreen = Color(0xFF9EFF00); // Vibrant neon lime green\n    final Color cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white; // Dynamic card background\n    final Color inputBg = isDark ? const Color(0xFF2C2C2E) : Colors.white; // Dynamic input background\n    const Color linkColor = Color(0xFF3A5BDB); // High contrast premium blue for links"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "                        style: TextStyle(\n                          color: Colors.white, ",
                "                        style: TextStyle(\n                          color: isDark ? Colors.white : const Color(0xFF1C1C1E), "
            ),
            (
                "                        style: TextStyle(\n                          color: Colors.white70,",
                "                        style: TextStyle(\n                          color: isDark ? Colors.white70 : const Color(0xFF6C6C70),"
            ),
            (
                "                        style: TextStyle(\n                          color: Colors.white, \n                          fontSize: 30,",
                "                        style: TextStyle(\n                          color: isDark ? Colors.white : const Color(0xFF1C1C1E), \n                          fontSize: 30,"
            ),
            (
                "                        style: TextStyle(\n                          color: Colors.white70,\n                          fontSize: 14.5,",
                "                        style: TextStyle(\n                          color: isDark ? Colors.white70 : const Color(0xFF6C6C70),\n                          fontSize: 14.5,"
            ),
            (
                "                        iconWidget: const Icon(Icons.apple_rounded, color: Colors.white, size: 22),",
                "                        iconWidget: Icon(Icons.apple_rounded, color: isDark ? Colors.white : Colors.black, size: 22),"
            ),
            (
                "                          const Expanded(child: Divider(color: Color(0xFF2C2C2E), height: 1)),",
                "                          Expanded(child: Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1)),"
            ),
            (
                "                          const Expanded(child: Divider(color: Color(0xFF2C2C2E), height: 1)),",
                "                          Expanded(child: Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1)),"
            ),
            (
                "                        style: const TextStyle(color: Colors.white,  fontSize: 15),",
                "                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  fontSize: 15),"
            ),
            (
                "                            borderSide: const BorderSide(color: Color(0xFF2C2C2E), width: 1.2),",
                "                            borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),"
            ),
            (
                "                            borderSide: const BorderSide(color: Colors.white,  width: 1.5),",
                "                            borderSide: BorderSide(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  width: 1.5),"
            ),
            (
                "                  border: Border.all(color: const Color(0xFF2C2C2E), width: 1.2),",
                "                  border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),"
            ),
            (
                "              color: Colors.white,",
                "              color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            )
        ]
    )

    # 15. signup_page.dart
    replace_in_file(
        os.path.join(lib_dir, "signup_page.dart"),
        [
            (
                "    const Color limeGreen = Color(0xFF9EFF00); // Premium neon lime green\n    const Color inputBg = Color(0xFF2C2C2E); // Dark input background\n    const Color linkColor = Color(0xFF3A5BDB);",
                "    final bool isDark = Theme.of(context).brightness == Brightness.dark;\n    const Color limeGreen = Color(0xFF9EFF00); // Premium neon lime green\n    final Color inputBg = isDark ? const Color(0xFF2C2C2E) : Colors.white; // Dynamic input background\n    const Color linkColor = Color(0xFF3A5BDB);"
            ),
            (
                "      backgroundColor: Colors.black,",
                "      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "        backgroundColor: Colors.black,",
                "        backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),"
            ),
            (
                "          icon: const Icon(\n            Icons.arrow_back_rounded, \n            color: Colors.white,",
                "          icon: Icon(\n            Icons.arrow_back_rounded, \n            color: isDark ? Colors.white : const Color(0xFF1C1C1E),"
            ),
            (
                "                style: TextStyle(\n                  color: Colors.white, ",
                "                style: TextStyle(\n                  color: isDark ? Colors.white : const Color(0xFF1C1C1E), "
            ),
            (
                "                style: TextStyle(\n                  color: Colors.white70,",
                "                style: TextStyle(\n                  color: isDark ? Colors.white70 : const Color(0xFF6C6C70),"
            ),
            (
                "                  style: const TextStyle(color: Colors.white,  fontSize: 15),",
                "                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  fontSize: 15),"
            ),
            (
                "                      borderSide: const BorderSide(color: Color(0xFF2C2C2E), width: 1.2),",
                "                      borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),"
            ),
            (
                "                      borderSide: const BorderSide(color: Colors.white,  width: 1.5),",
                "                      borderSide: BorderSide(color: isDark ? Colors.white : const Color(0xFF1C1C1E),  width: 1.5),"
            ),
            (
                "                          color: _agreeToTerms ? limeGreen : Colors.transparent,",
                "                          color: _agreeToTerms ? limeGreen : Colors.transparent,"
            ),
            (
                "                            color: _agreeToTerms ? limeGreen : const Color(0xFF48484A),",
                "                            color: _agreeToTerms ? limeGreen : (isDark ? const Color(0xFF48484A) : const Color(0xFFD1D1D6)),"
            ),
            (
                "                    const Expanded(child: Divider(color: Color(0xFF2C2C2E), height: 1)),",
                "                    Expanded(child: Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1)),"
            ),
            (
                "                    const Expanded(child: Divider(color: Color(0xFF2C2C2E), height: 1)),",
                "                    Expanded(child: Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), height: 1)),"
            ),
            (
                "                        style: TextStyle(color: Colors.white70, fontSize: 13),",
                "                        style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF6C6C70), fontSize: 13),"
            ),
            (
                "                      iconWidget: const Icon(Icons.apple_rounded, color: Colors.white, size: 24),",
                "                      iconWidget: Icon(Icons.apple_rounded, color: isDark ? Colors.white : Colors.black, size: 24),"
            ),
            (
                "          border: Border.all(color: const Color(0xFF2C2C2E), width: 1.2),",
                "          border: Border.all(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA), width: 1.2),"
            )
        ]
    )

if __name__ == "__main__":
    main()
