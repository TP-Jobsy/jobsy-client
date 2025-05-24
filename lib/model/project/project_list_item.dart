class ProjectListItem {
  final int id;
  final String title;
  final double fixedPrice;
  final String projectComplexity;
  final String projectDuration;
  final String status;
  final DateTime createdAt;
  final String? clientCompanyName;
  final String? clientCity;
  final String? clientCountry;
  final String? assignedFreelancerFirstName;
  final String? assignedFreelancerLastName;

  ProjectListItem({
    required this.id,
    required this.title,
    required this.fixedPrice,
    required this.projectComplexity,
    required this.projectDuration,
    required this.status,
    required this.createdAt,
    this.clientCompanyName,
    this.clientCity,
    this.clientCountry,
    this.assignedFreelancerFirstName,
    this.assignedFreelancerLastName,
  });

  factory ProjectListItem.fromJson(Map<String, dynamic> json) {
    return ProjectListItem(
      id: json['id'] as int,
      title: json['title'] as String,
      fixedPrice: (json['fixedPrice'] as num).toDouble(),
      projectComplexity: json['projectComplexity'] as String,
      projectDuration: json['projectDuration'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      clientCompanyName: json['clientCompanyName'] as String?,
      clientCity: json['clientCity'] as String?,
      clientCountry: json['clientCountry'] as String?,
      assignedFreelancerFirstName: json['assignedFreelancerFirstName'] as String?,
      assignedFreelancerLastName: json['assignedFreelancerLastName'] as String?,
    );
  }
}