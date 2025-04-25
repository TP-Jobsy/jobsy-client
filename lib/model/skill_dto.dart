class SkillDto {
  final int id;
  final String name;

  SkillDto({
    required this.id,
    required this.name,
  });

  factory SkillDto.fromJson(Map<String, dynamic> json) {
    return SkillDto(
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

  @override
  String toString() => name;
}
