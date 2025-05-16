import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:jobsy/component/custom_bottom_nav_bar.dart';
import 'package:jobsy/component/project_card.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/model/project/projects_cubit.dart';
import 'package:jobsy/provider/auth_provider.dart';
import 'package:jobsy/service/dashboard_service.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:jobsy/util/palette.dart';
import 'package:jobsy/util/routes.dart';
import 'package:provider/provider.dart';

import 'project_freelancer_search/project_search_screen.dart';

class ProjectsScreenFree extends StatefulWidget {
  const ProjectsScreenFree({Key? key}) : super(key: key);

  @override
  State<ProjectsScreenFree> createState() => _ProjectsScreenFreeState();
}

class _ProjectsScreenFreeState extends State<ProjectsScreenFree> {
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;

  void _onTabTap(int index) {
    setState(() => _selectedTabIndex = index);
    context.read<ProjectsCubit>().loadTab(index);
  }

  Future<void> _onAddProject() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProjectSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    return BlocProvider(
      create: (_) => ProjectsCubit(
        dashboardService: DashboardService(),
        projectService: ProjectService(),
        token: token!,
      )..loadTab(_selectedTabIndex),
      child: Scaffold(
        backgroundColor: Palette.white,
        body: _bottomNavIndex == 0
            ? BlocBuilder<ProjectsCubit, ProjectsState>(
          builder: (context, state) {
            if (state is ProjectsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProjectsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Palette.red),
                ),
              );
            } else if (state is ProjectsLoaded) {
              return _buildContent(state.projects);
            }
            return const SizedBox();
          },
        )
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
      ),
    );
  }

  Widget _buildContent(List<Project> projects) {
    return Column(
      children: [
        CustomNavBar(
          leading: const SizedBox(),
          title: 'Проекты',
          titleStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Palette.black,
            fontFamily: 'Inter',
          ),
          trailing: const SizedBox(),
        ),
        const SizedBox(height: 30),
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
              children: List.generate(
                4,
                    (i) => _buildTab(
                    ['В работе', 'Отклики', 'Приглашения', 'Архив'][i], i),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: projects.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: projects.length,
            itemBuilder: (_, i) {
              final proj = projects[i];
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
      ['assets/projects.svg', 'Нет проектов в работе', 'Нажмите "Найти проект"'],
      ['assets/archive.svg', 'Нет откликов', 'Ваши отклики появятся здесь'],
      ['assets/archive.svg', 'Нет приглашений', 'Ваши приглашения появятся здесь'],
      ['assets/archive.svg', 'Архив пуст', 'Завершённые проекты будут здесь'],
    ][_selectedTabIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(texts[0], height: 300),
            const SizedBox(height: 24),
            Text(texts[1],
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(texts[2],
                style: const TextStyle(fontSize: 14, color: Palette.thin)),
            if (_selectedTabIndex == 0) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onAddProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  minimumSize: const Size(200, 48),
                ),
                child: const Text('Найти проект',
                    style: TextStyle(color: Palette.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _navLabel(int idx) {
    switch (idx) {
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
