import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../model/profile/client/client_profile.dart';
import '../model/profile/client/client_profile_basic_dto.dart';
import '../model/profile/client/client_profile_contact_dto.dart';
import '../model/profile/client/client_profile_field_dto.dart';
import '../model/profile/free/freelancer_profile_dto.dart';
import '../model/profile/free/freelancer_profile_basic_dto.dart';
import '../model/profile/free/freelancer_profile_contact_dto.dart';
import '../model/profile/free/freelancer_profile_about_dto.dart';

class ProfileService {
  final ApiClient _api;

  ProfileService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    ApiClient? apiClient,
  }) : _api =
           apiClient ??
           ApiClient(
             baseUrl: Routes.apiBase,
             getToken: getToken,
             refreshToken: refreshToken,
           );

  Future<ClientProfile> fetchClientProfile() async {
    return _api.get<ClientProfile>(
      '/profile/client',
      decoder: (json) => ClientProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ClientProfile> updateClientBasic(ClientProfileBasic dto) async {
    return _api.put<ClientProfile>(
      '/profile/client/basic',
      body: dto.toJson(),
      decoder: (json) => ClientProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ClientProfile> updateClientContact(ClientProfileContact dto) async {
    return _api.put<ClientProfile>(
      '/profile/client/contact',
      body: dto.toJson(),
      decoder: (json) => ClientProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ClientProfile> updateClientField(ClientProfileField dto) async {
    return _api.put<ClientProfile>(
      '/profile/client/field',
      body: dto.toJson(),
      decoder: (json) => ClientProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteClientAccount() async {
    await _api.delete<void>('/profile/client', expectCode: 200);
  }

  Future<FreelancerProfile> fetchFreelancerProfile() async {
    return _api.get<FreelancerProfile>(
      '/profile/freelancer',
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<FreelancerProfile> updateFreelancerBasic(
    FreelancerProfileBasic dto,
  ) async {
    return _api.put<FreelancerProfile>(
      '/profile/freelancer/basic',
      body: dto.toJson(),
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<FreelancerProfile> updateFreelancerContact(
    FreelancerProfileContact dto,
  ) async {
    return _api.put<FreelancerProfile>(
      '/profile/freelancer/contact',
      body: dto.toJson(),
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<FreelancerProfile> updateFreelancerAbout(
    FreelancerProfileAbout dto,
  ) async {
    return _api.put<FreelancerProfile>(
      '/profile/freelancer/about',
      body: dto.toJson(),
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteFreelancerAccount() async {
    await _api.delete<void>('/profile/freelancer', expectCode: 200);
  }

  Future<FreelancerProfile> fetchFreelancerById(int id) async {
    return _api.get<FreelancerProfile>(
      '/profile/freelancer/$id',
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<FreelancerProfile> addFreelancerSkill(int skillId) async {
    return _api.post<FreelancerProfile>(
      '/profile/freelancer/skills/$skillId',
      expectCode: 200,
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<FreelancerProfile> removeFreelancerSkill(int skillId) async {
    return _api.delete<FreelancerProfile>(
      '/profile/freelancer/skills/$skillId',
      expectCode: 200,
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
    );
  }
}
