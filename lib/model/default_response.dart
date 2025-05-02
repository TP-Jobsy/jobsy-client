class DefaultResponse {
  final String message;

  DefaultResponse({required this.message});

  factory DefaultResponse.fromJson(Map<String, dynamic> json) =>
      DefaultResponse(message: json['message'] as String);
}