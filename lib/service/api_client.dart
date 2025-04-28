import 'dart:convert';
import 'package:http/http.dart' as http;

typedef JsonDecoder<T> = T Function(dynamic json);

class ApiClient {
  final String baseUrl;
  final http.Client _http;

  ApiClient({required this.baseUrl, http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  Map<String, String> _headers([String? token]) {
    final h = {'Content-Type': 'application/json'};
    if (token != null) h['Authorization'] = 'Bearer $token';
    return h;
  }

  Future<T> get<T>(
      String path, {
        String? token,
        JsonDecoder<T>? decoder,
        int expectCode = 200,
      }) async {
    final res = await _http.get(Uri.parse('$baseUrl$path'), headers: _headers(token));
    return _process<T>(res, decoder, expectCode);
  }

  Future<T> post<T>(
      String path, {
        String? token,
        dynamic body,
        JsonDecoder<T>? decoder,
        int expectCode = 200,
      }) async {
    final res = await _http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
    return _process<T>(res, decoder, expectCode);
  }

  Future<T> put<T>(
      String path, {
        String? token,
        dynamic body,
        JsonDecoder<T>? decoder,
        int expectCode = 200,
      }) async {
    final res = await _http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _process<T>(res, decoder, expectCode);
  }

  T _process<T>(
      http.Response res,
      JsonDecoder<T>? decoder,
      int expectCode,
      ) {
    if (res.statusCode != expectCode) {
      throw Exception('Ошибка ${res.statusCode}: ${res.body}');
    }
    if (decoder == null) {
      return Future.value() as T;
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes));
    return decoder(json);
  }
}
