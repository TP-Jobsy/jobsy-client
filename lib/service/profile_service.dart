import 'dart:convert';
import 'package:jobsy/model/client_profile.dart';
import 'package:jobsy/model/client_profile_basic_dto.dart';
import 'package:jobsy/model/client_profile_contact_dto.dart';
import 'package:jobsy/model/client_profile_field_dto.dart';
import 'package:jobsy/service/api_client.dart';

class ProfileService {
  static const _base = 'https://jobsyapp.ru/api';
  final ApiClient _api = ApiClient(baseUrl: _base);

  Future<ClientProfileDto> fetchProfile(String token) async {
    return _api.get<ClientProfileDto>(
      '/profile/client',
      token: token,
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<ClientProfileDto> updateBasic(
      String token, ClientProfileBasicDto dto) async {
    return _api.put<ClientProfileDto>(
      '/profile/client/basic',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<ClientProfileDto> updateContact(
      String token, ClientProfileContactDto dto) async {
    return _api.put<ClientProfileDto>(
      '/profile/client/contact',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<ClientProfileDto> updateField(
      String token, ClientProfileFieldDto dto) async {
    return _api.put<ClientProfileDto>(
      '/profile/client/field',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<void> deleteAccount(String token) async {
    await _api.delete(
      '/profile/client',
      token: token,
      expectCode: 200,
    );
  }

}