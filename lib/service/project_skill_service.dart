import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../model/skill/skill.dart';

class ProjectSkillService {
  final ApiClient _api;

  ProjectSkillService({
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

  Future<List<Skill>> fetchProjectSkills(int projectId) async {
    final path = '/projects/$projectId/skills';
    return _api.get<List<Skill>>(
      path,
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Skill.fromJson(e as Map<String, dynamic>))
                  .toList(),
    );
  }

  Future<void> addSkillToProject(int projectId, int skillId) async {
    final path = '/projects/$projectId/skills/$skillId';
    await _api.post<void>(path, expectCode: 201);
  }

  Future<void> removeSkillFromProject(int projectId, int skillId) async {
    final path = '/projects/$projectId/skills/$skillId';
    await _api.delete<void>(path, expectCode: 204);
  }
}
