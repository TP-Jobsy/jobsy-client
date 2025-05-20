import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:jobsy/component/custom_bottom_nav_bar.dart';
import 'package:jobsy/component/project_card.dart';
import 'package:jobsy/component/invite_project_card.dart';
import 'package:jobsy/model/project/projects_cubit.dart';
import 'package:jobsy/pages/project/description_screen.dart';
import 'package:jobsy/pages/project/project_freelancer_search/project_search_screen.dart';
import 'package:jobsy/provider/auth_provider.dart';
import 'package:jobsy/service/dashboard_service.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:jobsy/util/palette.dart';
import 'package:jobsy/util/routes.dart';
import 'package:provider/provider.dart';

import '../../model/project/invitation_with_project.dart';
import '../../model/project/project.dart';

class ProjectsScreenFree extends StatefulWidget {
  const ProjectsScreenFree({Key? key}) : super(key: key);

  @override
  State<ProjectsScreenFree> createState() => _ProjectsScreenFreeState();
}

class _ProjectsScreenFreeState extends State<ProjectsScreenFree> {
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;
  late PageController _pageController;
  late ProjectsCubit _projectsCubit;

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token!;
    _pageController = PageController(initialPage: _selectedTabIndex);
    _projectsCubit = ProjectsCubit(
      dashboardService: DashboardService(),
      projectService: ProjectService(),
      token: token,
    )..loadTab(_selectedTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _projectsCubit.close();
    super.dispose();
  }

  void _onTabTap(int index) {
    setState(() => _selectedTabIndex = index);
    _projectsCubit.loadTab(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
      body: BlocProvider.value(
        value: _projectsCubit,
        child: _bottomNavIndex == 0
            ? Column(
          children: [
            CustomNavBar(
              leading: const SizedBox(width: 20),
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
                        ['В работе', 'Отклики', 'Приглашения', 'Архив'][i],
                        i),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 4,
                onPageChanged: _onTabTap,
                itemBuilder: (_, idx) => BlocBuilder<ProjectsCubit, ProjectsState>(
                  builder: (ctx, st) {
                    if (st is ProjectsLoading) return const Center(child: CircularProgressIndicator());
                    if (st is ProjectsError) return Center(child: Text(st.message, style: const TextStyle(color: Palette.red)));
                    if (st is ProjectsLoaded && st.currentTab == idx) {
                      final items = st.items;
                      if (items.isEmpty) {
                        return _buildEmptyStateForTab(idx);
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          if (idx == 2) {
                            final inv = items[i] as InvitationWithProject;
                            return InviteProjectCard(
                              projectTitle: inv.project.title,
                              projectDescription: inv.project.description,
                              status: inv.project.status.name,
                              isProcessed: inv.isProcessed,
                              onAccept: () => _projectsCubit.respondInvite(
                                projectId: inv.project.id,
                                applicationId: inv.applicationId,
                                accept: true,
                              ),
                              onReject: () => _projectsCubit.respondInvite(
                                projectId: inv.project.id,
                                applicationId: inv.applicationId,
                                accept: false,
                              ),
                            );
                          } else {
                            final proj = items[i] as Project;
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DescriptionScreen(projectId: proj.id)),
                              ),
                              child: ProjectCard(
                                project: proj.toJson(),
                                showActions: idx == 0,
                              ),
                            );
                          }
                        },
                      );
                    }
                    return _buildEmptyStateForTab(idx);
                  },
                ),
              ),
            ),
          ],
        )
            : Center(child: Text(_navLabel(_bottomNavIndex))),
      ),
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

  Widget _buildTab(String label, int index) {
    final selected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateForTab(int tabIndex) {
    final msgs = [
      ['assets/projects.svg', 'Нет проектов в работе', 'Нажмите "Найти проект"'],
      ['assets/archive.svg', 'Нет откликов', 'Ваши отклики появятся здесь'],
      ['assets/archive.svg', 'Нет приглашений', 'Ваши приглашения появятся здесь'],
      ['assets/archive.svg', 'Архив пуст', 'Завершённые проекты будут здесь'],
    ][tabIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(msgs[0], height: 300),
            const SizedBox(height: 24),
            Text(msgs[1],
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(msgs[2],
                style: const TextStyle(fontSize: 14, color: Palette.thin)),
            if (tabIndex == 0) ...[
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