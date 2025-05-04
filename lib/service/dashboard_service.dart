import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/model/project/project_application.dart';
import 'package:jobsy/enum/project-status.dart';
import 'package:jobsy/enum/project-application-status.dart';

import '../model/project/project_detail.dart';

class DashboardService {
  final ApiClient _api;

  DashboardService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<List<Project>> getClientProjects({
    required String token,
    required int clientId,
    ProjectStatus? status,
  }) {
    var path = '/dashboard/client/projects/$clientId';
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
    required int freelancerId,
    ProjectStatus? status,
  }) {
    var path = '/dashboard/freelancer/projects/$freelancerId';
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

  Future<List<ProjectApplication>> myResponses({
    required String token,
    required int freelancerId,
    ProjectApplicationStatus? status,
  }) {
    var path = '/dashboard/freelancer/responses/$freelancerId';
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

  Future<List<ProjectApplication>> myInvitations({
    required String token,
    required int freelancerId,
    ProjectApplicationStatus? status,
  }) {
    var path = '/dashboard/freelancer/invitations/$freelancerId';
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
}