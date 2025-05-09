import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';

import '../model/profile/free/freelancer_profile_dto.dart';

class FreelancerService {
  final ApiClient _api;
  FreelancerService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<List<FreelancerProfile>> fetchAllFreelancers(String token) async {
    return _api.get<List<FreelancerProfile>>(
      '/freelancers',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => FreelancerProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      expectCode: 200,
    );
  }

  Future<FreelancerProfile> fetchFreelancerById(int id, String token) async {
    return _api.get<FreelancerProfile>(
      '/freelancers/$id',
      token: token,
      decoder: (json) =>
          FreelancerProfile.fromJson(json as Map<String, dynamic>),
      expectCode: 200,
    );
  }
}