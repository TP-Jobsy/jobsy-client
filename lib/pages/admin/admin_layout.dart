import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'top_bar.dart';

class AdminLayout extends StatelessWidget {
  final AdminSection currentSection;
  final Widget child;
  const AdminLayout({
    super.key,
    required this.currentSection,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(current: currentSection),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                const Divider(height:0, thickness:0),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}