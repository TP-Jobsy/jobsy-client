import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';

import '../model/profile/free/freelancer_list_item.dart';
import '../model/project/project_list_item.dart';
import '../model/project/page_response.dart';

class SearchService {
  final ApiClient _api;

  SearchService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<PageResponse<FreelancerListItem>> searchFreelancers({
    required String token,
    List<int>? skillIds,
    String? term,
    int page = 0,
    int size = 20,
  }) {
    final qs = <String, dynamic>{
      'page': page,
      'size': size,
      if (term != null && term.isNotEmpty) 'term': term,
      if (skillIds != null && skillIds.isNotEmpty) 'skills': skillIds,
    };
    return _api.get<PageResponse<FreelancerListItem>>(
      '/client/search/freelancers',
      token: token,
      queryParameters: qs,
      decoder: (json) => PageResponse.fromJson(
        json as Map<String, dynamic>,
            (item) => FreelancerListItem.fromJson(item),
      ),
    );
  }

  Future<PageResponse<ProjectListItem>> searchProjects({
    required String token,
    List<int>? skillIds,
    String? term,
    int page = 0,
    int size = 20,
  }) {
    final qs = <String, dynamic>{
      'page': page,
      'size': size,
      if (term != null && term.isNotEmpty) 'term': term,
      if (skillIds != null && skillIds.isNotEmpty) 'skills': skillIds,
    };
    return _api.get<PageResponse<ProjectListItem>>(
      '/freelancer/search/projects',
      token: token,
      queryParameters: qs,
      decoder: (json) => PageResponse.fromJson(
        json as Map<String, dynamic>,
            (item) => ProjectListItem.fromJson(item),
      ),
    );
  }
}