import '../category/category.dart';

class Specialization {
  final int id;
  final String name;
  final Category? category;

  Specialization({
    required this.id,
    required this.name,
    this.category,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category?.toJson(),
    };
  }
}
