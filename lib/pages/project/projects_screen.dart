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
  final _projectService = ProjectService();
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _projects = [];

  static const _statuses = ['OPEN', 'IN_PROGRESS', 'COMPLETED'];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      setState(() {
        _error = 'Не найден токен';
        _isLoading = false;
      });
      return;
    }

    try {
      final status = _statuses[_selectedTabIndex];
      _projects = await _projectService.fetchClientProjects(token, status: status);
    } catch (e) {
      _error = 'Ошибка при загрузке: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onAddProject() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const NewProjectStep1Screen()),
    );
    if (result != null) {
      if (_selectedTabIndex == 0) {
        setState(() => _projects.insert(0, result));
      }
    }
  }

  void _onTabChanged(int index) {
    setState(() => _selectedTabIndex = index);
    _loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body:
          _bottomNavIndex == 0
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
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    return Column(
      children: [
        AppBar(
          title: const Text(
            'Проекты',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          centerTitle: true,
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          elevation: 0,
          actions: [
            IconButton(icon: const Icon(Icons.add), onPressed: _onAddProject),
          ],
        ),

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Palette.dotInactive,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                _buildTab('Открытые', 0),
                _buildTab('В работе', 1),
                _buildTab('Архив', 2),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child:
              _projects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _projects.length,
                    itemBuilder: (_, i) => ProjectCard(project: _projects[i]),
                  ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final selected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Palette.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? Palette.black : Palette.thin,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final texts =
        [
          [
            'assets/projects.svg',
            'У вас пока нет открытых проектов',
            'Нажмите "Создать проект", чтобы начать!',
          ],
          [
            'assets/projects.svg',
            'У вас пока нет проектов в работе',
            'Нажмите "Создать проект", чтобы начать!',
          ],
          [
            'assets/archive.svg',
            'В архиве нет завершённых проектов',
            'Завершённые проекты будут отображаться здесь',
          ],
        ][_selectedTabIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(texts[0], height: 200),
            const SizedBox(height: 24),
            Text(
              texts[1],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              texts[2],
              style: const TextStyle(
                fontSize: 14,
                color: Palette.thin,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            if (_selectedTabIndex != 2) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onAddProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Создать проект',
                  style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
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
