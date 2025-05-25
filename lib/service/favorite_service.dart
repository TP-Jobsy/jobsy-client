import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/project/project.dart';
import '../model/profile/free/freelancer_profile_dto.dart';

class FavoriteService {
  final ApiClient _api;

  FavoriteService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    ApiClient? apiClient,
  }) : _api =
           apiClient ??
           ApiClient(
             baseUrl: Routes.apiBase,
             getToken: getToken,
             refreshToken: refreshToken,
           );

  Future<List<Project>> fetchFavoriteProjects() async {
    return _api.get<List<Project>>(
      '/favorites/projects',
      decoder: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<void> addFavoriteProject(int projectId) async {
    await _api.post<void>('/favorites/projects/$projectId', expectCode: 201);
  }

  Future<void> removeFavoriteProject(int projectId) async {
    await _api.delete<void>('/favorites/projects/$projectId', expectCode: 204);
  }

  Future<List<FreelancerProfile>> fetchFavoriteFreelancers() async {
    return _api.get<List<FreelancerProfile>>(
      '/favorites/freelancers',
      decoder: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) => FreelancerProfile.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<void> addFavoriteFreelancer(int freelancerId) async {
    await _api.post<void>(
      '/favorites/freelancers/$freelancerId',
      expectCode: 201,
    );
  }

  Future<void> removeFavoriteFreelancer(int freelancerId) async {
    await _api.delete<void>(
      '/favorites/freelancers/$freelancerId',
      expectCode: 204,
    );
  }
}
