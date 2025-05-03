import '../model/category.dart';
import '../model/project_application.dart';
import '../model/specialization.dart';
import '../model/skill.dart';
import 'api_client.dart';

class ProjectService {
  static const _base = 'https://jobsyapp.ru/api';

  final ApiClient _api = ApiClient(baseUrl: _base);

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

  Future<List<CategoryDto>> fetchCategories(String token) {
    return _api.get<List<CategoryDto>>(
      '/categories',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => CategoryDto.fromJson(e)).toList(),
    );
  }

  Future<List<SpecializationDto>> fetchSpecializations(
      int categoryId, String token) {
    return _api.get<List<SpecializationDto>>(
      '/categories/$categoryId/specializations',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => SpecializationDto.fromJson(e)).toList(),
    );
  }

  Future<List<SkillDto>> autocompleteSkills(String query, String token) {
    return _api.get<List<SkillDto>>(
      '/skills/autocomplete?query=$query',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => SkillDto.fromJson(e)).toList(),
    );
  }

  Future<List<SkillDto>> fetchPopularSkills(String token) {
    return _api.get<List<SkillDto>>(
      '/skills/autocomplete',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => SkillDto.fromJson(e)).toList(),
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
        m['category'] = CategoryDto.fromJson(m['category'] as Map<String, dynamic>);
        m['specialization'] = SpecializationDto.fromJson(m['specialization'] as Map<String, dynamic>);
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
        m['category'] = CategoryDto.fromJson(m['category'] as Map<String, dynamic>);
        m['specialization'] = SpecializationDto.fromJson(m['specialization'] as Map<String, dynamic>);
        return m;
      }).toList(),
    );
  }


  Future<List<ProjectApplicationDto>> fetchMyResponses(
      String token, {
        String? status,
      }) {
    final q = status != null ? '?status=$status' : '';
    return _api.get<List<ProjectApplicationDto>>(
      '/dashboard/freelancer/responses$q',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => ProjectApplicationDto.fromJson(e))
          .toList(),
    );
  }


  Future<List<ProjectApplicationDto>> fetchMyInvitations(
      String token, {
        String? status,
      }) {
    final q = status != null ? '?status=$status' : '';
    return _api.get<List<ProjectApplicationDto>>(
      '/dashboard/freelancer/invitations$q',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => ProjectApplicationDto.fromJson(e))
          .toList(),
    );
  }
}
