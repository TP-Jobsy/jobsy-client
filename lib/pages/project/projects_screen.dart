import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/pallete.dart';
import 'new_project_step1_screen.dart';

class ProjectsScreen extends StatefulWidget {
  final Map<String, dynamic>? initialProject;

  const ProjectsScreen({super.key, this.initialProject});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;

  List<Map<String, dynamic>> openProjects = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialProject != null) {
      openProjects.add(widget.initialProject!);
    }
  }

  Future<void> _navigateToCreateProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewProjectStep1Screen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        openProjects.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: _bottomNavIndex == 0
          ? _buildProjectsBody()
          : Center(child: Text(_navLabel(_bottomNavIndex))),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProjectsBody() {
    return Column(
      children: [
        AppBar(
          title: const Text('Проекты', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
          centerTitle: true,
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _navigateToCreateProject,
            ),
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
                _buildTab(label: 'Архив', index: 2),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildTabContent()),
      ],
    );
  }

  Widget _buildTab({required String label, required int index}) {
    final selected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
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
              fontWeight: selected ? FontWeight.bold : FontWeight.bold, fontFamily: 'Inter',
              color: selected ? Palette.black : Palette.thin,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return openProjects.isEmpty
            ? _buildEmptyState(
          image: 'assets/projects.svg',
          title: 'У вас пока нет открытых проектов',
          subtitle: 'Нажмите "Создать проект", чтобы начать!',
          showButton: true,
        )
            : ListView.builder(
          itemCount: openProjects.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return _buildProjectCard(openProjects[index]);
          },
        );
      case 1:
        return _buildEmptyState(
          image: 'assets/progress.svg',
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

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Palette.primary, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 6),
            Text(
              'Почасовая оплата: 500–600 руб / час, уровень: ${project['difficulty'] ?? '—'}, дедлайн: ${project['deadline'] ?? '—'}',
              style: const TextStyle(fontSize: 13, color: Colors.black87, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.business_center, size: 16, color: Palette.secondary),
                SizedBox(width: 4),
                Text('Digital Growth Agency', style: TextStyle(fontSize: 12, fontFamily: 'Inter')),
                SizedBox(width: 12),
                Icon(Icons.location_on, size: 16, color: Palette.secondary),
                SizedBox(width: 4),
                Text('Дубай, ОАЭ', style: TextStyle(fontSize: 12, fontFamily: 'Inter')),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(project['createdAt']),
              style: const TextStyle(fontSize: 12, color: Palette.thin, fontFamily: 'Inter'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return '${dt.day} ${_monthName(dt.month)} ${dt.year}';
  }

  String _monthName(int month) {
    const months = [
      '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month];
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
                textAlign: TextAlign.center),
            if (showButton) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _navigateToCreateProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Создать проект',
                    style: TextStyle(color: Palette.white, fontFamily: 'Inter')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final icons = [
      Icons.home,
      Icons.search,
      Icons.favorite_border,
      Icons.person,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Palette.navbar,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = index == _bottomNavIndex;
          return GestureDetector(
            onTap: () => setState(() => _bottomNavIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Palette.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icons[index],
                color: Palette.white,
                size: isSelected ? 26 : 22,
              ),
            ),
          );
        }),
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
