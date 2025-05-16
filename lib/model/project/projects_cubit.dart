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
          final responses = await dashboardService.getMyResponses(
            token: token,
            status: ProjectApplicationStatus.PENDING,
          );
          projects = await Future.wait(responses.map(
                (r) => projectService.fetchProjectById(r.projectId, token),
          ));
          break;

        case 2:
          final invites = await dashboardService.getMyInvitations(
            token: token,
            status: ProjectApplicationStatus.PENDING,
          );
          projects = await Future.wait(invites.map(
                (i) => projectService.fetchProjectById(i.projectId, token),
          ));
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
}
