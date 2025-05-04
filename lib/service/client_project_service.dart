import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/enum/project-status.dart';

import '../model/project/project_create.dart';
import '../model/project/project_update.dart';

class ClientProjectService {
  final ApiClient _api;

  ClientProjectService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<List<Project>> getAllProjects({
    required String token,
    ProjectStatus? status,
  }) {
    final path = status != null
        ? '/projects?status=${status.name}'
        : '/projects';

    return _api.get<List<Project>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Project> getProjectById({
    required String token,
    required int projectId,
  }) {
    return _api.get<Project>(
      '/projects/$projectId',
      token: token,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> createProject({
    required String token,
    required ProjectCreate dto,
  }) {
    return _api.post<Project>(
      '/projects',
      token: token,
      body: dto.toJson(),
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
      expectCode: 201,
    );
  }

  Future<Project> updateProject({
    required String token,
    required int projectId,
    required ProjectUpdate dto,
  }) {
    return _api.put<Project>(
      '/projects/$projectId',
      token: token,
      body: dto.toJson(),
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteProject({
    required String token,
    required int projectId,
  }) {
    return _api.delete<void>(
      '/projects/$projectId',
      token: token,
      expectCode: 204,
    );
  }
}