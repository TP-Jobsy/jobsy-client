import '../model/auth_request.dart';
import '../model/auth_response.dart';

abstract class IApiService {
  Future<AuthResponse> login(AuthRequest request);
  Future<Map<String, dynamic>> register(Map<String, dynamic> data);
  Future<void> confirmEmail(String email, String code);
  Future<void> updateUserRole({required String userId, required String role, required String token});
}
