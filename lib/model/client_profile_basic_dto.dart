import 'dart:convert';

import 'public_user_dto.dart';

class ClientProfileBasicDto extends PublicUserDto {
  final String? companyName;
  final String? position;
  final String? country;
  final String? city;

  ClientProfileBasicDto({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String dateBirth,
    this.companyName,
    this.position,
    this.country,
    this.city,
  }) : super(
    firstName : firstName,
    lastName  : lastName,
    email     : email,
    phone     : phone,
    dateBirth : dateBirth,
  );

  factory ClientProfileBasicDto.fromJson(Map<String, dynamic> json) {
    return ClientProfileBasicDto(
      firstName   : json['firstName']   as String,
      lastName    : json['lastName']    as String,
      email       : json['email']       as String,
      phone       : json['phone']       as String,
      dateBirth   : json['dateBirth']   as String,
      companyName : json['companyName'] as String?,
      position    : json['position']    as String?,
      country     : json['country']     as String?,
      city        : json['city']        as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();

    if (companyName != null && companyName!.isNotEmpty) {
      map['companyName'] = companyName;
    }
    if (position != null && position!.isNotEmpty) {
      map['position'] = position;
    }
    if (country != null && country!.isNotEmpty) {
      map['country'] = country;
    }
    if (city != null && city!.isNotEmpty) {
      map['city'] = city;
    }
    return map;
  }
}