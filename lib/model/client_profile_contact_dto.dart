class ClientProfileContactDto {
  final String contactLink;

  ClientProfileContactDto({required this.contactLink});

  factory ClientProfileContactDto.fromJson(Map<String, dynamic> json) =>
      ClientProfileContactDto(
        contactLink: json['contactLink'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'contactLink': contactLink,
  };
}

