class TokenRefreshRequest {
  final String refreshToken;

  TokenRefreshRequest({required this.refreshToken});

  factory TokenRefreshRequest.fromJson(Map<String, dynamic> json) {
    return TokenRefreshRequest(
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}