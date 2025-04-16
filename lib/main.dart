import 'package:flutter/material.dart';

import 'package:jobsy/pages/onboarding1.dart';
import 'package:jobsy/pages/onboarding2.dart';
import 'package:jobsy/pages/onboarding3.dart';
import 'package:jobsy/pages/onboarding4.dart';
import 'package:jobsy/pages/role_selection.dart';

import 'package:jobsy/pages/auth.dart'; // содержит AuthScreen

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
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/onboarding3': (context) => const OnboardingScreen3(),
        '/onboarding4': (context) => const OnboardingScreen4(),
    
        '/': (context) => const AuthScreen(),
        '/role': (context) => const RoleSelectionScreen(),
      },
      
    );
  }
}
