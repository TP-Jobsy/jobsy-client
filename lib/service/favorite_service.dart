import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/routes.dart';
import '../model/project/project.dart';

class FavoriteService {
  final http.Client _http;
  final String baseUrl;

  FavoriteService({http.Client? http, this.baseUrl = Routes.apiBase})
      : _http = http ?? http.Client();

  Future<List<Project>> fetchFavoriteProjects(String token) async {
    final res = await _http.get(
      Uri.parse('$baseUrl/favorites/projects'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to load favorites');
    }
    final List js = jsonDecode(res.body);
    return js.map((e) => Project.fromJson(e)).toList();
  }

  Future<void> addFavoriteProject(int projectId, String token) async {
    final res = await _http.post(
      Uri.parse('$baseUrl/favorites/projects/$projectId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to add favorite');
    }
  }

  Future<void> removeFavoriteProject(int projectId, String token) async {
    final res = await _http.delete(
      Uri.parse('$baseUrl/favorites/projects/$projectId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 204) {
      throw Exception('Failed to remove favorite');
    }
  }
}