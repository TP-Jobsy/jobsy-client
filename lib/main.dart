import 'package:flutter/material.dart';

// Onboarding
import 'package:jobsy/pages/onboarding/onboarding1.dart';
import 'package:jobsy/pages/onboarding/onboarding2.dart';
import 'package:jobsy/pages/onboarding/onboarding3.dart';
import 'package:jobsy/pages/onboarding/onboarding4.dart';

// Auth & Role
import 'package:jobsy/pages/auth/auth.dart';
import 'package:jobsy/pages/verification_code_screen.dart';
import 'package:jobsy/pages/role_selection.dart';

// Main app
import 'package:jobsy/pages/project/projects_screen.dart';
import 'package:jobsy/pages/projects_screen_free.dart';


// Project steps
import 'package:jobsy/pages/project/new_project_step1_screen.dart';
import 'package:jobsy/pages/project/new_project_step2_screen.dart';
import 'package:jobsy/pages/project/new_project_step3_screen.dart';
import 'package:jobsy/pages/project/new_project_step4_screen.dart';
import 'package:jobsy/pages/search_project.dart';

void main() {
  runApp(const JobsyApp());
}

class JobsyApp extends StatelessWidget {
  const JobsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jobsy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/onboarding1',
      routes: {
        // Onboarding
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/onboarding3': (context) => const OnboardingScreen3(),
        '/onboarding4': (context) => const OnboardingScreen4(),

        // Auth & Verification
        '/': (context) => const AuthScreen(),
        '/verify': (context) => const VerificationCodeScreen(),
        '/role': (context) => const RoleSelectionScreen(),

        // Main app
        '/projects': (context) => const ProjectsScreen(),
        '/projects1': (context) => const ProjectsScreenFree(),


        // Project creation flow
        '/create-project-step1': (context) => const NewProjectStep1Screen(),
        '/create-project-step2': (context) => const NewProjectStep2Screen(
          previousData: {}, // заглушка, если нужно использовать pushNamed
        ),
        '/create-project-step3': (context) => const NewProjectStep3Screen(
          previousData: {}, // заглушка, если нужно использовать pushNamed
        ),
        '/create-search-project': (context) => const SearchProject(
        ),
      },
    );
  }
}
