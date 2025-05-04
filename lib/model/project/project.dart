import 'dart:convert';
import '../../enum/payment-type.dart';
import '../../enum/project-duration.dart';
import '../../enum/project-status.dart';
import '../category/category.dart';
import '../profile/client/client_profile.dart';
import '../profile/free/freelancer_profile_dto.dart';
import '../skill/skill.dart';
import '../specialization/specialization.dart';
import '../../enum/complexity.dart';

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
    T _enumFromString<T>(Iterable<T> values, String? value) =>
        values.firstWhere((e) => e.toString().split('.').last == value);

    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      complexity:
      _enumFromString(Complexity.values, json['complexity'] as String?),
      paymentType:
      _enumFromString(PaymentType.values, json['paymentType'] as String?),
      fixedPrice: (json['fixedPrice'] as num).toDouble(),
      duration:
      _enumFromString(ProjectDuration.values, json['duration'] as String?),
      status:
      _enumFromString(ProjectStatus.values, json['status'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      specialization:
      Specialization.fromJson(json['specialization'] as Map<String, dynamic>),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      client: ClientProfile.fromJson(json['client'] as Map<String, dynamic>),
      assignedFreelancer: json['assignedFreelancer'] != null
          ? FreelancerProfile.fromJson(
          json['assignedFreelancer'] as Map<String, dynamic>)
          : null,
    );
  }

  static Project fromJsonString(String jsonString) =>
      Project.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'complexity': complexity.name,
    'paymentType': paymentType.name,
    'fixedPrice': fixedPrice,
    'duration': duration.name,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'category': category.toJson(),
    'specialization': specialization.toJson(),
    'skills': skills.map((s) => s.toJson()).toList(),
    'client': client.toJson(),
    'assignedFreelancer': assignedFreelancer?.toJson(),
  };
}