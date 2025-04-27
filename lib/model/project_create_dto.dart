import 'package:jobsy/model/category_dto.dart';
import 'package:jobsy/model/specialization_dto.dart';
import 'package:jobsy/model/skill_dto.dart';

class ProjectCreateDto {
  final String title;
  final String? description;
  final String? complexity;
  final String? paymentType;
  final double? fixedPrice;
  final String? duration;
  final CategoryDto category;
  final SpecializationDto specialization;
  final List<SkillDto> skills;

  ProjectCreateDto({
    required this.title,
    this.description,
    this.complexity,
    this.paymentType,
    this.fixedPrice,
    this.duration,
    required this.category,
    required this.specialization,
    required this.skills,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'complexity': complexity,
      'paymentType': paymentType,
      'fixedPrice': fixedPrice,
      'duration': duration,
      'category': {'id': category.id},
      'specialization': {'id': specialization.id},
      'skills': skills.map((s) => {'id': s.id}).toList(),
    };
  }
}

