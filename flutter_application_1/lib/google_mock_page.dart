import 'package:flutter/material.dart';

class GoogleMockPage extends StatelessWidget {
  final String emailInput;
  static Map<String, String>? selectedAccount;
  
  const GoogleMockPage({
    super.key,
    required this.emailInput,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final List<Map<String, String>> mockAccounts = [
      {
        'name': 'Gokul Santh',
        'email': emailInput.isNotEmpty ? emailInput : 'gokulsanth@gmail.com',
        'initial': 'G',
        'color': '0xFF3A5BDB'
      },
      {
        'name': 'Lupe Murazik',
        'email': 'murazik_lupe@miller.us',
        'initial': 'L',
        'color': '0xFF3CD49B'
      },
      {
        'name': 'Work Profile',
        'email': 'gokul.work@healthcare.org',
        'initial': 'W',
        'color': '0xFFF4B400'
      }
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF202124) : const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF303134) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 40 : 20),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Google Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'G',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                    Text(
                      'o',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[600],
                      ),
                    ),
                    Text(
                      'o',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[700],
                      ),
                    ),
                    Text(
                      'g',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                    Text(
                      'l',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                    Text(
                      'e',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose an account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'to continue to ',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14),
                    children: const [
                      TextSpan(
                        text: 'Health Care +',
                        style: TextStyle(
                          color: Color(0xFF3A5BDB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                
                // Account list
                Column(
                  children: mockAccounts.map((account) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        onTap: () {
                          selectedAccount = account;
                          // Go straight into the project (/fitness-welcome)
                          Navigator.pushReplacementNamed(
                            context, 
                            '/fitness-welcome',
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(int.parse(account['color']!)),
                                radius: 18,
                                child: Text(
                                  account['initial']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      account['name']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      account['email']!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark ? Colors.white70 : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const Divider(height: 24, thickness: 0.8, color: Color(0xFF3C4043)),
                
                // Use another account
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          radius: 18,
                          child: Icon(
                            Icons.person_add_alt_1_outlined,
                            color: isDark ? Colors.white70 : Colors.black54,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Use another account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  'To continue, Google will share your name, email address, profile picture, and preference with Health Care +.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
