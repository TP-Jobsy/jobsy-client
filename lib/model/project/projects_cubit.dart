import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsy/enum/project-application-status.dart';
import 'package:jobsy/enum/project-status.dart';
import 'package:jobsy/model/project/invitation_with_project.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/service/dashboard_service.dart';
import 'package:jobsy/service/invitation_service.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:jobsy/service/api_client.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final DashboardService dashboardService;
  final ProjectService projectService;
  final InvitationService invitationService;

  ProjectsCubit({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    DashboardService? dashboardService,
    ProjectService? projectService,
    InvitationService? invitationService,
  }) :
        dashboardService = dashboardService ??
            DashboardService(getToken: getToken, refreshToken: refreshToken),
        projectService = projectService ??
            ProjectService(getToken: getToken, refreshToken: refreshToken),
        invitationService = invitationService ??
            InvitationService(getToken: getToken, refreshToken: refreshToken),
        super(const ProjectsInitial());

  Future<void> loadTab(int tabIndex) async {
    emit(const ProjectsLoading());
    try {
      if (tabIndex == 2) {
        final apps = await dashboardService.getMyInvitations(
          status: ProjectApplicationStatus.PENDING,
        );
        final invites = <InvitationWithProject>[];
        for (final app in apps) {
          final project = await projectService.fetchProjectById(app.projectId);
          invites.add(InvitationWithProject(
            applicationId: app.id,
            project: project,
            isProcessed: app.status != ProjectApplicationStatus.PENDING,
          ));
        }
        emit(ProjectsLoaded(invites, tabIndex));
      } else {
        late final List<Project> projects;
        if (tabIndex == 0) {
          projects = await dashboardService.getFreelancerProjects(
            status: ProjectStatus.IN_PROGRESS,
          );
        } else if (tabIndex == 1) {
          final ids = await dashboardService.getMyResponseProjectIds(
            status: ProjectApplicationStatus.PENDING,
          );
          projects = await _loadProjectsByIds(ids);
        } else {
          projects = await dashboardService.getFreelancerProjects(
            status: ProjectStatus.COMPLETED,
          );
        }
        emit(ProjectsLoaded(projects, tabIndex));
      }
    } catch (e) {
      emit(ProjectsError('Ошибка загрузки: $e'));
    }
  }

  Future<List<Project>> _loadProjectsByIds(List<int> ids) async {
    final out = <Project>[];
    for (final id in ids) {
      try {
        out.add(await projectService.fetchProjectById(id));
      } catch (_) {
      }
    }
    return out;
  }

  Future<void> respondInvite({
    required int projectId,
    required int applicationId,
    required bool accept,
  }) async {
    try {
      await invitationService.handleInvitationStatus(
        projectId: projectId,
        applicationId: applicationId,
        status: accept
            ? ProjectApplicationStatus.APPROVED
            : ProjectApplicationStatus.DECLINED,
      );
      await loadTab(2);
    } catch (_) {
    }
  }

}