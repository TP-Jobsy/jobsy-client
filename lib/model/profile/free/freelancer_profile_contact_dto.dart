class FreelancerProfileContact {
  final String contactLink;

  FreelancerProfileContact({
    required this.contactLink,
  });

  factory FreelancerProfileContact.fromJson(Map<String, dynamic> json) {
    final contactLink = json['contactLink'] as String? ?? '';

    return FreelancerProfileContact(
      contactLink: contactLink,
    );
  }

  Map<String, dynamic> toJson() => {
    'contactLink': contactLink,
  };
}