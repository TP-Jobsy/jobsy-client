import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../component/project_card.dart';
import '../../model/project/rating.dart';
import '../../service/dashboard_service.dart';
import '../../service/project_service.dart';
import '../../service/rating_service.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import '../../enum/project-status.dart';
import '../../viewmodels/auth_provider.dart';
import '../../viewmodels/client_profile_provider.dart';
import 'new_project/new_project_step1_screen.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  late ProjectService _projectService;
  late DashboardService _dashboardService;

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

  List<List<Map<String, dynamic>>> _allProjects = [[], [], []];
  List<bool> _isLoaded = [false, false, false];

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('ClientHomeScreen_opened');
    final auth = context.read<AuthProvider>();
    _projectService = ProjectService(
      getToken: () async {
        await auth.ensureLoaded();
        return auth.token!;
      },
      refreshToken: () async {
        return auth.refreshTokens();
      },
    );
    _dashboardService = DashboardService(
      getToken: () async {
        await auth.ensureLoaded();
        return auth.token!;
      },
      refreshToken: () async {
        return auth.refreshTokens();
      },
    );

    _loadProjects(_selectedTabIndex);
  }

  Future<void> _loadProjects(int tabIndex) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final projs = await _dashboardService.getClientProjects(
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

    try {
      await _projectService.deleteProject(project['id'] as int);
      setState(
            () => _allProjects[0].removeWhere((p) => p['id'] == project['id']),
      );
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
    if (!_isLoaded[index]) {
      _loadProjects(index);
    }
  }

  Future<void> _openRating(int projectId) async {
    final rating = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const RatingScreen()),
    );
    if (rating == null) return;

    try {
      final auth = context.read<AuthProvider>();
      final ratingService = RatingService(
        getToken: () async {
          await auth.ensureLoaded();
          return auth.token!;
        },
        refreshToken: () async {
          return auth.refreshTokens();
        },
      );
      await ratingService.rateProject(projectId, rating.toDouble());
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Оценка сохранена',
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString().contains('409')
            ? 'Вы уже оценили этот проект'
            : 'Не удалось сохранить оценку: $e',
      );
    }
  }

  Future<void> _completeProject(int projectId) async {
    try {
      await _projectService.completeByClient(projectId);
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Вы завершили проект. Ожидается подтверждение от фрилансера',
      );
      await _loadProjects(1);
      if (_isLoaded[2]) {
        await _loadProjects(2);
      }
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: 'Не удалось завершить проект: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    return Scaffold(
      backgroundColor: Palette.white,
      body: _bottomNavIndex == 0
          ? _buildProjectsBody(isSmallScreen, isMediumScreen)
          : _buildPlaceholder(_navLabel(_bottomNavIndex)),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) async {
          setState(() => _bottomNavIndex = i);
          switch (i) {
            case 0: break;
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

  Widget _buildProjectsBody(bool isSmallScreen, bool isMediumScreen) {
    final titleFontSize = isSmallScreen ? 18.0 : 20.0;
    final tabHeight = isSmallScreen ? 40.0 : 48.0;
    final tabMargin = isSmallScreen ? 2.0 : 4.0;
    final tabTextSize = isSmallScreen ? 12.0 : 14.0;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;
    final addIconSize = isSmallScreen ? 18.0 : 20.0;

    return Column(
      children: [
        CustomNavBar(
          leading: SizedBox(width: isSmallScreen ? 48.0 : 60.0),
          title: 'Проекты',
          titleStyle: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            color: Palette.black,
            fontFamily: 'Inter',
          ),
          trailing: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Add.svg',
              width: addIconSize,
              height: addIconSize,
              color: Palette.navbar,
            ),
            onPressed: _onAddProject,
          ),
        ),
        SizedBox(height: isSmallScreen ? 12.0 : 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Container(
            height: tabHeight,
            decoration: BoxDecoration(
              color: Palette.dotInactive,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: List.generate(
                _labels.length,
                    (i) => _buildTab(_labels[i], i, isSmallScreen, tabMargin, tabTextSize),
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12.0 : 16.0),
        Expanded(
          child: IndexedStack(
            index: _selectedTabIndex,
            children: List.generate(_statuses.length, (i) {
              final projects = _allProjects[i];
              if (_isLoading && !_isLoaded[i]) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_error != null) {
                return Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Palette.red),
                  ),
                );
              }
              if (projects.isEmpty) return _buildEmptyState(i, isSmallScreen);
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: projects.length,
                itemBuilder: (_, j) {
                  final project = projects[j];
                  return GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(
                            projectId: project['id'],
                            projectStatus: _statuses[i],
                          ),
                        ),
                      );
                      if (updated == true) {
                        await _loadProjects(0);
                        await _loadProjects(1);
                        if (_isLoaded[2]) {
                          await _loadProjects(2);
                        }
                      }
                    },
                    child: ProjectCard(
                      project: project,
                      showActions: i == 0,
                      onEdit: () => ErrorSnackbar.show(
                        context,
                        type: ErrorType.info,
                        title: 'Внимание',
                        message: 'Редактирование пока не реализовано',
                      ),
                      onDelete: () => _onDeleteProject(project),
                      onRate: i == 2 ? () => _openRating(project['id']) : null,
                      onComplete: i == 1 ? () => _completeProject(project['id']) : null,
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index, bool isSmallScreen, double margin, double textSize) {
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
          margin: EdgeInsets.all(margin),
          child: Text(
            label,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(int tabIndex, bool isSmallScreen) {
    final texts = [
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
        'Завершённые проекты будут здесь',
      ],
    ][tabIndex];

    final imageHeight = isSmallScreen ? 200.0 : 300.0;
    final titleSize = isSmallScreen ? 14.0 : 16.0;
    final subtitleSize = isSmallScreen ? 12.0 : 14.0;
    final buttonWidth = isSmallScreen ? 200.0 : 250.0;
    final buttonHeight = isSmallScreen ? 40.0 : 48.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(texts[0], height: imageHeight),
            SizedBox(height: isSmallScreen ? 16.0 : 24.0),
            Text(
              texts[1],
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6.0 : 8.0),
            Text(
              texts[2],
              style: TextStyle(
                fontSize: subtitleSize,
                color: Palette.thin,
              ),
            ),
            if (tabIndex == 0) ...[
              SizedBox(height: isSmallScreen ? 16.0 : 24.0),
              ElevatedButton(
                onPressed: _onAddProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize: Size(buttonWidth, buttonHeight),
                ),
                child: Text(
                  'Создать проект',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14.0 : 16.0,
                    color: Palette.white,
                  ),
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