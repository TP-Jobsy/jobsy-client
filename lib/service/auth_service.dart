import '../model/auth/auth_request.dart';
import '../model/auth/auth_response.dart';
import '../model/auth/token_refresh_request.dart';
import '../model/auth/token_refresh_response.dart';
import '../model/auth/registration_response.dart';
import '../model/category/category.dart';
import '../model/specialization/specialization.dart';
import '../model/skill/skill.dart';
import '../util/routes.dart';
import 'api_client.dart';

class AccountDisabledException implements Exception {
  final String message;

  AccountDisabledException([this.message = 'Учётная запись заблокирована']);

  @override
  String toString() => message;
}

class BadCredentialsException implements Exception {
  final String message;

  BadCredentialsException([this.message = 'Неверные учётные данные']);

  @override
  String toString() => message;
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException([this.message = 'Пользователь не найден']);

  @override
  String toString() => message;
}

class SessionExpiredException implements Exception {
  final String message;

  SessionExpiredException([
    this.message = 'Сессия истекла, пожалуйста, войдите снова',
  ]);

  @override
  String toString() => message;
}

class AuthService {
  final ApiClient _api;

  AuthService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
  }) : _api = ApiClient(
         baseUrl: Routes.apiBase,
         getToken: getToken,
         refreshToken: refreshToken,
       );

  Future<AuthResponse> login(AuthRequest req) async {
    try {
      return await _api.post<AuthResponse>(
        '/auth/login',
        body: req.toJson(),
        decoder: (j) => AuthResponse.fromJson(j as Map<String, dynamic>),
      );
    } on Exception catch (e) {
      var raw = e.toString();
      var msg =
          raw.startsWith('Exception:')
              ? raw.substring('Exception:'.length).trim()
              : raw;
      var lower = msg.toLowerCase();

      if (lower.contains('заблокир')) {
        throw AccountDisabledException(msg);
      }
      if (lower.contains('неверн')) {
        throw BadCredentialsException(msg);
      }
      if (lower.contains('не найден')) {
        throw UserNotFoundException(msg);
      }
      throw Exception(msg);
    }
  }

  Future<RegistrationResponse> register(Map<String, dynamic> data) =>
      _api.post<RegistrationResponse>(
        '/auth/register',
        body: data,
        decoder:
            (j) => RegistrationResponse.fromJson(j as Map<String, dynamic>),
        expectCode: 201,
      );

  Future<TokenRefreshResponse> refresh(TokenRefreshRequest req) =>
      _api.post<TokenRefreshResponse>(
        '/auth/refresh',
        body: req.toJson(),
        decoder:
            (j) => TokenRefreshResponse.fromJson(j as Map<String, dynamic>),
      );

  Future<void> confirmEmail(
    String email,
    String code, {
    required String action,
  }) => _api.post<void>(
    '/auth/confirm-email',
    body: {'email': email, 'confirmationCode': code, 'action': action},
    expectCode: 200,
  );

  Future<void> resendConfirmation(String email) =>
      _api.post<void>('/auth/resend-confirmation', body: {'email': email});

  Future<void> updateUserRole({required String userId, required String role}) =>
      _api.put<void>('/users/$userId/role', body: {'role': role});

  Future<List<Category>> fetchCategories() => _api.get<List<Category>>(
    '/categories',
    decoder: (j) => (j as List).map((e) => Category.fromJson(e)).toList(),
  );

  Future<List<Specialization>> fetchSpecializations(int id) =>
      _api.get<List<Specialization>>(
        '/categories/$id/specializations',
        decoder:
            (j) => (j as List).map((e) => Specialization.fromJson(e)).toList(),
      );

  Future<List<Skill>> autocompleteSkills(String q) => _api.get<List<Skill>>(
    '/skills/autocomplete',
    queryParameters: {'query': q},
    decoder: (j) => (j as List).map((e) => Skill.fromJson(e)).toList(),
  );

  Future<void> createProject(Map<String, dynamic> dto) =>
      _api.post<void>('/projects', body: dto, expectCode: 201);

  Future<void> requestPasswordReset(String email) =>
      _api.post<void>('/auth/password-reset/request', body: {'email': email});

  Future<void> confirmPasswordReset(
    String email,
    String resetCode,
    String newPassword,
  ) => _api.post<void>(
    '/auth/password-reset/confirm',
    body: {'email': email, 'resetCode': resetCode, 'newPassword': newPassword},
  );
}
