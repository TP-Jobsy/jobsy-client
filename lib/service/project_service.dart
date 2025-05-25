import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../enum/project-status.dart';
import '../model/category/category.dart';
import '../model/project/page_response.dart';
import '../model/project/project.dart';
import '../model/project/project_list_item.dart';
import '../model/specialization/specialization.dart';
import '../model/skill/skill.dart';

class ProjectService {
  final ApiClient _api;

  ProjectService({
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

  Future<Project> createDraft(Map<String, dynamic> data) {
    return _api.post<Project>(
      '/projects/drafts',
      body: data,
      expectCode: 201,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> updateDraft(int draftId, Map<String, dynamic> data) {
    return _api.put<Project>(
      '/projects/$draftId/draft',
      body: data,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> publishDraft(int draftId, Map<String, dynamic> data) {
    return _api.post<Project>(
      '/projects/$draftId/publish',
      body: data,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> updateProject(int projectId, Map<String, dynamic> data) {
    return _api.put<Project>(
      '/projects/$projectId',
      body: data,
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteProject(int projectId) {
    return _api.delete<void>('/projects/$projectId', expectCode: 204);
  }

  Future<Project> fetchProjectById(int projectId) {
    return _api.get<Project>(
      '/projects/$projectId',
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PageResponse<ProjectListItem>> fetchProjectListItems({
    String? status,
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
      queryParameters: params,
      decoder:
          (json) => PageResponse.fromJson(
            json as Map<String, dynamic>,
            (item) => ProjectListItem.fromJson(item),
          ),
    );
  }

  Future<List<Project>> fetchMyProjects({ProjectStatus? status}) async {
    final query = status != null ? '?status=${status.name}' : '';
    return _api.get<List<Project>>(
      '/projects/me$query',
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Project.fromJson(e as Map<String, dynamic>))
                  .toList(),
      expectCode: 200,
    );
  }

  Future<List<Category>> fetchCategories() {
    return _api.get<List<Category>>(
      '/categories',
      decoder:
          (json) => (json as List).map((e) => Category.fromJson(e)).toList(),
    );
  }

  Future<List<Specialization>> fetchSpecializations(int categoryId) {
    return _api.get<List<Specialization>>(
      '/categories/$categoryId/specializations',
      decoder:
          (json) =>
              (json as List).map((e) => Specialization.fromJson(e)).toList(),
    );
  }

  Future<List<Skill>> autocompleteSkills(String query) {
    return _api.get<List<Skill>>(
      '/skills/autocomplete',
      queryParameters: {'query': query},
      decoder: (json) => (json as List).map((e) => Skill.fromJson(e)).toList(),
    );
  }

  Future<List<Skill>> fetchPopularSkills() {
    return _api.get<List<Skill>>(
      '/skills/autocomplete',
      decoder: (json) => (json as List).map((e) => Skill.fromJson(e)).toList(),
    );
  }

  Future<Project> completeByClient(int projectId) {
    return _api.patch<Project>(
      '/projects/$projectId/complete/client',
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Project> completeByFreelancer(int projectId) {
    return _api.patch<Project>(
      '/projects/$projectId/complete/freelancer',
      decoder: (json) => Project.fromJson(json as Map<String, dynamic>),
    );
  }
}
