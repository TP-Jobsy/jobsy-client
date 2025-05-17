import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/confirm_screen.dart';
import 'package:jobsy/pages/admin/login_page.dart';
import 'package:jobsy/pages/admin/portfolio_page.dart';
import 'package:jobsy/pages/admin/projects_page.dart';
import 'package:jobsy/pages/admin/users_screen.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jobsy_admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3F6BFF),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const AdminLoginPage(),
        '/confirm': (_) => const ConfirmScreen(email: '',),
        '/admin/users': (_) => const UsersPage(),
        '/admin/projects': (_) => const ProjectsPage(),
        '/admin/portfolio': (_) => const PortfolioPage(),
      },
    );
  }
}