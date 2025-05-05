import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/pages/project/project_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../component/project_card.dart';
import '../../provider/auth_provider.dart';
import '../../provider/client_profile_provider.dart';
import '../../service/project_service.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import 'new_project/new_project_step1_screen.dart';

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

  get ErrorSnakbar => null;

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
      final profile =
          Provider.of<ClientProfileProvider>(context, listen: false).profile;
      final projects = await _projectService.fetchClientProjects(
        token,
        status: status,
      );

      // Добавляем информацию о компании и местоположении
      final enriched =
          projects
              .map(
                (proj) => {
                  ...proj,
                  'clientCompany': profile?.basic.companyName ?? '',
                  'clientLocation':
                      '${profile?.basic.city ?? ''}, ${profile?.basic.country ?? ''}',
                },
              )
              .toList();

      setState(() => _projects = enriched);
    } catch (e) {
      setState(() => _error = 'Ошибка при загрузке: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onAddProject() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const NewProjectStep1Screen()),
    );

    if (result != null && _selectedTabIndex == 0) {
      final profile =
          Provider.of<ClientProfileProvider>(context, listen: false).profile;
      final enriched = {
        ...result,
        'clientCompany': profile?.basic.companyName ?? '',
        'clientLocation':
            '${profile?.basic.city ?? ''}, ${profile?.basic.country ?? ''}',
      };
      setState(() => _projects.insert(0, enriched));

      // Показываем уведомление об успешном создании проекта
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Проект успешно создан!',
      );
    }
  }

  Future<void> _onDeleteProject(Map<String, dynamic> project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Palette.white,
            title: const Text('Удалить проект?'),
            content: const Text('Вы уверены, что хотите удалить этот проект?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Удалить'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token == null) return;

      try {
        await _projectService.deleteProject(project['id'], token);
        setState(() => _projects.removeWhere((p) => p['id'] == project['id']));

        // Показываем уведомление об успешном удалении проекта
        ErrorSnackbar.show(
          context,
          type: ErrorType.success,
          title: 'Успех',
          message: 'Проект успешно удалён!',
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка при удалении: $e')));
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
              : _buildPlaceholder(_navLabel(_bottomNavIndex)),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) async {
          if (i == 3) {
            await Navigator.pushNamed(context, Routes.profile);
            setState(() => _bottomNavIndex = 0);
          } else {
            setState(() => _bottomNavIndex = i);
          }
        },
      ),
    );
  }

  Widget _buildProjectsBody() {
    return Column(
      children: [
        AppBar(
          title: const Text(
            'Проекты',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Add.svg',
                width: 20,
                height: 20,
                color: Palette.navbar,
              ),
              onPressed: _onAddProject,
            ),
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
              children: List.generate(
                3,
                (i) => _buildTab(['Открытые', 'В работе', 'Архив'][i], i),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Palette.red,
                        fontFamily: 'Inter',
                      ),
                    ),
                  )
                  : _projects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _projects.length,
                    itemBuilder: (_, i) {
                      final project = _projects[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailScreen(project: project),
                            ),
                          );
                        },
                        child: ProjectCard(
                          project: project,
                          onEdit: () {
                            ErrorSnakbar.show(
                              context,
                              type: ErrorType.info,
                              title: 'Внимание',
                              message: 'Редактирование пока не реализовано',
                            );
                          },
                          onDelete: () => _onDeleteProject(project),
                        ),
                      );
                    },
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
          duration: const Duration(milliseconds: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Palette.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.all(4),
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

  Widget _buildEmptyState() {
    final texts =
        [
          [
            'assets/projects.svg',
            'Нет открытых проектов',
            'Нажмите "Создать проект", чтобы начать',
          ],
          [
            'assets/projects.svg',
            'Нет проектов в работе',
            'Они появятся, когда вы начнёте работу',
          ],
          [
            'assets/archive.svg',
            'Архив пуст',
            'Завершённые проекты будут отображаться здесь',
          ],
        ][_selectedTabIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(texts[0], height: 400),
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
            if (_selectedTabIndex == 0) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onAddProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize: const Size(270, 48),
                ),
                child: const Text(
                  'Создать проект',
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String label) {
    return Center(
      child: Text(
        '$label недоступен',
        style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
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
        return 'Раздел';
    }
  }
}
