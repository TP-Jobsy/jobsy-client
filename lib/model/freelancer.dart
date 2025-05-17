

class Freelancer {
  final String name;
  final String position;
  final String location;
  final double rating;
  final String avatarUrl;

  Freelancer({
    required this.name,
    required this.position,
    required this.location,
    required this.rating,
    required this.avatarUrl,
  });

  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
      name: json['name'],
      position: json['position'],
      location: json['location'],
      rating: json['rating'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
