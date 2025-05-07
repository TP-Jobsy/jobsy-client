import '../util/routes.dart';
import 'api_client.dart';

class AiService {
  final ApiClient _api;

  AiService({ApiClient? api})
      : _api = api ?? ApiClient(baseUrl: Routes.apiBase);

  Future<String> generateDescription({
    required String token,
    required int projectId,
    required String userPrompt,
  }) async {
    final Map<String, dynamic> json = await _api.post<Map<String, dynamic>>(
      '/projects/$projectId/ai/description',
      token: token,
      body: {'userPrompt': userPrompt},
      decoder: (dynamic json) => json as Map<String, dynamic>,
      expectCode: 200,
    );

    final generated = json['generatedDescription'];
    if (generated is String) {
      return generated;
    }
    throw Exception('Неверный формат ответа AI: $json');
  }
}