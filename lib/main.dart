import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'provider/auth_provider.dart';
import 'util/routes.dart';
import 'package:jobsy/pages/onboarding/onboarding1.dart';
import 'package:jobsy/pages/onboarding/onboarding2.dart';
import 'package:jobsy/pages/onboarding/onboarding3.dart';
import 'package:jobsy/pages/onboarding/onboarding4.dart';
import 'package:jobsy/pages/auth/auth.dart';
import 'package:jobsy/pages/verification/verification_code_screen.dart';
import 'package:jobsy/pages/role/role_selection.dart';
import 'package:jobsy/pages/project/projects_screen.dart';
import 'package:jobsy/pages/project/projects_screen_free.dart';
import 'package:jobsy/pages/project/new_project_step1_screen.dart';
import 'package:jobsy/pages/project/new_project_step2_screen.dart';
import 'package:jobsy/pages/project/new_project_step3_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const JobsyApp(),
    ),
  );
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
      initialRoute: Routes.onboarding1,
      routes: {
        Routes.onboarding1: (context) => const OnboardingScreen1(),
        Routes.onboarding2: (context) => const OnboardingScreen2(),
        Routes.onboarding3: (context) => const OnboardingScreen3(),
        Routes.onboarding4: (context) => const OnboardingScreen4(),
        Routes.root: (context) => const AuthScreen(),
        Routes.auth: (context) => const AuthScreen(),
        Routes.verify: (context) => const VerificationCodeScreen(),
        Routes.role: (context) => const RoleSelectionScreen(),
        Routes.projects: (context) => const ProjectsScreen(),
        Routes.projectsFree: (context) => const ProjectsScreenFree(),
        '/create-project-step1': (context) => const NewProjectStep1Screen(),
        '/create-project-step2': (context) => const NewProjectStep2Screen(previousData: {}),
        '/create-project-step3': (context) => const NewProjectStep3Screen(previousData: {}),
      },
    );
  }
}
