class UserDto {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String phone;
  final String dateBirth;

  UserDto({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phone,
    required this.dateBirth,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'].toString(),
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      phone: json['phone'],
      dateBirth: json['dateBirth'],
    );
  }
}

  extension UserDtoSerialization on UserDto {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'phone': phone,
      'dateBirth': dateBirth,
    };
  }
}

