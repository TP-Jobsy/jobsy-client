import 'user.dart';

class AuthResponse {
  final String token;
  final UserDto user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      user: UserDto.fromJson(json['user']),
    );
  }
}
