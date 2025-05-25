import '../util/routes.dart';
import 'api_client.dart';

class AiService {
  final ApiClient _api;

  AiService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    ApiClient? api,
  }) : _api =
           api ??
           ApiClient(
             baseUrl: Routes.apiBase,
             getToken: getToken,
             refreshToken: refreshToken,
           );

  Future<String> generateDescription({
    required int projectId,
    required String userPrompt,
  }) async {
    final Map<String, dynamic> json = await _api.post<Map<String, dynamic>>(
      '/projects/$projectId/ai/description',
      body: {'userPrompt': userPrompt},
      decoder: (dynamic json) => json as Map<String, dynamic>,
    );

    final generated = json['generatedDescription'];
    if (generated is String) {
      return generated;
    }
    throw Exception('Неверный формат ответа AI: $json');
  }
}
