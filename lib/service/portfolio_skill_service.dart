import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/model/skill/skill.dart';

class PortfolioSkillService {
  static const _base = 'https://jobsyapp.ru/api';
  final ApiClient _api = ApiClient(baseUrl: _base);

  Future<List<Skill>> fetchPortfolioSkills(int portfolioId, String token) {
    return _api.get<List<Skill>>(
      '/profile/freelancer/portfolio/$portfolioId/skills',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> addSkillToPortfolio(int portfolioId, int skillId, String token) {
    return _api.post<void>(
      '/profile/freelancer/portfolio/$portfolioId/skills/$skillId',
      token: token,
      expectCode: 201,
    );
  }

  Future<void> removeSkillFromPortfolio(int portfolioId, int skillId, String token) {
    return _api.delete<void>(
      '/profile/freelancer/portfolio/$portfolioId/skills/$skillId',
      token: token,
      expectCode: 204,
    );
  }
}