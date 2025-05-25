import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../enum/project-application-status.dart';
import '../model/project/project_application.dart';

class InvitationService {
  final ApiClient _api;

  InvitationService({
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

  Future<ProjectApplication> inviteFreelancer({
    required int projectId,
    required int freelancerId,
  }) {
    final path = '/projects/$projectId/invitations?freelancerId=$freelancerId';
    return _api.post<ProjectApplication>(
      path,
      expectCode: 201,
      decoder:
          (json) => ProjectApplication.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ProjectApplication> handleInvitationStatus({
    required int projectId,
    required int applicationId,
    required ProjectApplicationStatus status,
  }) {
    final path =
        '/projects/$projectId/invitations/$applicationId/status?status=${status.name}';
    return _api.patch<ProjectApplication>(
      path,
      decoder:
          (json) => ProjectApplication.fromJson(json as Map<String, dynamic>),
    );
  }
}
