import '../model/category/category.dart';
import '../model/project/project_application.dart';
import '../model/specialization/specialization.dart';
import '../model/skill/skill.dart';
import '../util/routes.dart';
import 'api_client.dart';

class ProjectService {
  final ApiClient _api;
  ProjectService({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient(baseUrl: Routes.apiBase);

  Future<void> createProject(Map<String, dynamic> data, String token) {
    return _api.post<void>(
      '/projects',
      token: token,
      body: data,
      expectCode: 201,
    );
  }

  Future<void> deleteProject(int id, String token) {
    return _api.delete<void>(
      '/projects/$id',
      token: token,
      expectCode: 204,
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
        m['category'] = Category.fromJson(m['category'] as Map<String, dynamic>);
        m['specialization'] = Specialization.fromJson(m['specialization'] as Map<String, dynamic>);
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
        m['category'] = Category.fromJson(m['category'] as Map<String, dynamic>);
        m['specialization'] = Specialization.fromJson(m['specialization'] as Map<String, dynamic>);
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
