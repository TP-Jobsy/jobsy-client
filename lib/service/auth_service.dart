import '../model/auth_request.dart';
import '../model/auth_response.dart';
import '../model/category.dart';
import '../model/default_response.dart';
import '../model/registration_response.dart';
import '../model/specialization.dart';
import '../model/skill.dart';
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

  Future<List<CategoryDto>> fetchCategories(String token) =>
      _api.get<List<CategoryDto>>(
        '/categories',
        token: token,
        decoder: (j) => (j as List).map((e) => CategoryDto.fromJson(e)).toList(),
      );

  Future<List<SpecializationDto>> fetchSpecializations(int id, String token) =>
      _api.get<List<SpecializationDto>>(
        '/categories/$id/specializations',
        token: token,
        decoder: (j) => (j as List).map((e) => SpecializationDto.fromJson(e)).toList(),
      );

  Future<List<SkillDto>> autocompleteSkills(String q, String token) =>
      _api.get<List<SkillDto>>(
        '/skills/autocomplete?query=$q',
        token: token,
        decoder: (j) => (j as List).map((e) => SkillDto.fromJson(e)).toList(),
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
