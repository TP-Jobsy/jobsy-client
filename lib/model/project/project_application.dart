import 'package:jobsy/enum/project-application-status.dart';
import 'package:jobsy/enum/application-type.dart';

import '../profile/free/freelancer_profile_dto.dart';

class ProjectApplication {
  final int id;
  final int projectId;
  final int freelancerId;
  final ApplicationType applicationType;
  final ProjectApplicationStatus status;
  final DateTime createdAt;
  final FreelancerProfile freelancer;

  ProjectApplication({
    required this.id,
    required this.projectId,
    required this.freelancerId,
    required this.applicationType,
    required this.status,
    required this.createdAt,
    required this.freelancer,
  });

  factory ProjectApplication.fromJson(Map<String, dynamic> json) {
    final applicationTypeStr = json['applicationType'] as String? ?? '';
    final statusStr = json['status'] as String? ?? '';
    final createdAtRaw = json['createdAt'] as String? ?? '';

    return ProjectApplication(
      id: json['id'] as int,
      projectId: json['projectId'] as int,
      freelancerId: json['freelancerId'] as int,
      applicationType: ApplicationType.values.firstWhere(
        (e) => e.name == applicationTypeStr,
      ),
      status: ProjectApplicationStatus.values.firstWhere(
        (e) => e.name == statusStr,
      ),
      createdAt: DateTime.tryParse(createdAtRaw) ?? DateTime.now(),
      freelancer: FreelancerProfile.fromJson(
        (json['freelancer'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'freelancerId': freelancerId,
    'applicationType': applicationType.name,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'freelancer': freelancer.toJson(),
  };
}
