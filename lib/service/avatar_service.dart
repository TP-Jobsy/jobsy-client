import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import '../util/routes.dart';

typedef TokenGetter    = Future<String?> Function();
typedef TokenRefresher = Future<void> Function();

class AvatarService {
  final String _baseUrl;
  final http.Client _http;
  final TokenGetter _getToken;
  final TokenRefresher _refreshToken;

  AvatarService({
    String? baseUrl,
    http.Client? httpClient,
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
  })  : _baseUrl       = baseUrl ?? Routes.apiBase,
        _http          = httpClient ?? http.Client(),
        _getToken      = getToken,
        _refreshToken  = refreshToken;

  Future<String> uploadClientAvatar({ required File file }) =>
      _upload(path: '/profile/client/avatar', file: file);

  Future<String> uploadFreelancerAvatar({ required File file }) =>
      _upload(path: '/profile/freelancer/avatar', file: file);

  Future<String> _upload({
    required String path,
    required File file,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception('Неподдерживаемый формат файла');
    }
    final parts   = mimeType.split('/');
    final filename= p.basename(file.path);

    Future<http.Response> send(String? token) async {
      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = token != null ? 'Bearer $token' : ''
        ..files.add(
          http.MultipartFile(
            'file',
            file.openRead(),
            await file.length(),
            filename: filename,
            contentType: MediaType(parts[0], parts[1]),
          ),
        );
      final streamed = await req.send();
      return http.Response.fromStream(streamed);
    }

    String? token = await _getToken();
    http.Response res = await send(token);

    if (res.statusCode == 401) {
      await _refreshToken();
      token = await _getToken();
      res   = await send(token);
    }

    if (res.statusCode != 200) {
      throw Exception('Ошибка при загрузке аватара: ${res.statusCode} ${res.body}');
    }

    return res.body;
  }
}