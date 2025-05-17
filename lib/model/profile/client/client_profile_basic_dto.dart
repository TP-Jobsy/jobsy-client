import '../../public_user_dto.dart';

class ClientProfileBasic extends PublicUser {
  final String? companyName;
  final String? position;
  final String? country;
  final String? city;

  ClientProfileBasic({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.dateBirth,
    this.companyName,
    this.position,
    this.country,
    this.city,
  });

  factory ClientProfileBasic.fromJson(Map<String, dynamic> json) {
    return ClientProfileBasic(
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