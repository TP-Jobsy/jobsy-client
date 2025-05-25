import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/enum/project-status.dart';

import '../model/project/project_create.dart';
import '../model/project/project_update.dart';

class ClientProjectService {
  final ApiClient _api;

  ClientProjectService({
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

  Future<List<Project>> getAllProjects({ProjectStatus? status}) {
    final query = status != null ? '?status=${status.name}' : '';
    return _api.get<List<Project>>(
      '/projects$query',
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Project.fromJson(e as Map<String, dynamic>))
                  .toList(),
    );
  }

  Future<Project> getProjectById(int projectId) {
    return _api.get<Project>(
      '/projects/$projectId',
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> createProject(ProjectCreate dto) {
    return _api.post<Project>(
      '/projects',
      body: dto.toJson(),
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
      expectCode: 201,
    );
  }

  Future<Project> updateProject(int projectId, ProjectUpdate dto) {
    return _api.put<Project>(
      '/projects/$projectId',
      body: dto.toJson(),
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteProject(int projectId) {
    return _api.delete<void>('/projects/$projectId', expectCode: 204);
  }
}
