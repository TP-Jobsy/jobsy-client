import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/category_dto.dart';
import '../model/skill_dto.dart';
import '../model/specialization_dto.dart';

class ProjectService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<void> createProject(
    Map<String, dynamic> projectData,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/projects');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(projectData),
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка создания проекта: ${response.body}');
    }
  }

  static Future<List<CategoryDto>> fetchCategories(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception('Ошибка загрузки категорий: ${res.body}');
    }
    final body = utf8.decode(res.bodyBytes);
    final List data = jsonDecode(body);
    return data.map((j) => CategoryDto.fromJson(j)).toList();
  }

  static Future<List<SpecializationDto>> fetchSpecializations(
    int categoryId,
    String token,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/categories/$categoryId/specializations'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception('Ошибка загрузки специализаций: ${res.body}');
    }
    final body = utf8.decode(res.bodyBytes);
    final List data = jsonDecode(body);
    return data.map((j) => SpecializationDto.fromJson(j)).toList();
  }
  static Future<List<SkillDto>> autocompleteSkills(
    String query,
    String token,
  ) async {
    final uri = Uri.parse('$baseUrl/skills/autocomplete?query=$query');
    final resp = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (resp.statusCode != 200) {
      throw Exception('Ошибка автодополнения: ${resp.body}');
    }
    final List data = jsonDecode(utf8.decode(resp.bodyBytes));
    return data.map((j) => SkillDto.fromJson(j)).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchMyProjects({
    String status = 'OPEN',
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/projects/me?status=$status');
    final res = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode != 200) {
      throw Exception('Ошибка загрузки проектов: ${res.body}');
    }
    final List data = jsonDecode(utf8.decode(res.bodyBytes));
    return data.map<Map<String, dynamic>>((raw) {
      final m = Map<String, dynamic>.from(raw);
      m['category'] = CategoryDto.fromJson(m['category']);
      m['specialization'] = SpecializationDto.fromJson(m['specialization']);
      return m;
    }).toList();
  }
}
