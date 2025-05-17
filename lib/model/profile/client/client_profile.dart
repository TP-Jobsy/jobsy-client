import 'package:jobsy/model/user.dart';
import 'client_profile_basic_dto.dart';
import 'client_profile_contact_dto.dart';
import 'client_profile_field_dto.dart';

class ClientProfile {
  final int id;
  final ClientProfileBasic basic;
  final ClientProfileContact contact;
  final ClientProfileField field;
  final UserDto user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatarUrl;

  ClientProfile({
    required this.id,
    required this.basic,
    required this.contact,
    required this.field,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    this.avatarUrl,
  });

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>? ?? {};
    final userDto = UserDto.fromJson(userMap);
    final basicRaw = Map<String, dynamic>.from(
      json['basic'] as Map<String, dynamic>? ?? {},
    );
    basicRaw['dateBirth'] = userDto.dateBirth;
    final basicDto = ClientProfileBasic.fromJson(basicRaw);
    return ClientProfile(
      id: json['id'] as int,
      basic: basicDto,
      contact: ClientProfileContact.fromJson(
        json['contact'] as Map<String, dynamic>? ?? {},
      ),
      field: ClientProfileField.fromJson(
        json['field'] as Map<String, dynamic>? ?? {},
      ),
      user: userDto,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'basic': basic.toJson(),
    'contact': contact.toJson(),
    'field': field.toJson(),
    'user': user.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'avatarUrl': avatarUrl,
  };
}