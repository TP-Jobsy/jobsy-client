import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../enum/project-application-status.dart';
import '../model/project/project_application.dart';

class FreelancerResponseService {
  final ApiClient _api;

  FreelancerResponseService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<ProjectApplication> respond({
    required String token,
    required int projectId,
    required int freelancerId,
  }) {
    final path = '/projects/$projectId/responses?freelancerId=$freelancerId';
    return _api.post<ProjectApplication>(
      path,
      token: token,
      expectCode: 201,
      decoder: (json) =>
          ProjectApplication.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ProjectApplication> handleResponseStatus({
    required String token,
    required int projectId,
    required int applicationId,
    required ProjectApplicationStatus status,
  }) {
    final path =
        '/projects/$projectId/responses/$applicationId/status?status=${status.name}';
    return _api.patch<ProjectApplication>(
      path,
      token: token,
      decoder: (json) =>
          ProjectApplication.fromJson(json as Map<String, dynamic>),
    );
  }
}