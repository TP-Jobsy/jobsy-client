import 'dart:convert';
import 'package:http/http.dart' as http;

typedef JsonDecoder<T> = T Function(dynamic json);
typedef TokenGetter = Future<String?> Function();
typedef TokenRefresher = Future<void> Function();

class ApiClient {
  final String baseUrl;
  final http.Client _http;
  final TokenGetter _getToken;
  final TokenRefresher _refreshToken;

  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
  }) : _http = httpClient ?? http.Client(),
       _getToken = getToken,
       _refreshToken = refreshToken;

  Map<String, String> _headers(String? token) {
    final h = {'Content-Type': 'application/json'};
    if (token != null) h['Authorization'] = 'Bearer $token';
    return h;
  }

  Future<T> get<T>(
    String path, {
    JsonDecoder<T>? decoder,
    Map<String, dynamic>? queryParameters,
    int expectCode = 200,
  }) {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParameters?.map(
        (k, v) => MapEntry(k, v is List ? v.join(',') : v.toString()),
      ),
    );
    return _withAuthRetry<T>(
      () => _http.get(uri, headers: _headers(_currentToken)),
      decoder,
      expectCode,
    );
  }

  Future<T> post<T>(
    String path, {
    dynamic body,
    JsonDecoder<T>? decoder,
    int expectCode = 200,
  }) {
    final uri = Uri.parse('$baseUrl$path');
    return _withAuthRetry<T>(
      () => _http.post(
        uri,
        headers: _headers(_currentToken),
        body: body == null ? null : jsonEncode(body),
      ),
      decoder,
      expectCode,
    );
  }

  Future<T> put<T>(
    String path, {
    dynamic body,
    JsonDecoder<T>? decoder,
    int expectCode = 200,
  }) {
    final uri = Uri.parse('$baseUrl$path');
    return _withAuthRetry<T>(
      () => _http.put(
        uri,
        headers: _headers(_currentToken),
        body: jsonEncode(body),
      ),
      decoder,
      expectCode,
    );
  }

  Future<T> delete<T>(
    String path, {
    JsonDecoder<T>? decoder,
    int expectCode = 200,
  }) {
    final uri = Uri.parse('$baseUrl$path');
    return _withAuthRetry<T>(
      () => _http.delete(uri, headers: _headers(_currentToken)),
      decoder,
      expectCode,
    );
  }

  Future<T> patch<T>(
    String path, {
    dynamic body,
    JsonDecoder<T>? decoder,
    int expectCode = 200,
  }) {
    final uri = Uri.parse('$baseUrl$path');
    return _withAuthRetry<T>(
      () => _http.patch(
        uri,
        headers: _headers(_currentToken),
        body: body == null ? null : jsonEncode(body),
      ),
      decoder,
      expectCode,
    );
  }

  String? _currentToken;

  Future<T> _withAuthRetry<T>(
    Future<http.Response> Function() requestFn,
    JsonDecoder<T>? decoder,
    int expectCode,
  ) async {
    _currentToken = await _getToken();

    http.Response res = await requestFn();
    if (res.statusCode == 401) {
      await _refreshToken();
      _currentToken = await _getToken();
      res = await requestFn();
    }

    final body = utf8.decode(res.bodyBytes);
    if (res.statusCode != expectCode) {
      late String error;
      try {
        final jsonBody = jsonDecode(body);
        if (jsonBody is Map) {
          error =
              (jsonBody['message'] ?? jsonBody['error'])?.toString() ??
              'Ошибка ${res.statusCode}';
        } else {
          error = 'Ошибка ${res.statusCode}';
        }
      } catch (_) {
        error = 'Ошибка ${res.statusCode}: $body';
      }
      throw Exception(error);
    }

    if (decoder == null) {
      return null as T;
    }
    return decoder(jsonDecode(body));
  }
}
