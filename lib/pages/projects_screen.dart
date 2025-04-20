import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'new_project_step1_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProjectsHome(),
    const SearchScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.favorite_border,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2E33),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isSelected = index == _selectedIndex;

            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _icons[index],
                  color: Colors.white,
                  size: isSelected ? 26 : 22,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ProjectsHome extends StatefulWidget {
  const ProjectsHome({super.key});

  @override
  State<ProjectsHome> createState() => _ProjectsHomeState();
}

class _ProjectsHomeState extends State<ProjectsHome> {
  int selectedTabIndex = 0;

  void _navigateToCreateProject() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewProjectStep1Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Проекты', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateProject,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEEF4),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  _buildTab(label: 'Открытые', index: 0),
                  _buildTab(label: 'В работе', index: 1),
                  _buildTab(label: 'Архив', index: 2),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTab({required String label, required int index}) {
    final selected = selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildEmptyState(
          image: 'assets/projects.svg',
          title: 'У вас пока нет открытых проектов',
          subtitle: 'Нажмите "Создать проект", чтобы начать!',
        );
      case 1:
        return _buildEmptyState(
          image: 'assets/progress.svg',
          title: 'У вас пока нет проектов в работе',
          subtitle: 'Нажмите "Создать проект", чтобы начать!',
        );
      case 2:
        return _buildEmptyState(
          image: 'assets/archive.svg',
          title: 'В архиве нет завершённых проектов',
          subtitle: 'Завершённые проекты будут отображаться здесь',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(image, height: 300),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _navigateToCreateProject,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          child: const Text(
            'Создать проект',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Поиск')),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Избранное')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Профиль')),
    );
  }
}