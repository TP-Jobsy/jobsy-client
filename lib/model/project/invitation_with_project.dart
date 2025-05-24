import 'package:jobsy/model/project/project.dart';

class InvitationWithProject {
  final int applicationId;
  final Project project;
  final bool isProcessed;

  InvitationWithProject({
    required this.applicationId,
    required this.project,
    required this.isProcessed,
  });
}