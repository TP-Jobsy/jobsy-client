class RegistrationResponse {
  final int userId;
  final String message;

  RegistrationResponse({required this.userId, required this.message});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      userId: (json['userId'] as num).toInt(),
      message: json['message'] as String,
    );
  }
}