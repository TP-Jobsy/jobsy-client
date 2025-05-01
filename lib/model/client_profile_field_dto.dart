class ClientProfileFieldDto {
  final String fieldDescription;

  ClientProfileFieldDto({required this.fieldDescription});

  factory ClientProfileFieldDto.fromJson(Map<String, dynamic> json) =>
      ClientProfileFieldDto(
        fieldDescription: json['fieldDescription'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'fieldDescription': fieldDescription,
  };
}