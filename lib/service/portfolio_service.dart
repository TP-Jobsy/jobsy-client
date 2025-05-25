import '../model/portfolio/portfolio.dart';
import '../util/routes.dart';
import 'api_client.dart';

class PortfolioService {
  final ApiClient _api;

  PortfolioService({
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

  Future<List<FreelancerPortfolioDto>> fetchPortfolio() {
    return _api.get<List<FreelancerPortfolioDto>>(
      '/profile/freelancer/portfolio',
      decoder:
          (json) =>
              (json as List)
                  .map(
                    (e) => FreelancerPortfolioDto.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
    );
  }

  Future<FreelancerPortfolioDto> createPortfolio(
    FreelancerPortfolioCreateDto dto,
  ) {
    return _api.post<FreelancerPortfolioDto>(
      '/profile/freelancer/portfolio',
      body: dto.toJson(),
      decoder:
          (json) =>
              FreelancerPortfolioDto.fromJson(json as Map<String, dynamic>),
      expectCode: 201,
    );
  }

  Future<FreelancerPortfolioDto> updatePortfolio(
    int id,
    FreelancerPortfolioUpdateDto dto,
  ) {
    return _api.put<FreelancerPortfolioDto>(
      '/profile/freelancer/portfolio/$id',
      body: dto.toJson(),
      decoder:
          (json) =>
              FreelancerPortfolioDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deletePortfolio(int id) {
    return _api.delete<void>(
      '/profile/freelancer/portfolio/$id',
      expectCode: 204,
    );
  }
}
