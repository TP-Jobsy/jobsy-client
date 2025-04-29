class ProjectApplicationDto {
  final String id;
  final String freelancerName;
  final String status;
  ProjectApplicationDto.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        freelancerName = json['freelancerName'] ?? '',
        status = json['status'] ?? '';
}