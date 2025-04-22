import 'i_api_service.dart';
import '../model/auth_request.dart';
import '../model/auth_response.dart';
import '../model/user_dto.dart';

class MockApiService implements IApiService {
  @override
  Future<AuthResponse> login(AuthRequest request) async {
    await Future.delayed(Duration(seconds: 1));
    return AuthResponse(
      token: 'mock_token',
      user: UserDto(
        id: '1',
        email: request.email,
        firstName: 'Mock',
        lastName: 'User',
        role: 'CLIENT',
        phone: '+1234567890',
        dateBirth: '11.01.2004',
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    await Future.delayed(Duration(seconds: 1));
    return {'message': 'Мок-регистрация успешна', 'success': true};
  }

  @override
  Future<void> confirmEmail(String email, String code) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (code != '1234') throw Exception('Неверный код');
  }

  @override
  Future<void> updateUserRole({
    required String userId,
    required String role,
    required String token,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
  }
}
