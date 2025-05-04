class ClientProfileField {
  final String fieldDescription;

  ClientProfileField({required this.fieldDescription});

  factory ClientProfileField.fromJson(Map<String, dynamic> json) =>
      ClientProfileField(
        fieldDescription: json['fieldDescription'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'fieldDescription': fieldDescription,
  };
}