import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../component/project_card.dart';
import '../../provider/auth_provider.dart';
import '../../provider/client_profile_provider.dart';
import '../../service/dashboard_service.dart';
import '../../service/project_service.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import '../../enum/project-status.dart';
import 'new_project/new_project_step1_screen.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _dashboardService = DashboardService();
  final _projectService = ProjectService();

  static const _statuses = [
    ProjectStatus.OPEN,
    ProjectStatus.IN_PROGRESS,
    ProjectStatus.COMPLETED,
  ];
  static const _labels = ['Открытые', 'В работе', 'Архив'];

  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;

  bool _isLoading = true;
  String? _error;
  late PageController _pageController;

  List<List<Map<String, dynamic>>> _allProjects = [[], [], []];
  List<bool> _isLoaded = [false, false, false];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);
    _loadProjects(_selectedTabIndex);
  }

  Future<void> _loadProjects(int tabIndex) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _error = 'Не найден токен';
        _isLoading = false;
      });
      return;
    }

    try {
      final projs = await _dashboardService.getClientProjects(
        token: token,
        status: _statuses[tabIndex],
      );
      final profile = context.read<ClientProfileProvider>().profile;

      final enriched = projs.map((p) {
        final json = p.toJson();
        json['clientCompany'] = profile?.basic.companyName ?? '';
        json['clientLocation'] =
        '${profile?.basic.city ?? ''}, ${profile?.basic.country ?? ''}';
        return json;
      }).toList();

      setState(() {
        _allProjects[tabIndex] = enriched;
        _isLoaded[tabIndex] = true;
      });
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
      final profile = context.read<ClientProfileProvider>().profile;
      final enriched = {
        ...result,
        'clientCompany': profile?.basic.companyName ?? '',
        'clientLocation':
        '${profile?.basic.city ?? ''}, ${profile?.basic.country ?? ''}',
      };
      setState(() => _allProjects[0].insert(0, enriched));
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Проект успешно создан!',
      );
    }
  }

  Future<void> _onDeleteProject(Map<String, dynamic> project) async {
    if (project['status'] != 'OPEN') {
      ErrorSnackbar.show(
        context,
        type: ErrorType.warning,
        title: 'Нельзя удалить',
        message: 'Проект можно удалять только в статусе «Открыт»',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
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
    if (confirmed != true) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      await _projectService.deleteProject(project['id'] as int, token);
      setState(() => _allProjects[0].removeWhere((p) => p['id'] == project['id']));
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Проект успешно удалён!',
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: 'Не удалось удалить: $e',
      );
    }
  }

  void _onTabChanged(int index) {
    setState(() => _selectedTabIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 3),
      curve: Curves.ease,
    );
    if (!_isLoaded[index]) {
      _loadProjects(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: _bottomNavIndex == 0
          ? _buildProjectsBody()
          : _buildPlaceholder(_navLabel(_bottomNavIndex)),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) async {
          setState(() => _bottomNavIndex = i);
          switch (i) {
            case 0:
              break;
            case 1:
              await Navigator.pushNamed(context, Routes.freelancerSearch);
              setState(() => _bottomNavIndex = 0);
              break;
            case 2:
              await Navigator.pushNamed(context, Routes.favoritesFreelancers);
              setState(() => _bottomNavIndex = 0);
              break;
            case 3:
              await Navigator.pushNamed(context, Routes.profile);
              setState(() => _bottomNavIndex = 0);
              break;
          }
        },
      ),
    );
  }

  Widget _buildProjectsBody() {
    return Column(
      children: [
        CustomNavBar(
          leading: const SizedBox(width: 48),
          title: 'Проекты',
          titleStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Palette.black,
            fontFamily: 'Inter',
          ),
          trailing: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Add.svg',
              width: 20,
              height: 20,
              color: Palette.navbar,
            ),
            onPressed: _onAddProject,
          ),
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
                _labels.length,
                    (i) => _buildTab(_labels[i], i),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedTabIndex = index);
              if (!_isLoaded[index]) {
                _loadProjects(index);
              }
            },
            itemCount: _statuses.length,
            itemBuilder: (_, i) {
              final projects = _allProjects[i];
              if (_isLoading && !_isLoaded[i]) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_error != null) {
                return Center(
                  child: Text(_error!, style: const TextStyle(color: Palette.red)),
                );
              }
              if (projects.isEmpty) return _buildEmptyState(i);
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: projects.length,
                itemBuilder: (_, j) {
                  final project = projects[j];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectDetailScreen(projectId: project['id']),
                      ),
                    ),
                    child: ProjectCard(
                      project: project,
                      onEdit: () => ErrorSnackbar.show(
                        context,
                        type: ErrorType.info,
                        title: 'Внимание',
                        message: 'Редактирование пока не реализовано',
                      ),
                      onDelete: () => _onDeleteProject(project),
                    ),
                  );
                },
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
              fontWeight: FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(int tabIndex) {
    final texts = [
      ['assets/projects.svg', 'Нет открытых проектов', 'Нажмите "Создать проект", чтобы начать'],
      ['assets/projects.svg', 'Нет проектов в работе', 'Они появятся, когда вы начнёте работу'],
      ['assets/archive.svg', 'Архив пуст', 'Завершённые проекты будут здесь'],
    ][tabIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(texts[0], height: 300),
            const SizedBox(height: 24),
            Text(
              texts[1],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              texts[2],
              style: const TextStyle(fontSize: 14, color: Palette.thin),
            ),
            if (tabIndex == 0) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onAddProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize: const Size(250, 48),
                ),
                child: const Text(
                  'Создать проект',
                  style: TextStyle(color: Palette.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String label) =>
      Center(child: Text('$label недоступен'));

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
