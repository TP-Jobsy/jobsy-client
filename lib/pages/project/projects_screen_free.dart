import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/project_card.dart';
import '../../model/project_application_dto.dart';
import '../../provider/auth_provider.dart';
import '../../service/project_service.dart';
import '../../util/pallete.dart';

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
  List<ProjectApplicationDto> _responses = [];
  List<ProjectApplicationDto> _invitations = [];
  List<Map<String, dynamic>> _archived = [];

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

  void _onBottomNavTap(int index) {
    setState(() => _bottomNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body:
          _bottomNavIndex == 0
              ? _buildBody()
              : Center(child: Text(_navLabel(_bottomNavIndex))),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) async {
          if (i == 3) {
            await Navigator.pushNamed(context, '/profilefree');
            setState(() {
              _bottomNavIndex = 0;
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
                _buildTab('В работе', 0),
                _buildTab('Отклики', 1),
                _buildTab('Приглашения', 2),
                _buildTab('Архив', 3),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildTabContent()),
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
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.bold,
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
        return _inProgress.isEmpty
            ? _emptyState('В работе', 'Нет проектов в работе')
            : ListView.builder(
              itemCount: _inProgress.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, i) => ProjectCard(project: _inProgress[i]),
            );
      case 1:
        return _responses.isEmpty
            ? _emptyState('Отклики', 'Нет откликов')
            : ListView.separated(
              itemCount: _responses.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final r = _responses[i];
                return ListTile(
                  title: Text(r.freelancerName),
                  subtitle: Text('Статус: ${r.status}'),
                );
              },
            );
      case 2:
        return _invitations.isEmpty
            ? _emptyState('Приглашения', 'Нет приглашений')
            : ListView.separated(
              itemCount: _invitations.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final inv = _invitations[i];
                return ListTile(
                  title: Text(inv.freelancerName),
                  subtitle: Text('Статус: ${inv.status}'),
                );
              },
            );
      case 3:
        return _archived.isEmpty
            ? _emptyState('Архив', 'Нет завершённых проектов')
            : ListView.builder(
              itemCount: _archived.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, i) => ProjectCard(project: _archived[i]),
            );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _emptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/projects.svg', height: 300),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
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
