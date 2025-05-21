class FreelancerListItem {
  final int id;
  final String firstName;
  final String lastName;
  final String? country;
  final String? city;
  final String? avatarUrl;
  final double averageRating;
  final String? experienceLevel;
  final String? categoryName;
  final String? specializationName;

  FreelancerListItem({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.country,
    this.city,
    this.avatarUrl,
    required this.averageRating,
    this.experienceLevel,
    this.categoryName,
    this.specializationName,
  });

  factory FreelancerListItem.fromJson(Map<String, dynamic> json) {
    return FreelancerListItem(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      country: json['country'] as String?,
      city: json['city'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      averageRating: (json['averageRating'] as num).toDouble(),
      experienceLevel: json['experienceLevel'] as String?,
      categoryName: json['categoryName'] as String?,
      specializationName: json['specializationName'] as String?,
    );
  }
}