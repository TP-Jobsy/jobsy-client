class UserDto {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  UserDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      firstName: json['name'],
      lastName: json['surname'],
      email: json['email'],
    );
  }
}
