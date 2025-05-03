import 'dart:convert';
import 'package:jobsy/model/client_profile.dart';
import 'package:jobsy/model/client_profile_basic_dto.dart';
import 'package:jobsy/model/client_profile_contact_dto.dart';
import 'package:jobsy/model/client_profile_field_dto.dart';
import 'package:jobsy/service/api_client.dart';

import '../model/freelancer_profile_about_dto.dart';
import '../model/freelancer_profile_basic_dto.dart' show FreelancerProfileBasicDto;
import '../model/freelancer_profile_contact_dto.dart';
import '../model/freelancer_profile_dto.dart';

class ProfileService {
  static const _base = 'https://jobsyapp.ru/api';
  final ApiClient _api = ApiClient(baseUrl: _base);

  Future<ClientProfileDto> fetchClientProfile(String token) async {
    return _api.get<ClientProfileDto>(
      '/profile/client',
      token: token,
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<ClientProfileDto> updateClientBasic(
      String token, ClientProfileBasicDto dto) async {
    return _api.put<ClientProfileDto>(
      '/profile/client/basic',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<ClientProfileDto> updateClientContact(
      String token, ClientProfileContactDto dto) async {
    return _api.put<ClientProfileDto>(
      '/profile/client/contact',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<ClientProfileDto> updateClientField(
      String token, ClientProfileFieldDto dto) async {
    return _api.put<ClientProfileDto>(
      '/profile/client/field',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfileDto.fromJson(json),
    );
  }

  Future<void> deleteClientAccount(String token) async {
    await _api.delete(
      '/profile/client',
      token: token,
      expectCode: 200,
    );
  }

  Future<FreelancerProfileDto> fetchFreelancerProfile(String token) async {
    return _api.get<FreelancerProfileDto>(
      '/profile/freelancer',
      token: token,
      decoder: (json) => FreelancerProfileDto.fromJson(json),
    );
  }

  Future<FreelancerProfileDto> updateFreelancerBasic(
      String token, FreelancerProfileBasicDto dto) async {
    return _api.put<FreelancerProfileDto>(
      '/profile/freelancer/basic',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerProfileDto.fromJson(json),
    );
  }

  Future<FreelancerProfileDto> updateFreelancerContact(
      String token, FreelancerProfileContactDto dto) async {
    return _api.put<FreelancerProfileDto>(
      '/profile/freelancer/contact',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerProfileDto.fromJson(json),
    );
  }

  Future<FreelancerProfileDto> updateFreelancerAbout(
      String token, FreelancerProfileAboutDto dto) async {
    return _api.put<FreelancerProfileDto>(
      '/profile/freelancer/about',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerProfileDto.fromJson(json),
    );
  }

  Future<void> deleteFreelancerAccount(String token) async {
    await _api.delete(
      '/profile/freelancer',
      token: token,
      expectCode: 200,
    );
  }

  Future<FreelancerProfileDto> fetchFreelancerById(
      String token, int id) async {
    return _api.get<FreelancerProfileDto>(
      '/profile/freelancer/$id',
      token: token,
      decoder: (json) => FreelancerProfileDto.fromJson(json),
    );
  }

}