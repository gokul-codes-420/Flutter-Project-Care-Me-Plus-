import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'google_mock_page.dart';
import 'success_page.dart';
import 'fitness_welcome_page.dart';
import 'fitness_personalize_page.dart';
import 'daily_move_goal_page.dart';
import 'fitness_notifications_page.dart';
import 'fitness_summary_page.dart';
import 'onboarding_landing_page.dart';
import 'activity_details_page.dart';
import 'step_details_page.dart';
import 'step_distance_page.dart';
import 'sessions_page.dart';
import 'trends_page.dart';
import 'awards_page.dart';
import 'go_for_it_page.dart';
import 'award_details_page.dart';
import 'monthly_challenge_details_page.dart';
import 'workout_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId: '504000387893-v2n05ejvvnpkhr90vd6dfj0uv0f9j0p0.apps.googleusercontent.com',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Care +',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A5BDB),
          brightness: Brightness.light,
          primary: const Color(0xFF3A5BDB),
          secondary: const Color(0xFF3CD49B),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Premium, clean Sans-serif font
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A5BDB),
          brightness: Brightness.dark,
          primary: const Color(0xFF3A5BDB),
          secondary: const Color(0xFF3CD49B),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Premium, clean Sans-serif font
      ),
      themeMode: ThemeMode.dark, // Force the entire app to dark mode
      initialRoute: '/onboarding',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/onboarding':
            page = const OnboardingLandingPage();
            break;
          case '/login':
            page = const LoginPage();
            break;
          case '/signup':
            page = const SignUpPage();
            break;
          case '/fitness-welcome':
            page = const FitnessWelcomePage();
            break;
          case '/fitness-personalize':
            page = const FitnessPersonalizePage();
            break;
          case '/daily-move-goal':
            page = const DailyMoveGoalPage();
            break;
          case '/fitness-notifications':
            page = const FitnessNotificationsPage();
            break;
          case '/google-mock':
            final email = settings.arguments as String? ?? '';
            page = GoogleMockPage(emailInput: email);
            break;
          case '/success':
            page = const SuccessPage();
            break;
          case '/fitness-summary':
            final calories = settings.arguments as int? ?? 120;
            page = FitnessSummaryPage(calorieTarget: calories);
            break;
          case '/activity-details':
            final calories = settings.arguments as int? ?? 120;
            page = ActivityDetailsPage(calorieTarget: calories);
            break;
          case '/step-details':
            page = const StepDetailsPage();
            break;
          case '/step-distance':
            page = const StepDistancePage();
            break;
          case '/sessions':
            page = const SessionsPage();
            break;
          case '/trends':
            page = const TrendsPage();
            break;
          case '/awards':
            page = const AwardsPage();
            break;
          case '/go_for_it':
            page = const GoForItPage();
            break;
          case '/award_details':
            page = const AwardDetailsPage();
            break;
          case '/monthly_challenge_details':
            page = const MonthlyChallengeDetailsPage();
            break;
          case '/workout_details':
            page = const WorkoutDetailsPage();
            break;
          default:
            return null;
        }

        return PremiumPageRoute(
          child: page,
          settings: settings,
        );
      },
    );
  }
}

// Centered premium custom page transition route for the entire application
class PremiumPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  PremiumPageRoute({required this.child, super.settings})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // High-fidelity smooth scale-in and fade transition using easeOutCubic curve
            final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );
            final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        );
}
