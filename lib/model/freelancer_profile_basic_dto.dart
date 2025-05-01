import 'package:jobsy/model/public_user_dto.dart';

class FreelancerProfileBasicDto extends PublicUserDto {
  final String country;
  final String city;

  FreelancerProfileBasicDto({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.dateBirth,
    required this.country,
    required this.city,
  });

  factory FreelancerProfileBasicDto.fromJson(Map<String, dynamic> json) {
    final country = json['country'] as String? ?? '';
    final city = json['city'] as String? ?? '';

    return FreelancerProfileBasicDto(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      dateBirth: json['dateBirth'] as String,
      country: country,
      city: city,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['country'] = country;
    map['city'] = city;
    return map;
  }
}