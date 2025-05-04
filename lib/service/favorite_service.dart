import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/project/project.dart';

class FavoriteService {
  final ApiClient _api;

  FavoriteService({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient(baseUrl: Routes.apiBase);

  Future<List<Project>> fetchFavoriteProjects(String token) async {
    return _api.get<List<Project>>(
      '/favorites/projects',
      token: token,
      decoder: (json) {
        final list = json as List<dynamic>;
        return list.map((e) => Project.fromJson(e as Map<String, dynamic>)).toList();
      },
    );
  }

  Future<void> addFavoriteProject(int projectId, String token) async {
    await _api.post<void>(
      '/favorites/projects/$projectId',
      token: token,
      expectCode: 201,
    );
  }

  Future<void> removeFavoriteProject(int projectId, String token) async {
    await _api.delete<void>(
      '/favorites/projects/$projectId',
      token: token,
      expectCode: 204,
    );
  }
}