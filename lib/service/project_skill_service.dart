import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import 'package:jobsy/model/skill/skill.dart';

class ProjectSkillService {
  final ApiClient _api;

  ProjectSkillService({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient(baseUrl: Routes.apiBase);

  Future<List<Skill>> fetchProjectSkills({
    required String token,
    required int projectId,
  }) async {
    final path = '/projects/$projectId/skills';
    return _api.get<List<Skill>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> addSkillToProject({
    required String token,
    required int projectId,
    required int skillId,
  }) async {
    final path = '/projects/$projectId/skills/$skillId';
    await _api.post<void>(
      path,
      token: token,
      expectCode: 201,
      decoder: (_) {},
    );
  }

  Future<void> removeSkillFromProject({
    required String token,
    required int projectId,
    required int skillId,
  }) async {
    final path = '/projects/$projectId/skills/$skillId';
    await _api.delete<void>(
      path,
      token: token,
      expectCode: 204,
      decoder: (_) {},
    );
  }
}