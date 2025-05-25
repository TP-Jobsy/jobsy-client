import '../model/profile/free/freelancer_profile_dto.dart';
import '../util/routes.dart';
import 'api_client.dart';

class FreelancerService {
  final ApiClient _api;

  FreelancerService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    ApiClient? client,
  }) : _api =
           client ??
           ApiClient(
             baseUrl: Routes.apiBase,
             getToken: getToken,
             refreshToken: refreshToken,
           );

  Future<List<FreelancerProfile>> fetchAllFreelancers() async {
    return _api.get<List<FreelancerProfile>>(
      '/freelancers',
      decoder:
          (json) =>
              (json as List)
                  .map(
                    (e) =>
                        FreelancerProfile.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
      expectCode: 200,
    );
  }

  Future<FreelancerProfile> fetchFreelancerById(int id) async {
    return _api.get<FreelancerProfile>(
      '/freelancers/$id',
      decoder:
          (json) => FreelancerProfile.fromJson(json as Map<String, dynamic>),
      expectCode: 200,
    );
  }
}
