import 'package:jobsy/service/api_client.dart';
import '../model/skill/skill.dart';
import '../util/routes.dart';

class PortfolioSkillService {
  final ApiClient _api;

  PortfolioSkillService({
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

  Future<List<Skill>> fetchPortfolioSkills(int portfolioId) {
    return _api.get<List<Skill>>(
      '/profile/freelancer/portfolio/$portfolioId/skills',
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Skill.fromJson(e as Map<String, dynamic>))
                  .toList(),
    );
  }

  Future<void> addSkillToPortfolio(int portfolioId, int skillId) {
    return _api.post<void>(
      '/profile/freelancer/portfolio/$portfolioId/skills/$skillId',
      expectCode: 201,
    );
  }

  Future<void> removeSkillFromPortfolio(int portfolioId, int skillId) {
    return _api.delete<void>(
      '/profile/freelancer/portfolio/$portfolioId/skills/$skillId',
      expectCode: 204,
    );
  }
}
