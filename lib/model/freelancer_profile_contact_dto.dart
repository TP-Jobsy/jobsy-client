class FreelancerProfileContactDto {
  final String contactLink;

  FreelancerProfileContactDto({
    required this.contactLink,
  });

  factory FreelancerProfileContactDto.fromJson(Map<String, dynamic> json) {
    final contactLink = json['contactLink'] as String? ?? '';

    return FreelancerProfileContactDto(
      contactLink: contactLink,
    );
  }

  Map<String, dynamic> toJson() => {
    'contactLink': contactLink,
  };
}