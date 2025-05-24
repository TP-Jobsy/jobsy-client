import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/model/project/project_application.dart';
import 'package:jobsy/model/project/project_detail.dart';
import 'package:jobsy/enum/project-status.dart';
import 'package:jobsy/enum/project-application-status.dart';

class DashboardService {
  final ApiClient _api;

  DashboardService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);


  Future<List<Project>> getClientProjects({
    required String token,
    ProjectStatus? status,
  }) {
    var path = '/dashboard/client/projects';
    if (status != null) {
      path += '?status=${status.name}';
    }
    return _api.get<List<Project>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ProjectDetail> getClientProjectDetail({
    required String token,
    required int projectId,
  }) {
    return _api.get<ProjectDetail>(
      '/dashboard/client/projects/$projectId',
      token: token,
      decoder: (json) =>
          ProjectDetail.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<List<Project>> getFreelancerProjects({
    required String token,
    ProjectStatus? status,
  }) {
    var path = '/dashboard/freelancer/projects';
    if (status != null) {
      path += '?status=${status.name}';
    }
    return _api.get<List<Project>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }


  Future<List<int>> getMyResponseProjectIds({
    required String token,
    ProjectApplicationStatus? status,
  }) async {
    final responses = await getMyResponses(token: token, status: status);
    return responses.map((r) => r.projectId).toList();
  }

  Future<List<int>> getMyInvitationProjectIds({
    required String token,
    ProjectApplicationStatus? status,
  }) async {
    final invitations = await getMyInvitations(token: token, status: status);
    return invitations.map((i) => i.projectId).toList();
  }


  Future<List<ProjectApplication>> getMyResponses({
    required String token,
    ProjectApplicationStatus? status,
  }) {
    var path = '/dashboard/freelancer/responses';
    if (status != null) {
      path += '?status=${status.name}';
    }
    return _api.get<List<ProjectApplication>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) => ProjectApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<List<ProjectApplication>> getMyInvitations({
    required String token,
    ProjectApplicationStatus? status,
  }) {
    var path = '/dashboard/freelancer/invitations';
    if (status != null) {
      path += '?status=${status.name}';
    }
    return _api.get<List<ProjectApplication>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) => ProjectApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }


  Future<List<Project>> getFreelancerProjectsByApplicationStatus({
    required String token,
    required ProjectApplicationStatus status,
    bool isInvitation = false,
  }) async {
    final path = isInvitation
        ? '/dashboard/freelancer/invitations'
        : '/dashboard/freelancer/responses';

    final applications = await _api.get<List<ProjectApplication>>(
      '$path?status=${status.name}',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => ProjectApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );


    return [];
  }
}