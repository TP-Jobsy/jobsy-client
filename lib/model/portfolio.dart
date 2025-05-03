import 'skill.dart';

class FreelancerPortfolioDto {
  final int id;
  final int freelancerId;
  final String title;
  final String description;
  final String? roleInProject;
  final String projectLink;
  final List<SkillDto> skills;
  final DateTime createdAt;
  final DateTime updatedAt;

  FreelancerPortfolioDto({
    required this.id,
    required this.freelancerId,
    required this.title,
    required this.description,
    this.roleInProject,
    required this.projectLink,
    required this.skills,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FreelancerPortfolioDto.fromJson(Map<String, dynamic> json) {
    return FreelancerPortfolioDto(
      id: json['id'] as int,
      freelancerId: json['freelancerId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      roleInProject: json['roleInProject'] as String?,
      projectLink: json['projectLink'] as String,
      skills: (json['skills'] as List)
          .map((e) => SkillDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'freelancerId': freelancerId,
    'title': title,
    'description': description,
    'roleInProject': roleInProject,
    'projectLink': projectLink,
    'skills': skills.map((s) => s.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class FreelancerPortfolioCreateDto {
  final String title;
  final String description;
  final String? roleInProject;
  final String projectLink;
  final List<int> skillIds;

  FreelancerPortfolioCreateDto({
    required this.title,
    required this.description,
    this.roleInProject,
    required this.projectLink,
    required this.skillIds,
  });

  factory FreelancerPortfolioCreateDto.fromJson(Map<String, dynamic> json) {
    return FreelancerPortfolioCreateDto(
      title: json['title'] as String,
      description: json['description'] as String,
      roleInProject: json['roleInProject'] as String?,
      projectLink: json['projectLink'] as String,
      skillIds:
      (json['skillIds'] as List).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'roleInProject': roleInProject,
    'projectLink': projectLink,
    'skillIds': skillIds,
  };
}

class FreelancerPortfolioUpdateDto {
  final String title;
  final String description;
  final String? roleInProject;
  final String projectLink;
  final List<int> skillIds;

  FreelancerPortfolioUpdateDto({
    required this.title,
    required this.description,
    this.roleInProject,
    required this.projectLink,
    required this.skillIds,
  });

  factory FreelancerPortfolioUpdateDto.fromJson(Map<String, dynamic> json) {
    return FreelancerPortfolioUpdateDto(
      title: json['title'] as String,
      description: json['description'] as String,
      roleInProject: json['roleInProject'] as String?,
      projectLink: json['projectLink'] as String,
      skillIds:
      (json['skillIds'] as List).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'roleInProject': roleInProject,
    'projectLink': projectLink,
    'skillIds': skillIds,
  };
}