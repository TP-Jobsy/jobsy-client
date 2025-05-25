class TokenRefreshResponse {
  final String accessToken;
  final String refreshToken;
  final DateTime refreshTokenExpiry;

  TokenRefreshResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.refreshTokenExpiry,
  });

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return TokenRefreshResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiry: DateTime.parse(json['refreshTokenExpiry'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'refreshTokenExpiry': refreshTokenExpiry.toUtc().toIso8601String(),
    };
  }
}