import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/palette.dart';
import '../util/routes.dart';
import '../viewmodels/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 1), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    final auth = context.read<AuthProvider>();

    String nextRoute;
    if (!seenOnboarding) {
      nextRoute = Routes.onboarding1;
    } else if (!auth.isLoggedIn) {
      nextRoute = Routes.auth;
    } else if (auth.role == 'CLIENT') {
      nextRoute = Routes.projects;
    } else {
      nextRoute = Routes.projectsFree;
    }

    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
