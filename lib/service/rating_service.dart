import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';

import '../model/rating/rating_response_dto.dart';

class RatingService {
  final ApiClient _api;
  RatingService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<void> rateProject({
    required String token,
    required int projectId,
    required double score,
  }) {
    return _api.post<void>(
      '/projects/$projectId/rating',
      token: token,
      body: {'score': score},
      expectCode: 201,
    );
  }

  Future<List<RatingResponseDto>> getRatings({
    required String token,
    required int projectId,
  }) {
    return _api.get<List<RatingResponseDto>>(
      '/projects/$projectId/rating',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => RatingResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}