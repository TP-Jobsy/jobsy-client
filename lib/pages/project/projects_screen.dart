import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/project_card.dart';
import '../../provider/auth_provider.dart';
import '../../service/project_service.dart';
import '../../util/pallete.dart';
import 'new_project_step1_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> openProjects = [];

  @override
  void initState() {
    super.initState();
    _loadMyProjects();
  }

  Future<void> _loadMyProjects() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      setState(() {
        _error = 'Не найден токен';
        _isLoading = false;
      });
      return;
    }
    try {
      final list = await ProjectService.fetchMyProjects(token: token, status: 'OPEN',);
      setState(() {
        openProjects = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToCreateProject() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const NewProjectStep1Screen()),
    );
    if (result != null) {
      setState(() => openProjects.insert(0, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: _bottomNavIndex == 0
          ? _buildProjectsBody()
          : Center(child: Text(_navLabel(_bottomNavIndex))),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
      ),
    );
  }

  Widget _buildProjectsBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    return Column(
      children: [
        AppBar(
          title: const Text('Проекты', style: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Inter'
          )),
          centerTitle: true,
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          elevation: 0,
          actions: [
            IconButton(icon: const Icon(Icons.add), onPressed: _navigateToCreateProject),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Palette.dotInactive,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                _buildTab(label: 'Открытые', index: 0),
                _buildTab(label: 'В работе', index: 1),
                _buildTab(label: 'Архив',   index: 2),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildTabContent()),
      ],
    );
  }Widget _buildTab({required String label, required int index}) {
    final selected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Palette.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        if (openProjects.isEmpty) {
          return _buildEmptyState(
            image: 'assets/projects.svg',
            title: 'У вас пока нет открытых проектов',
            subtitle: 'Нажмите "Создать проект", чтобы начать!',
            showButton: true,
          );
        }
        return ListView.builder(
          itemCount: openProjects.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (_, i) => ProjectCard(project: openProjects[i]),
        );
      case 1:
        return _buildEmptyState(
          image: 'assets/projects.svg',
          title: 'У вас пока нет проектов в работе',
          subtitle: 'Нажмите "Создать проект", чтобы начать!',
          showButton: true,
        );
      case 2:
        return _buildEmptyState(
          image: 'assets/archive.svg',
          title: 'В архиве нет завершённых проектов',
          subtitle: 'Завершённые проекты будут отображаться здесь',
          showButton: false,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState({
    required String image,
    required String title,
    required String subtitle,
    bool showButton = true,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(image, height: 300),
            const SizedBox(height: 24),
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'
                ),
                textAlign: TextAlign.center
            ),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 14,
                    color: Palette.thin,
                    fontFamily: 'Inter'
                ),
                textAlign: TextAlign.center
            ),
            if (showButton) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _navigateToCreateProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)
                  ),
                ),
                child: const Text('Создать проект',
                    style: TextStyle(color: Palette.white, fontFamily: 'Inter')
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _navLabel(int index) {
    switch (index) {
      case 1:
        return 'Поиск';
      case 2:
        return 'Избранное';
      case 3:
        return 'Профиль';
      default:
        return '';
    }
  }
}