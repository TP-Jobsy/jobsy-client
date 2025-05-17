import '../user.dart';

class AuthResponse {
  final String token;
  final UserDto user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userJson = (json['user'] as Map<String, dynamic>?) ?? {};
    return AuthResponse(
      token: json['token'],
      user: UserDto(
        id: userJson['id'].toString(),
        email: userJson['email'] ?? '',
        firstName: userJson['firstName'] ?? '',
        lastName: userJson['lastName'] ?? '',
        role: userJson['role'] ?? '',
        phone: userJson['phone'] ?? '',
        dateBirth: userJson['dateBirth'] ?? '',
      ),
    );
  }
}
