import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../util/routes.dart';

class AvatarService {
  final String _baseUrl;
  final http.Client _http;

  AvatarService({String? baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl ?? Routes.apiBase,
        _http = httpClient ?? http.Client();

  Future<String> uploadClientAvatar({
    required String token,
    required File file,
  }) async {
    final uri = Uri.parse('$_baseUrl/profile/client/avatar');
    return _upload(token: token, file: file, uri: uri);
  }

  Future<String> uploadFreelancerAvatar({
    required String token,
    required File file,
  }) async {
    final uri = Uri.parse('$_baseUrl/profile/freelancer/avatar');
    return _upload(token: token, file: file, uri: uri);
  }

  Future<String> _upload({
    required String token,
    required File file,
    required Uri uri,
  }) async {
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception('Неподдерживаемый формат файла');
    }
    final parts = mimeType.split('/'); // ['image','png']
    final filename = p.basename(file.path);

    final req = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
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
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception('Ошибка при загрузке аватара: ${res.body}');
    }
    return res.body;
  }
}