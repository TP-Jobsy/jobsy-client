import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';

import '../enum/project-application-status.dart';
import '../model/project/project_application.dart';

class FreelancerResponseService {
  final ApiClient _api;

  FreelancerResponseService({
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

  Future<void> respond({required int projectId, required int freelancerId}) {
    final path = '/projects/$projectId/responses?freelancerId=$freelancerId';
    return _api.post<void>(path, expectCode: 201);
  }

  Future<ProjectApplication> handleResponseStatus({
    required int projectId,
    required int applicationId,
    required ProjectApplicationStatus status,
  }) {
    final path =
        '/projects/$projectId/responses/$applicationId/status?status=${status.name}';
    return _api.patch<ProjectApplication>(
      path,
      decoder:
          (json) => ProjectApplication.fromJson(json as Map<String, dynamic>),
    );
  }
}
