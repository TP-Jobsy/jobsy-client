import 'package:jobsy/model/profile/free/freelancer_profile_about_dto.dart';
import 'package:jobsy/model/profile/free/freelancer_profile_basic_dto.dart';
import 'package:jobsy/model/user.dart';

import '../../skill/skill.dart';
import 'freelancer_profile_contact_dto.dart';

class FreelancerProfile {
  final int id;
  final FreelancerProfileAbout about;
  final FreelancerProfileBasic basic;
  final FreelancerProfileContact contact;
  final UserDto user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatarUrl;
  final double averageRating;
  final int ratingCount;
  final List<Skill> skills;

  FreelancerProfile({
    required this.id,
    required this.about,
    required this.basic,
    required this.contact,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    this.avatarUrl,
    required this.averageRating,
    required this.ratingCount,
    required this.skills,
  });

  factory FreelancerProfile.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>? ?? {};
    final userDto = UserDto.fromJson(userMap);
    final basicRaw = Map<String, dynamic>.from(
      json['basic'] as Map<String, dynamic>? ?? {},
    );
    basicRaw['dateBirth'] = userDto.dateBirth;
    final basicDto = FreelancerProfileBasic.fromJson(basicRaw);
    final aboutRaw = Map<String, dynamic>.from(
      json['about'] as Map<String, dynamic>? ?? {},
    );
    final aboutDto = FreelancerProfileAbout.fromJson(aboutRaw);
    final contactRaw = Map<String, dynamic>.from(
      json['contact'] as Map<String, dynamic>? ?? {},
    );
    final skillsList = (aboutRaw['skills'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>()
        .map((m) => Skill.fromJson(m))
        .toList() ??
        <Skill>[];
    final contactDto = FreelancerProfileContact.fromJson(contactRaw);

    return FreelancerProfile(
      id: json['id'] as int,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] as int? ?? 0,
      about: aboutDto,
      basic: basicDto,
      contact: contactDto,
      user: userDto,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      avatarUrl: json['avatarUrl'] as String?,
      skills: skillsList,
    );
  }

  Map<String, dynamic> toJson() {
    final aboutWithSkills = {
      ...about.toJson(),
      'skills': skills.map((s) => s.toJson()).toList(),
    };

    return {
      'id': id,
      'about': aboutWithSkills,
      'basic': basic.toJson(),
      'contact': contact.toJson(),
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'avatarUrl': avatarUrl,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
    };
  }
}