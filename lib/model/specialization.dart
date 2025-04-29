import 'category.dart';

class SpecializationDto {
  final int id;
  final String name;
  final CategoryDto? category;

  SpecializationDto({
    required this.id,
    required this.name,
    this.category,
  });

  factory SpecializationDto.fromJson(Map<String, dynamic> json) {
    return SpecializationDto(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] != null
          ? CategoryDto.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category?.toJson(),
    };
  }
}
