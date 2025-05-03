import 'package:jobsy/service/api_client.dart';
import '../model/portfolio.dart';

class PortfolioService {
  static const _base = 'https://jobsyapp.ru/api';

  final ApiClient _api = ApiClient(baseUrl: _base);

  Future<List<FreelancerPortfolioDto>> fetchPortfolio(String token) {
    return _api.get<List<FreelancerPortfolioDto>>(
      '/profile/freelancer/portfolio',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => FreelancerPortfolioDto.fromJson(e))
          .toList(),
    );
  }

  Future<FreelancerPortfolioDto> createPortfolio(
      String token,
      FreelancerPortfolioCreateDto dto,
      ) {
    return _api.post<FreelancerPortfolioDto>(
      '/profile/freelancer/portfolio',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerPortfolioDto.fromJson(json),
      expectCode: 201,
    );
  }

  Future<FreelancerPortfolioDto> updatePortfolio(
      String token,
      int id,
      FreelancerPortfolioUpdateDto dto,
      ) {
    return _api.put<FreelancerPortfolioDto>(
      '/profile/freelancer/portfolio/$id',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerPortfolioDto.fromJson(json),
    );
  }

  Future<void> deletePortfolio(int id, String token) {
    return _api.delete<void>(
      '/profile/freelancer/portfolio/$id',
      token: token,
      expectCode: 204,
    );
  }
}