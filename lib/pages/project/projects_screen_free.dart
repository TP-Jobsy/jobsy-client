import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../model/project/project_application.dart';
import '../../provider/auth_provider.dart';
import '../../service/project_service.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import 'project_search/project_search_screen.dart';
import '../../component/project_card.dart';

class ProjectsScreenFree extends StatefulWidget {
  const ProjectsScreenFree({Key? key}) : super(key: key);

  @override
  State<ProjectsScreenFree> createState() => _ProjectsScreenFreeState();
}

class _ProjectsScreenFreeState extends State<ProjectsScreenFree> {
  final _service = ProjectService();
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;

  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _inProgress = [];
  List<ProjectApplication> _responses = [];
  List<ProjectApplication> _invitations = [];
  List<Map<String, dynamic>> _archived = [];
  List<Map<String, dynamic>> _projects = [];
  get ErrorSnakbar => null;

  @override
  void initState() {
    super.initState();
    _loadTabData(_selectedTabIndex);
  }

  Future<void> _loadTabData(int tabIndex) async {
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
      switch (tabIndex) {
        case 0:
          _inProgress = await _service.fetchFreelancerProjects(
            token,
            status: 'IN_PROGRESS',
          );
          break;
        case 1:
          _responses = await _service.fetchMyResponses(token);
          break;
        case 2:
          _invitations = await _service.fetchMyInvitations(token);
          break;
        case 3:
          _archived = await _service.fetchFreelancerProjects(
            token,
            status: 'COMPLETED',
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
    if (_selectedTabIndex == index) return;
    setState(() => _selectedTabIndex = index);
    _loadTabData(index);
  }

  Future<void> _onAddProject() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const ProjectSearchScreen()),
    );
    if (result != null) {
      // Handle the result here if needed
    }
  }

  Future<void> _onDeleteProject(Map<String, dynamic> project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
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
    if (confirmed ?? false) {
      // Perform delete action
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _bottomNavIndex = index);
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
          if (i == 2) {
            await Navigator.pushNamed(context, Routes.favorites);
            setState(() {
              _bottomNavIndex = 2;
            });
          } else if (i == 3) {
            await Navigator.pushNamed(context, Routes.profileFree);
            setState(() {
              _bottomNavIndex = 3;
            });
          } else if (i == 1) {
            await Navigator.pushNamed(context, Routes.searchProject);
            setState(() {
              _bottomNavIndex = 1;
            });
          } else {
            setState(() => _bottomNavIndex = i);
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Palette.red)),
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
              children: List.generate(4, (i) => _buildTab(['В работе', 'Отклики', 'Приглашения', 'Архив'][i], i)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _isLoading
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
                  Navigator.pushNamed(
                    context,
                    Routes.projectDetail,
                    arguments: project,
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
        onTap: () => _onTabTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 2),
          decoration: BoxDecoration(
            color: selected ? Palette.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final texts = [
      [
        'assets/projects.svg',
        'У вас пока нет проектов в работе',
        'Нажмите "Найти проект", чтобы начать!',
      ],
      [
        'assets/archive.svg',
        'Здесь пока нет откликов',
        'Как только они появятся, вы увидите их в этом разделе',
      ],
      [
        'assets/archive.svg',
        'У вас пока нет приглашений',
        'Как только они появятся, вы увидите их в этом разделе',
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
                  'Найти проект',
                  style: TextStyle(
                    color: Palette.white,
                    fontFamily: 'Inter',
                    fontSize: 16,
                  ),
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
