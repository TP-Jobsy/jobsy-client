import '../model/category/category.dart';
import '../model/project/project.dart';
import '../model/project/project_application.dart';
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

  Future<void> deleteProject(int id, String token) {
    return _api.delete<void>(
      '/projects/$id',
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

  Future<List<Project>> fetchProjects({
    String? status,
    required String token,
  }) {
    final query = status != null ? '?status=$status' : '';
    return _api.get<List<Project>>(
      '/projects$query',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
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

  Future<List<Map<String, dynamic>>> fetchClientProjects(
      String token, {
        String? status,
      }) {
    final query = status != null ? '?status=$status' : '';
    return _api.get<List<Map<String, dynamic>>>(
      '/dashboard/client/projects$query',
      token: token,
      decoder: (json) => (json as List).map((raw) {
        final m = Map<String, dynamic>.from(raw as Map);
        m['category'] =
            Category.fromJson(m['category'] as Map<String, dynamic>);
        m['specialization'] = Specialization.fromJson(
            m['specialization'] as Map<String, dynamic>);
        return m;
      }).toList(),
    );
  }

  Future<List<Map<String, dynamic>>> fetchFreelancerProjects(
      String token, {
        String? status,
      }) {
    final query = status != null ? '?status=$status' : '';
    return _api.get<List<Map<String, dynamic>>>(
      '/dashboard/freelancer/projects$query',
      token: token,
      decoder: (json) => (json as List).map((raw) {
        final m = Map<String, dynamic>.from(raw as Map);
        m['category'] =
            Category.fromJson(m['category'] as Map<String, dynamic>);
        m['specialization'] = Specialization.fromJson(
            m['specialization'] as Map<String, dynamic>);
        return m;
      }).toList(),
    );
  }

  Future<List<ProjectApplication>> fetchMyResponses(
      String token, {
        String? status,
      }) {
    final q = status != null ? '?status=$status' : '';
    return _api.get<List<ProjectApplication>>(
      '/dashboard/freelancer/responses$q',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => ProjectApplication.fromJson(e))
          .toList(),
    );
  }

  Future<List<ProjectApplication>> fetchMyInvitations(
      String token, {
        String? status,
      }) {
    final q = status != null ? '?status=$status' : '';
    return _api.get<List<ProjectApplication>>(
      '/dashboard/freelancer/invitations$q',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => ProjectApplication.fromJson(e))
          .toList(),
    );
  }
}