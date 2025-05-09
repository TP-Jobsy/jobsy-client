import 'dart:convert';
import 'package:jobsy/model/skill/skill.dart';

class FreelancerProfileAbout {
  final int categoryId;
  final int specializationId;
  final String experienceLevel;
  final String aboutMe;
  final List<Skill> skills;

  FreelancerProfileAbout({
    required this.categoryId,
    required this.specializationId,
    required this.experienceLevel,
    required this.aboutMe,
    required this.skills,
  });

  factory FreelancerProfileAbout.fromJson(Map<String, dynamic> json) {
    final categoryId = (json['categoryId'] as num?)?.toInt() ?? 0;
    final specializationId = (json['specializationId'] as num?)?.toInt() ?? 0;
    final experienceLevel = json['experienceLevel'] as String? ?? '';
    final aboutMe = json['aboutMe'] as String? ?? '';
    final skillsJson = json['skills'] as List<dynamic>?;
    final skills =
        skillsJson
            ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <Skill>[];

    return FreelancerProfileAbout(
      categoryId: categoryId,
      specializationId: specializationId,
      experienceLevel: experienceLevel,
      aboutMe: aboutMe,
      skills: skills,
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'specializationId': specializationId,
    'experienceLevel': experienceLevel,
    'aboutMe': aboutMe,
    'skills': skills.map((e) => e.toJson()).toList(),
  };
}
