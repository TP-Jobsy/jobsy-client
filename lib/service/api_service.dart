import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/auth_request.dart';
import '../model/auth_response.dart';
import 'i_api_service.dart';

class ApiService implements IApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  @override
  Future<AuthResponse> login(AuthRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка входа: ${response.body}');
    }
  }
  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    print('Отправляем: ${jsonEncode(data)}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      final errorBody = utf8.decode(response.bodyBytes);
      throw Exception('Ошибка регистрации: $errorBody');
    }
  }
  @override
  Future<void> updateUserRole({
    required String userId,
    required String role,
    required String token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/role'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'role': role}),
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка при обновлении роли: ${response.body}');
    }
  }
  @override
  Future<void> confirmEmail(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/confirm-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'confirmationCode': code,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(utf8.decode(response.bodyBytes));
    }
  }

}
