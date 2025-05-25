import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/model/project/project_application.dart';
import 'package:jobsy/model/project/project_detail.dart';
import 'package:jobsy/enum/project-status.dart';
import 'package:jobsy/enum/project-application-status.dart';

class DashboardService {
  final ApiClient _api;

  DashboardService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    ApiClient? client,
  }) : _api =
           client ??
           ApiClient(
             baseUrl: Routes.apiBase,
             getToken: getToken,
             refreshToken: refreshToken,
           );

  Future<List<Project>> getClientProjects({ProjectStatus? status}) {
    var path = '/dashboard/client/projects';
    if (status != null) path += '?status=${status.name}';
    return _api.get<List<Project>>(
      path,
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Project.fromJson(e as Map<String, dynamic>))
                  .toList(),
    );
  }

  Future<ProjectDetail> getClientProjectDetail(int projectId) {
    return _api.get<ProjectDetail>(
      '/dashboard/client/projects/$projectId',
      decoder: (json) => ProjectDetail.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<List<Project>> getFreelancerProjects({ProjectStatus? status}) {
    var path = '/dashboard/freelancer/projects';
    if (status != null) path += '?status=${status.name}';
    return _api.get<List<Project>>(
      path,
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Project.fromJson(e as Map<String, dynamic>))
                  .toList(),
    );
  }

  Future<List<int>> getMyResponseProjectIds({
    ProjectApplicationStatus? status,
  }) async {
    final responses = await getMyResponses(status: status);
    return responses.map((r) => r.projectId).toList();
  }

  Future<List<int>> getMyInvitationProjectIds({
    ProjectApplicationStatus? status,
  }) async {
    final invites = await getMyInvitations(status: status);
    return invites.map((i) => i.projectId).toList();
  }

  Future<List<ProjectApplication>> getMyResponses({
    ProjectApplicationStatus? status,
  }) {
    var path = '/dashboard/freelancer/responses';
    if (status != null) path += '?status=${status.name}';
    return _api.get<List<ProjectApplication>>(
      path,
      decoder:
          (json) =>
              (json as List)
                  .map(
                    (e) =>
                        ProjectApplication.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
    );
  }

  Future<List<ProjectApplication>> getMyInvitations({
    ProjectApplicationStatus? status,
  }) {
    var path = '/dashboard/freelancer/invitations';
    if (status != null) path += '?status=${status.name}';
    return _api.get<List<ProjectApplication>>(
      path,
      decoder:
          (json) =>
              (json as List)
                  .map(
                    (e) =>
                        ProjectApplication.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
    );
  }

  Future<List<Project>> getFreelancerProjectsByApplicationStatus({
    required ProjectApplicationStatus status,
    bool isInvitation = false,
  }) async {
    final base =
        isInvitation
            ? '/dashboard/freelancer/invitations'
            : '/dashboard/freelancer/responses';
    final path = '$base?status=${status.name}';

    final applications = await _api.get<List<ProjectApplication>>(
      path,
      decoder:
          (json) =>
              (json as List)
                  .map(
                    (e) =>
                        ProjectApplication.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
    );

    final projectIds = applications.map((app) => app.projectId).toList();
    return _api.post<List<Project>>(
      '/projects/batch',
      body: {'ids': projectIds},
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Project.fromJson(e as Map<String, dynamic>))
                  .toList(),
    );
  }
}
