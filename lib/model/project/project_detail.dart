import 'dart:convert';
import 'package:jobsy/model/project/project.dart';
import 'package:jobsy/model/project/project_application.dart';

class ProjectDetail {
  final Project project;
  final List<ProjectApplication> responses;
  final List<ProjectApplication> invitations;

  ProjectDetail({
    required this.project,
    required this.responses,
    required this.invitations,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    return ProjectDetail(
      project: Project.fromJson(json['project'] as Map<String, dynamic>),
      responses: (json['responses'] as List<dynamic>?)
          ?.map((e) =>
          ProjectApplication.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      invitations: (json['invitations'] as List<dynamic>?)
          ?.map((e) =>
          ProjectApplication.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  static ProjectDetail fromJsonString(String jsonString) =>
      ProjectDetail.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
    'project': project.toJson(),
    'responses': responses.map((r) => r.toJson()).toList(),
    'invitations': invitations.map((i) => i.toJson()).toList(),
  };
}