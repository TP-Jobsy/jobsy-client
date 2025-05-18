import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsy/enum/project-application-status.dart';
import 'package:jobsy/enum/project-status.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/service/dashboard_service.dart';
import 'package:jobsy/service/project_service.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final DashboardService dashboardService;
  final ProjectService projectService;
  final String token;

  ProjectsCubit({
    required this.dashboardService,
    required this.projectService,
    required this.token,
  }) : super(ProjectsInitial());

  Future<void> loadTab(int tabIndex) async {
    emit(ProjectsLoading());

    try {
      List<Project> projects = [];

      switch (tabIndex) {
        case 0:
          projects = await dashboardService.getFreelancerProjects(
            token: token,
            status: ProjectStatus.IN_PROGRESS,
          );
          break;

        case 1:
          final projectIds = await dashboardService.getMyResponseProjectIds(
            token: token,
            status: ProjectApplicationStatus.PENDING,
          );
          projects = await _loadProjectsByIds(projectIds);
          break;

        case 2:
          final projectIds = await dashboardService.getMyInvitationProjectIds(
            token: token,
            status: ProjectApplicationStatus.PENDING,
          );
          projects = await _loadProjectsByIds(projectIds);
          break;

        case 3:
          projects = await dashboardService.getFreelancerProjects(
            token: token,
            status: ProjectStatus.COMPLETED,
          );
          break;
      }

      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectsError('Ошибка загрузки: $e'));
    }
  }

  Future<List<Project>> _loadProjectsByIds(List<int> projectIds) async {
    final projects = <Project>[];

    for (final id in projectIds) {
      try {
        final project = await projectService.fetchProjectById(id, token);
        projects.add(project);
      } catch (e) {
        continue;
      }
    }

    return projects;
  }

  Future<void> refreshResponses() async {
    if (state is ProjectsLoaded) {
      await loadTab(1);
    }
  }
}