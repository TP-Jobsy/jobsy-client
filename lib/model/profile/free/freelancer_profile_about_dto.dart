import 'package:jobsy/model/skill/skill.dart';

class FreelancerProfileAbout {
  final int categoryId;
  final String categoryName;
  final int specializationId;
  final String specializationName;
  final String experienceLevel;
  final String aboutMe;
  final List<Skill> skills;

  FreelancerProfileAbout({
    required this.categoryId,
    required this.categoryName,
    required this.specializationId,
    required this.specializationName,
    required this.experienceLevel,
    required this.aboutMe,
    required this.skills,
  });

  factory FreelancerProfileAbout.fromJson(Map<String, dynamic> json) {
    return FreelancerProfileAbout(
      categoryId: (json['categoryId'] as num?)?.toInt() ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      specializationId: (json['specializationId'] as num?)?.toInt() ?? 0,
      specializationName: json['specializationName'] as String? ?? '',
      experienceLevel: json['experienceLevel'] as String? ?? '',
      aboutMe: json['aboutMe'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList() ??
          <Skill>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'specializationId': specializationId,
    'specializationName': specializationName,
    'experienceLevel': experienceLevel,
    'aboutMe': aboutMe,
    'skills': skills.map((e) => e.toJson()).toList(),
  };
}
