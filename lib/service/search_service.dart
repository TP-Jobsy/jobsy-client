import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../model/profile/free/freelancer_profile_dto.dart';
import '../model/project/project.dart';

class SearchService {
  final ApiClient _api;

  SearchService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<List<FreelancerProfile>> searchFreelancers({
    required String token,
    List<int>? skillIds,
    String? term,
  }) {
    final qs = <String>[];
    if (skillIds != null && skillIds.isNotEmpty) {
      qs.addAll(skillIds.map((id) => 'skills=$id'));
    }
    if (term != null && term.isNotEmpty) {
      qs.add('term=${Uri.encodeQueryComponent(term)}');
    }
    final path = '/client/search/freelancers${qs.isNotEmpty ? '?${qs.join('&')}' : ''}';

    return _api.get<List<FreelancerProfile>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) =>
          FreelancerProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<List<Project>> searchProjects({
    required String token,
    List<int>? skillIds,
    String? term,
  }) {
    final qs = <String>[];
    if (skillIds != null && skillIds.isNotEmpty) {
      qs.addAll(skillIds.map((id) => 'skills=$id'));
    }
    if (term != null && term.isNotEmpty) {
      qs.add('term=${Uri.encodeQueryComponent(term)}');
    }
    final path =
        '/freelancer/search/projects${qs.isNotEmpty ? '?${qs.join('&')}' : ''}';

    return _api.get<List<Project>>(
      path,
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}