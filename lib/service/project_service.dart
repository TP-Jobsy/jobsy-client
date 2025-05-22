import '../model/category/category.dart';
import '../model/project/page_response.dart';
import '../model/project/project.dart';
import '../model/project/project_list_item.dart';
import '../model/specialization/specialization.dart';
import '../model/skill/skill.dart';
import '../util/routes.dart';
import 'api_client.dart';

class ProjectService {
  final ApiClient _api;
  ProjectService({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient(baseUrl: Routes.apiBase);

  Future<Project> createDraft(
      Map<String, dynamic> data,
      String token,
      ) {
    return _api.post<Project>(
      '/projects/drafts',
      token: token,
      body: data,
      expectCode: 201,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> updateDraft(
      int draftId,
      Map<String, dynamic> data,
      String token,
      ) {
    return _api.put<Project>(
      '/projects/$draftId/draft',
      token: token,
      body: data,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> publishDraft(
      int draftId,
      Map<String, dynamic> data,
      String token,
      ) {
    return _api.post<Project>(
      '/projects/$draftId/publish',
      token: token,
      body: data,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> updateProject(
      int projectId,
      Map<String, dynamic> data,
      String token,
      ) {
    return _api.put<Project>(
      '/projects/$projectId',
      token: token,
      body: data,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteProject(int projectId, String token) {
    return _api.delete<void>(
      '/projects/$projectId',
      token: token,
      expectCode: 204,
    );
  }

  Future<Project> fetchProjectById(int projectId, String token) {
    return _api.get<Project>(
      '/projects/$projectId',
      token: token,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PageResponse<ProjectListItem>> fetchProjectListItems({
    String? status,
    required String token,
    int page = 0,
    int size = 20,
  }) {
    final params = <String, dynamic>{
      if (status != null) 'status': status,
      'page': page,
      'size': size,
    };
    return _api.get<PageResponse<ProjectListItem>>(
      '/projects',
      token: token,
      queryParameters: params,
      decoder: (json) => PageResponse.fromJson(
        json as Map<String, dynamic>,
            (item) => ProjectListItem.fromJson(item),
      ),
    );
  }

  Future<List<Category>> fetchCategories(String token) {
    return _api.get<List<Category>>(
      '/categories',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => Category.fromJson(e)).toList(),
    );
  }

  Future<List<Specialization>> fetchSpecializations(
      int categoryId, String token) {
    return _api.get<List<Specialization>>(
      '/categories/$categoryId/specializations',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => Specialization.fromJson(e)).toList(),
    );
  }

  Future<List<Skill>> autocompleteSkills(String query, String token) {
    return _api.get<List<Skill>>(
      '/skills/autocomplete?query=$query',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => Skill.fromJson(e)).toList(),
    );
  }

  Future<List<Skill>> fetchPopularSkills(String token) {
    return _api.get<List<Skill>>(
      '/skills/autocomplete',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => Skill.fromJson(e)).toList(),
    );
  }

  Future<Project> completeByClient({
    required String token,
    required int projectId,
  }) {
    return _api.patch<Project>(
      '/projects/$projectId/complete/client',
      token: token,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> completeByFreelancer({
    required String token,
    required int projectId,
  }) {
    return _api.patch<Project>(
      '/projects/$projectId/complete/freelancer',
      token: token,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }
}