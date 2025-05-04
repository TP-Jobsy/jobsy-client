import 'dart:convert';

class ProjectApplication {
  final int id;
  final int freelancerId;
  final String freelancerName;
  final String status;

  ProjectApplication({
    required this.id,
    required this.freelancerId,
    required this.freelancerName,
    required this.status,
  });

  factory ProjectApplication.fromJson(Map<String, dynamic> json) {
    return ProjectApplication(
      id: json['id'] as int,
      freelancerId: json['freelancerId'] as int,
      freelancerName: json['freelancerName'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  static ProjectApplication fromJsonString(String jsonString) =>
      ProjectApplication.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
    'id': id,
    'freelancerId': freelancerId,
    'freelancerName': freelancerName,
    'status': status,
  };
}