import '../model/auth/auth_request.dart';
import '../model/auth/auth_response.dart';
import '../model/category/category.dart';
import '../model/auth/registration_response.dart';
import '../model/specialization/specialization.dart';
import '../model/skill/skill.dart';
import 'api_client.dart';

class ApiService {
  static const _base = 'https://jobsyapp.ru/api';
  final ApiClient _api = ApiClient(baseUrl: _base);

  Future<AuthResponse> login(AuthRequest req) =>
      _api.post<AuthResponse>(
        '/auth/login',
        body: req.toJson(),
        decoder: (j) => AuthResponse.fromJson(j),
      );

  Future<RegistrationResponse> register(Map<String, dynamic> data) {
    return _api.post<RegistrationResponse>(
      '/auth/register',
      body: data,
      decoder: (json) => RegistrationResponse.fromJson(json as Map<String, dynamic>),
      expectCode: 201,
    );
  }

  Future<void> confirmEmail(
      String email,
      String code, {
        required String action,
      }) =>
      _api.post<void>(
        '/auth/confirm-email',
        body: {
          'email':             email,
          'confirmationCode':  code,
          'action':            action,
        },
      );

  Future<void> resendConfirmation(String email) =>
      _api.post<void>(
        '/auth/resend-confirmation',
        body: {'email': email},
      );

  Future<void> updateUserRole({
    required String userId,
    required String role,
    required String token,
  }) =>
      _api.put<void>(
        '/users/$userId/role',
        token: token,
        body: {'role': role},
      );

  Future<List<Category>> fetchCategories(String token) =>
      _api.get<List<Category>>(
        '/categories',
        token: token,
        decoder: (j) => (j as List).map((e) => Category.fromJson(e)).toList(),
      );

  Future<List<Specialization>> fetchSpecializations(int id, String token) =>
      _api.get<List<Specialization>>(
        '/categories/$id/specializations',
        token: token,
        decoder: (j) => (j as List).map((e) => Specialization.fromJson(e)).toList(),
      );

  Future<List<Skill>> autocompleteSkills(String q, String token) =>
      _api.get<List<Skill>>(
        '/skills/autocomplete?query=$q',
        token: token,
        decoder: (j) => (j as List).map((e) => Skill.fromJson(e)).toList(),
      );

  Future<void> createProject(Map<String, dynamic> dto, String token) =>
      _api.post<void>(
        '/projects',
        token: token,
        body: dto,
        expectCode: 201,
      );

  Future<void> requestPasswordReset(String email) {
    return _api.post<void>(
      '/auth/password-reset/request',
      body: {'email': email},
    );
  }

  Future<void> confirmPasswordReset(
      String email,
      String resetCode,
      String newPassword,
      ) {
    return _api.post<void>(
      '/auth/password-reset/confirm',
      body: {
        'email': email,
        'resetCode': resetCode,
        'newPassword': newPassword,
      },
    );
  }
}
