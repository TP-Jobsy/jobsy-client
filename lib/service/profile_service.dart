import 'package:jobsy/model/profile/client/client_profile.dart';
import 'package:jobsy/model/profile/client/client_profile_basic_dto.dart';
import 'package:jobsy/model/profile/client/client_profile_field_dto.dart';
import 'package:jobsy/service/api_client.dart';

import '../model/profile/client/client_profile_contact_dto.dart';
import '../model/profile/free/freelancer_profile_about_dto.dart';
import '../model/profile/free/freelancer_profile_basic_dto.dart' show FreelancerProfileBasic;
import '../model/profile/free/freelancer_profile_contact_dto.dart';
import '../model/profile/free/freelancer_profile_dto.dart';
import '../util/routes.dart';

class ProfileService {
  final ApiClient _api;
  ProfileService({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient(baseUrl: Routes.apiBase);

  Future<ClientProfile> fetchClientProfile(String token) async {
    return _api.get<ClientProfile>(
      '/profile/client',
      token: token,
      decoder: (json) => ClientProfile.fromJson(json),
    );
  }

  Future<ClientProfile> updateClientBasic(
      String token, ClientProfileBasic dto) async {
    return _api.put<ClientProfile>(
      '/profile/client/basic',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfile.fromJson(json),
    );
  }

  Future<ClientProfile> updateClientContact(
      String token, ClientProfileContact dto) async {
    return _api.put<ClientProfile>(
      '/profile/client/contact',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfile.fromJson(json),
    );
  }

  Future<ClientProfile> updateClientField(
      String token, ClientProfileField dto) async {
    return _api.put<ClientProfile>(
      '/profile/client/field',
      token: token,
      body: dto.toJson(),
      decoder: (json) => ClientProfile.fromJson(json),
    );
  }

  Future<void> deleteClientAccount(String token) async {
    await _api.delete(
      '/profile/client',
      token: token,
      expectCode: 200,
    );
  }

  Future<FreelancerProfile> fetchFreelancerProfile(String token) async {
    return _api.get<FreelancerProfile>(
      '/profile/freelancer',
      token: token,
      decoder: (json) => FreelancerProfile.fromJson(json),
    );
  }

  Future<FreelancerProfile> updateFreelancerBasic(
      String token, FreelancerProfileBasic dto) async {
    return _api.put<FreelancerProfile>(
      '/profile/freelancer/basic',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerProfile.fromJson(json),
    );
  }

  Future<FreelancerProfile> updateFreelancerContact(
      String token, FreelancerProfileContact dto) async {
    return _api.put<FreelancerProfile>(
      '/profile/freelancer/contact',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerProfile.fromJson(json),
    );
  }

  Future<FreelancerProfile> updateFreelancerAbout(
      String token, FreelancerProfileAbout dto) async {
    return _api.put<FreelancerProfile>(
      '/profile/freelancer/about',
      token: token,
      body: dto.toJson(),
      decoder: (json) => FreelancerProfile.fromJson(json),
    );
  }

  Future<void> deleteFreelancerAccount(String token) async {
    await _api.delete(
      '/profile/freelancer',
      token: token,
      expectCode: 200,
    );
  }

  Future<FreelancerProfile> fetchFreelancerById(
      String token, int id) async {
    return _api.get<FreelancerProfile>(
      '/profile/freelancer/$id',
      token: token,
      decoder: (json) => FreelancerProfile.fromJson(json),
    );
  }

  Future<FreelancerProfile> addFreelancerSkill(
      String token, int skillId) =>
      _api.post<FreelancerProfile>(
        '/profile/freelancer/skills/$skillId',
        token: token,
        decoder: (json) => FreelancerProfile.fromJson(json),
        expectCode: 200,
      );

  Future<FreelancerProfile> removeFreelancerSkill(
      String token, int skillId) =>
      _api.delete<FreelancerProfile>(
        '/profile/freelancer/skills/$skillId',
        token: token,
        decoder: (json) => FreelancerProfile.fromJson(json),
        expectCode: 200,
      );

}