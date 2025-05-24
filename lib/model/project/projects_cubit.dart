// lib/model/project/projects_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsy/enum/project-application-status.dart';
import 'package:jobsy/enum/project-status.dart';
import 'package:jobsy/model/project/invitation_with_project.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/service/dashboard_service.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:jobsy/service/invitation_service.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final DashboardService dashboardService;
  final ProjectService projectService;
  final InvitationService invitationService;
  final String token;

  ProjectsCubit({
    required this.dashboardService,
    required this.projectService,
    required this.token,
    InvitationService? invitationService,
  })  : invitationService = invitationService ?? InvitationService(),
        super(const ProjectsInitial());

  Future<void> loadTab(int tabIndex) async {
    emit(const ProjectsLoading());
    try {
      if (tabIndex == 2) {
        final apps = await dashboardService.getMyInvitations(
          token: token,
          status: ProjectApplicationStatus.PENDING,
        );
        final List<InvitationWithProject> invites = [];
        for (final app in apps) {
          final project = await projectService.fetchProjectById(app.projectId, token);
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
            token: token,
            status: ProjectStatus.IN_PROGRESS,
          );
        } else if (tabIndex == 1) {
          final ids = await dashboardService.getMyResponseProjectIds(
            token: token,
            status: ProjectApplicationStatus.PENDING,
          );
          projects = await _loadProjectsByIds(ids);
        } else {
          projects = await dashboardService.getFreelancerProjects(
            token: token,
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
        out.add(await projectService.fetchProjectById(id, token));
      } catch (_) {}
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
        token: token,
        projectId: projectId,
        applicationId: applicationId,
        status: accept
            ? ProjectApplicationStatus.APPROVED
            : ProjectApplicationStatus.DECLINED,
      );
      await loadTab(2);
    } catch (e) {
    }
  }
}