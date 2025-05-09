import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/enum/project-application-status.dart';
import 'package:jobsy/enum/project-status.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/service/dashboard_service.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/project_card.dart';
import '../../provider/auth_provider.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import 'project_freelancer_search/project_search_screen.dart';

class ProjectsScreenFree extends StatefulWidget {
  const ProjectsScreenFree({Key? key}) : super(key: key);

  @override
  State<ProjectsScreenFree> createState() => _ProjectsScreenFreeState();
}

class _ProjectsScreenFreeState extends State<ProjectsScreenFree> {
  final DashboardService _dashboardService = DashboardService();
  final ProjectService   _projectService   = ProjectService();

  int  _selectedTabIndex = 0;
  int  _bottomNavIndex   = 0;
  bool _isLoading        = false;
  String? _error;

  List<Project> _inProgress = [];
  List<Project> _applied    = [];
  List<Project> _invited    = [];
  List<Project> _archived   = [];

  @override
  void initState() {
    super.initState();
    _loadTabData(0);
  }

  Future<void> _loadTabData(int tabIndex) async {
    setState(() {
      _isLoading = true;
      _error     = null;
    });

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      setState(() {
        _error     = 'Не найден токен';
        _isLoading = false;
      });
      return;
    }

    try {
      switch (tabIndex) {
        case 0:
          _inProgress = await _dashboardService.getFreelancerProjects(
            token:  token,
            status: ProjectStatus.IN_PROGRESS,
          );
          break;

        case 1:
          final responses = await _dashboardService.getMyResponses(
            token:  token,
            status: ProjectApplicationStatus.PENDING,
          );
          _applied = await Future.wait(responses.map(
                (r) => _projectService.fetchProjectById(r.projectId, token),
          ));
          break;

        case 2:
          final invites = await _dashboardService.getMyInvitations(
            token:  token,
            status: ProjectApplicationStatus.PENDING,
          );
          _invited = await Future.wait(invites.map(
                (i) => _projectService.fetchProjectById(i.projectId, token),
          ));
          break;

        case 3:
          _archived = await _dashboardService.getFreelancerProjects(
            token:  token,
            status: ProjectStatus.COMPLETED,
          );
          break;
      }
    } catch (e) {
      _error = 'Ошибка загрузки: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTabTap(int index) {
    if (index == _selectedTabIndex) return;
    setState(() => _selectedTabIndex = index);
    _loadTabData(index);
  }

  Future<void> _onAddProject() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProjectSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: _bottomNavIndex == 0
          ? _buildBody()
          : Center(child: Text(_navLabel(_bottomNavIndex))),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) async {
          if (i == 1) {
            await Navigator.pushNamed(context, Routes.searchProject);
          } else if (i == 2) {
            await Navigator.pushNamed(context, Routes.favorites);
          } else if (i == 3) {
            await Navigator.pushNamed(context, Routes.profileFree);
          }
          setState(() => _bottomNavIndex = i);
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Palette.red)));
    }

    List<Project> display;
    switch (_selectedTabIndex) {
      case 0: display = _inProgress; break;
      case 1: display = _applied;    break;
      case 2: display = _invited;    break;
      default: display = _archived;  break;
    }

    return Column(
      children: [
        AppBar(
          title: const Text('Проекты', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          elevation: 0,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Palette.dotInactive, borderRadius: BorderRadius.circular(32)),
            child: Row(
              children: List.generate(
                4,
                    (i) => _buildTab(['В работе', 'Отклики', 'Приглашения', 'Архив'][i], i),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: display.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: display.length,
            itemBuilder: (_, i) {
              final proj = display[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.projectDetail,
                  arguments: proj.toJson(),
                ),
                child: ProjectCard(
                  project: proj.toJson(),
                  onEdit: null,
                  onDelete: () {},
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
        onTap: () => _onTabTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Palette.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.all(4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final texts = [
      ['assets/projects.svg',    'Нет проектов в работе', 'Нажмите "Найти проект"'],
      ['assets/archive.svg',     'Нет откликов',         'Ваши отклики появятся здесь'],
      ['assets/archive.svg',     'Нет приглашений',      'Ваши приглашения появятся здесь'],
      ['assets/archive.svg',     'Архив пуст',           'Завершённые проекты будут здесь'],
    ][_selectedTabIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(texts[0], height: 300),
            const SizedBox(height: 24),
            Text(texts[1], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(texts[2], style: const TextStyle(fontSize: 14, color: Palette.thin)),
            if (_selectedTabIndex == 0) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onAddProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  minimumSize: const Size(200, 48),
                ),
                child: const Text('Найти проект', style: TextStyle(color: Palette.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _navLabel(int idx) {
    switch (idx) {
      case 1: return 'Поиск';
      case 2: return 'Избранное';
      case 3: return 'Профиль';
      default: return '';
    }
  }
}