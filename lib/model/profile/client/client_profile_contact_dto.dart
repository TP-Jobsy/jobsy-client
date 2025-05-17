class ClientProfileContact {
  final String contactLink;

  ClientProfileContact({required this.contactLink});

  factory ClientProfileContact.fromJson(Map<String, dynamic> json) =>
      ClientProfileContact(
        contactLink: json['contactLink'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'contactLink': contactLink,
  };
}

