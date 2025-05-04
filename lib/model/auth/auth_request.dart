class AuthRequest {
  final String email;
  final String password;

  AuthRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}
