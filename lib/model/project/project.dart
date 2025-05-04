import 'dart:convert';
import 'package:jobsy/model/category/category.dart';
import 'package:jobsy/model/profile/client/client_profile.dart';
import 'package:jobsy/model/skill/skill.dart';
import 'package:jobsy/model/specialization/specialization.dart';

import '../../enum/complexity.dart';
import '../../enum/payment-type.dart';
import '../../enum/project-duration.dart';
import '../../enum/project-status.dart';
import '../profile/free/freelancer_profile_dto.dart';

class Project {
  final int id;
  final String title;
  final String description;
  final Complexity complexity;
  final PaymentType paymentType;
  final double fixedPrice;
  final ProjectDuration duration;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category category;
  final Specialization specialization;
  final List<Skill> skills;
  final ClientProfile client;
  final FreelancerProfile? assignedFreelancer;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.complexity,
    required this.paymentType,
    required this.fixedPrice,
    required this.duration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.specialization,
    required this.skills,
    required this.client,
    this.assignedFreelancer,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    T _enumFromString<T>(Iterable<T> values, String? value) {
      return values.firstWhere((e) => e.toString().split('.').last == value);
    }

    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      complexity: _enumFromString(Complexity.values, json['complexity'] as String?),
      paymentType: _enumFromString(PaymentType.values, json['paymentType'] as String?),
      fixedPrice: (json['fixedPrice'] as num).toDouble(),
      duration: _enumFromString(ProjectDuration.values, json['duration'] as String?),
      status: _enumFromString(ProjectStatus.values, json['status'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      specialization: Specialization.fromJson(json['specialization'] as Map<String, dynamic>),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      client: ClientProfile.fromJson(json['client'] as Map<String, dynamic>),
      assignedFreelancer: json['assignedFreelancer'] != null
          ? FreelancerProfile.fromJson(json['assignedFreelancer'] as Map<String, dynamic>)
          : null,
    );
  }

  static Project fromJsonString(String jsonString) =>
      Project.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}