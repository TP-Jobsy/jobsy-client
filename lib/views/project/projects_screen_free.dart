import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:jobsy/component/custom_bottom_nav_bar.dart';
import 'package:jobsy/component/project_card.dart';
import 'package:jobsy/component/invite_project_card.dart';
import 'package:jobsy/model/project/projects_cubit.dart';
import 'package:jobsy/model/project/invitation_with_project.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/views/project/project_detail_screen_free.dart';
import 'package:jobsy/views/project/project_freelancer_search/project_search_screen.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:jobsy/service/rating_service.dart';
import 'package:jobsy/util/palette.dart';
import 'package:jobsy/util/routes.dart';
import 'package:provider/provider.dart';
import '../../component/error_snackbar.dart';
import '../../model/project/rating.dart';
import '../../viewmodels/auth_provider.dart';

class ProjectsScreenFree extends StatefulWidget {
  const ProjectsScreenFree({Key? key}) : super(key: key);

  @override
  State<ProjectsScreenFree> createState() => _ProjectsScreenFreeState();
}

class _ProjectsScreenFreeState extends State<ProjectsScreenFree> {
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;
  late ProjectsCubit _projectsCubit;

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('FreelancerHomeScreen_opened');
    final auth = context.read<AuthProvider>();
    _projectsCubit = ProjectsCubit(
      getToken: () async => auth.token,
      refreshToken: auth.refreshTokens,
    )..loadTab(_selectedTabIndex);
  }

  @override
  void dispose() {
    _projectsCubit.close();
    super.dispose();
  }

  void _onTabTap(int index) {
    if (_selectedTabIndex == index) return;
    setState(() => _selectedTabIndex = index);
    _projectsCubit.loadTab(index);
  }

  Future<void> _completeByFreelancer(int projectId) async {
    final auth = context.read<AuthProvider>();
    final service = ProjectService(
      getToken: () async => auth.token,
      refreshToken: auth.refreshTokens,
    );
    try {
      await service.completeByFreelancer(projectId);
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Вы завершили проект. Ожидается завершение со стороны клиента.',
      );
      _projectsCubit.loadTab(0);
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: 'Не удалось завершить проект: $e',
      );
    }
  }

  Future<void> _openRatingFree(int projectId) async {
    final rating = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const RatingScreen()),
    );
    if (rating == null) return;
    try {
      final auth = context.read<AuthProvider>();
      final ratingService = RatingService(
        getToken: () async => auth.token,
        refreshToken: auth.refreshTokens,
      );
      await ratingService.rateProject(projectId, rating.toDouble());
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Оценка сохранена',
      );
      _projectsCubit.loadTab(_selectedTabIndex);
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

  void _navigateToDetail(Map<String, dynamic> projectJson) {
    final status = projectJson['status'] as String;
    final showOnlyDescription = status != 'OPEN';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreenFree(
          projectFree: projectJson,
          showOnlyDescription: showOnlyDescription,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Palette.white,
      body: BlocProvider.value(
        value: _projectsCubit,
        child: Column(
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
            SizedBox(height: isSmallScreen ? 12 : 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 12 : 16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Palette.dotInactive,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: List.generate(4, (i) {
                    const titles = ['В работе', 'Отклики', 'Приглашения', 'Архив'];
                    final selected = _selectedTabIndex == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabTap(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? Palette.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          margin: const EdgeInsets.all(4),
                          child: Text(
                            titles[i],
                            style: TextStyle(
                              fontSize: screenWidth < 360 ? 10 : 11,
                              fontWeight: FontWeight.bold,
                              color: selected ? Palette.black : Palette.thin,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: List.generate(4, (idx) {
                  return BlocBuilder<ProjectsCubit, ProjectsState>(
                    builder: (_, state) {
                      if (state is ProjectsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ProjectsError) {
                        return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Palette.red)),
                        );
                      }
                      if (state is ProjectsLoaded && state.currentTab == idx) {
                        final items = state.items;
                        if (items.isEmpty) {
                          return _buildEmptyState(idx, isSmallScreen, screenWidth, screenHeight);
                        }
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 360 ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 12,
                          ),
                          itemCount: items.length,
                          itemBuilder: (_, i) {
                            switch (idx) {
                              case 0:
                                final proj = items[i] as Project;
                                return GestureDetector(
                                  onTap: () => _navigateToDetail(proj.toJson()),
                                  child: ProjectCard(
                                    project: proj.toJson(),
                                    showActions: false,
                                    onComplete: () => _completeByFreelancer(proj.id),
                                  ),
                                );

                              case 1:
                                final proj = items[i] as Project;
                                return GestureDetector(
                                  onTap: () => _navigateToDetail(proj.toJson()),
                                  child: ProjectCard(
                                    project: proj.toJson(),
                                    showActions: false,
                                  ),
                                );

                              case 2:
                                final inv = items[i] as InvitationWithProject;
                                return GestureDetector(
                                  onTap: () => _navigateToDetail(inv.project.toJson()),
                                  child: InviteProjectCard(
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
                                    complexityRaw: inv.project.complexity.name,
                                    durationRaw: inv.project.duration.name,
                                    fixedPrice: inv.project.fixedPrice,
                                  ),
                                );

                              case 3:
                                final proj = items[i] as Project;
                                return GestureDetector(
                                  onTap: () => _navigateToDetail(proj.toJson()),
                                  child: ProjectCard(
                                    project: proj.toJson(),
                                    showActions: false,
                                    onRate: () => _openRatingFree(proj.id),
                                  ),
                                );

                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }),
              ),
            ),
          ],
        ),
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

  Widget _buildEmptyState(int tab, bool isSmallScreen, double screenWidth, double screenHeight) {
    final msgs = [
      ['assets/projects.svg', 'Нет проектов в работе', 'Нажмите "Найти проект"'],
      ['assets/archive.svg', 'Нет откликов', 'Ваши отклики появятся здесь'],
      ['assets/archive.svg', 'Нет приглашений', 'Ваши приглашения появятся здесь'],
      ['assets/archive.svg', 'Архив пуст', 'Завершённые проекты будут здесь'],
    ][tab];
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 16 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              msgs[0],
              height: isSmallScreen ? screenHeight * 0.3 : 300,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Text(
              msgs[1],
              style: TextStyle(
                fontSize: screenWidth < 360 ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              msgs[2],
              style: TextStyle(
                fontSize: screenWidth < 360 ? 12 : 14,
                color: Palette.thin,
              ),
            ),
            if (tab == 0) ...[
              SizedBox(height: isSmallScreen ? 16 : 24),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProjectSearchScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenWidth < 360 ? 16 : 24,
                    ),
                  ),
                  minimumSize: Size(
                    screenWidth < 360 ? 160 : 200,
                    isSmallScreen ? 40 : 48,
                  ),
                ),
                child: Text(
                  'Найти проект',
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: screenWidth < 360 ? 12 : 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}