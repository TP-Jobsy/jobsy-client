import 'dart:convert';

import '../../enum/complexity.dart';
import '../../enum/payment-type.dart';
import '../../enum/project-duration.dart';
import '../../enum/project-status.dart';
import '../category/category.dart';
import '../profile/client/client_profile.dart';
import '../profile/free/freelancer_profile_dto.dart';
import '../skill/skill.dart';
import '../specialization/specialization.dart';

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
  final bool clientCompleted;
  final bool freelancerCompleted;

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
    required this.clientCompleted,
    required this.freelancerCompleted,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    T enumFromString<T extends Enum>(
        Iterable<T> values,
        String? value, {
          required T fallback,
        }) {
      if (value == null) return fallback;
      return values.firstWhere(
            (e) => e.name == value,
        orElse: () => fallback,
      );
    }

    return Project(
      id: json['id'] as int,
      clientCompleted: json['clientCompleted'] as bool? ?? false,
      freelancerCompleted: json['freelancerCompleted'] as bool? ?? false,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      complexity: enumFromString<Complexity>(
        Complexity.values,
        json['complexity'] as String?,
        fallback: Complexity.EASY,
      ),
      paymentType: enumFromString<PaymentType>(
        PaymentType.values,
        json['paymentType'] as String?,
        fallback: PaymentType.FIXED,
      ),
      fixedPrice: (json['fixedPrice'] as num?)?.toDouble() ?? 0.0,
      duration: enumFromString<ProjectDuration>(
        ProjectDuration.values,
        json['duration'] as String?,
        fallback: ProjectDuration.LESS_THAN_1_MONTH,
      ),
      status: enumFromString<ProjectStatus>(
        ProjectStatus.values,
        json['status'] as String?,
        fallback: ProjectStatus.DRAFT,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      category: Category.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      specialization: Specialization.fromJson(
        json['specialization'] as Map<String, dynamic>,
      ),
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      client: ClientProfile.fromJson(
        json['client'] as Map<String, dynamic>,
      ),
      assignedFreelancer: json['assignedFreelancer'] != null
          ? FreelancerProfile.fromJson(
        json['assignedFreelancer'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  static Project fromJsonString(String jsonString) =>
      Project.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  Map<String, dynamic> toJson() {
    return {
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
      'clientCompleted': clientCompleted,
      'freelancerCompleted': freelancerCompleted,
    };
  }
}