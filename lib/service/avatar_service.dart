import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jobsy/util/routes.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception('Неподдерживаемый формат файла');
    }
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception('Ошибка при загрузке аватара клиента: ${res.body}');
    }
    return res.body;
  }

  Future<String> uploadFreelancerAvatar({
    required String token,
    required File file,
  }) async {
    final uri = Uri.parse('$_baseUrl/profile/freelancer/avatar');
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception('Неподдерживаемый формат файла');
    }
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception('Ошибка при загрузке аватара фрилансера: ${res.body}');
    }
    return res.body;
  }
}