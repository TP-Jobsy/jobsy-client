import '../user.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final DateTime refreshTokenExpiry;
  final UserDto user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.refreshTokenExpiry,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiry: DateTime.parse(json['refreshTokenExpiry'] as String),
      user: UserDto.fromJson(json['user'] as Map<String,dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'refreshTokenExpiry': refreshTokenExpiry.toUtc().toIso8601String(),
    'user': user.toJson(),
  };
}
