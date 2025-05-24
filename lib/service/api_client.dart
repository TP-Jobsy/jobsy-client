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
        Map<String, dynamic>? queryParameters,
        int expectCode = 200,
      }) async {
    final headersMap = _headers(token);

    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: queryParameters?.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.join(','));
        }
        return MapEntry(key, value.toString());
      }),
    );
    print('📡 [HTTP] GET $uri');
    print('📋 headers: $headersMap');
    final res = await _http.get(uri, headers: headersMap);
    final body = utf8.decode(res.bodyBytes);
    print('📌 [HTTP] Response ${res.statusCode}: $body');
    return _process<T>(res, decoder, expectCode);
  }

  Future<T> post<T>(
      String path, {
        String? token,
        dynamic body,
        JsonDecoder<T>? decoder,
        int expectCode = 200,
      }) async {
    final headersMap = _headers(token);
    print('📡 [HTTP] POST $baseUrl$path');
    print('📋 headers: $headersMap');
    final res = await _http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
    print('📌 [HTTP] Response ${res.statusCode}: $body');
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
    final body = utf8.decode(res.bodyBytes);

    if (res.statusCode != expectCode) {
      String errorMessage;
      try {
        final jsonBody = jsonDecode(body);
        if (jsonBody is Map) {
          errorMessage = (jsonBody['message'] ?? jsonBody['error'])?.toString()
              ?? 'Ошибка ${res.statusCode}';
        } else {
          errorMessage = 'Ошибка ${res.statusCode}';
        }
      } catch (_) {
        errorMessage = 'Ошибка ${res.statusCode}: $body';
      }
      throw Exception(errorMessage);
    }
    if (decoder == null) {
      return null as T;
    }
    final json = jsonDecode(body);
    return decoder(json);
  }

  Future<T> delete<T>(
      String path, {
        String? token,
        JsonDecoder<T>? decoder,
        int expectCode = 200,
      }) async {
    final res = await _http.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
    );
    return _process<T>(res, decoder, expectCode);
  }

  Future<T> patch<T>(
      String path, {
        String? token,
        dynamic body,
        JsonDecoder<T>? decoder,
        int expectCode = 200,
      }) async {
    final res = await _http.patch(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
    return _process(res, decoder, expectCode);
  }

}
