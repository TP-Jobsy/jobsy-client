// lib/service/project_service.dart
import '../model/category_dto.dart';
import '../model/specialization_dto.dart';
import '../model/skill_dto.dart';
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

  Future<List<SkillDto>> autocompleteSkills(
      String query, String token) {
    return _api.get<List<SkillDto>>(
      '/skills/autocomplete?query=$query',
      token: token,
      decoder: (json) =>
          (json as List).map((e) => SkillDto.fromJson(e)).toList(),
    );
  }

  Future<List<Map<String, dynamic>>> fetchMyProjects(
      String token, {
        String status = 'OPEN',
      }) {
    return _api.get<List<Map<String, dynamic>>>(
    '/projects/me?status=$status',
    token: token,
    decoder: (json) => (json as List).map((raw) {
      final m = Map<String, dynamic>.from(raw);
      m['category'] =
          CategoryDto.fromJson(m['category'] as Map<String, dynamic>);
      m['specialization'] =
          SpecializationDto.fromJson(m['specialization'] as Map<String, dynamic>);
      return m;
    }).toList(),
    );
  }
}
