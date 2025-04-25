import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/category_dto.dart';
import '../model/specialization_dto.dart';

class ProjectService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<void> createProject(Map<String, dynamic> projectData, String token) async {
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
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CategoryDto.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки категорий');
    }
  }

  static Future<List<SpecializationDto>> fetchSpecializations(int categoryId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories/$categoryId/specializations'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SpecializationDto.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки специализаций');
    }
  }
}
