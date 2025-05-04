import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'top_bar.dart';

class AdminLayout extends StatelessWidget {
  final AdminSection currentSection;
  final Widget child;
  const AdminLayout({
    Key? key,
    required this.currentSection,
    required this.child,
  }) : super(key: key);

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
                const Divider(height:1, thickness:1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 40, 50, 85),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}