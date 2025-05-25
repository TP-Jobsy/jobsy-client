import '../model/profile/free/freelancer_list_item.dart';
import '../model/project/project_list_item.dart';
import '../model/project/page_response.dart';
import '../enum/project-application-status.dart';
import '../util/routes.dart';
import 'api_client.dart';

class SearchService {
  final ApiClient _api;

  SearchService({
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

  Future<PageResponse<FreelancerListItem>> searchFreelancers({
    List<int>? skillIds,
    String? term,
    int page = 0,
    int size = 20,
  }) {
    final qs = <String, dynamic>{
      'page': page,
      'size': size,
      if (term?.isNotEmpty ?? false) 'term': term,
      if (skillIds?.isNotEmpty ?? false) 'skills': skillIds,
    };
    return _api.get<PageResponse<FreelancerListItem>>(
      '/client/search/freelancers',
      queryParameters: qs,
      decoder:
          (json) => PageResponse.fromJson(
            json as Map<String, dynamic>,
            (item) => FreelancerListItem.fromJson(item),
          ),
    );
  }

  Future<PageResponse<ProjectListItem>> searchProjects({
    List<int>? skillIds,
    String? term,
    int page = 0,
    int size = 20,
  }) {
    final qs = <String, dynamic>{
      'page': page,
      'size': size,
      if (term?.isNotEmpty ?? false) 'term': term,
      if (skillIds?.isNotEmpty ?? false) 'skills': skillIds,
    };
    return _api.get<PageResponse<ProjectListItem>>(
      '/freelancer/search/projects',
      queryParameters: qs,
      decoder:
          (json) => PageResponse.fromJson(
            json as Map<String, dynamic>,
            (item) => ProjectListItem.fromJson(item),
          ),
    );
  }
}
