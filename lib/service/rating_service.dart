import 'package:jobsy/model/rating/rating_response_dto.dart';

import '../util/routes.dart';
import 'api_client.dart';

class RatingService {
  final ApiClient _api;

  RatingService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    ApiClient? client,
  }) : _api =
           client ??
           ApiClient(
             baseUrl: Routes.apiBase,
             getToken: getToken,
             refreshToken: refreshToken,
           );

  Future<void> rateProject(int projectId, double score) {
    return _api.post<void>(
      '/projects/$projectId/rating',
      body: {'score': score},
      expectCode: 201,
    );
  }

  Future<List<RatingResponseDto>> getRatings(int projectId) {
    return _api.get<List<RatingResponseDto>>(
      '/projects/$projectId/rating',
      decoder:
          (json) =>
              (json as List)
                  .map(
                    (e) =>
                        RatingResponseDto.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
    );
  }
}
