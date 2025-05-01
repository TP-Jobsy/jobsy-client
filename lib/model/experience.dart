
class ExperienceDto {
  final int id;
  final String name;

  ExperienceDto({
    required this.id,
    required this.name,
  });

  factory ExperienceDto.fromJson(Map<String, dynamic> json) {
    return ExperienceDto(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}