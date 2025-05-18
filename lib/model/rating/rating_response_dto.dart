class RatingResponseDto {
  final int id;
  final int projectId;
  final int? raterFreelancerId;
  final int? raterClientId;
  final int? targetFreelancerId;
  final int? targetClientId;
  final int score;
  final DateTime createdAt;

  RatingResponseDto({
    required this.id,
    required this.projectId,
    this.raterFreelancerId,
    this.raterClientId,
    this.targetFreelancerId,
    this.targetClientId,
    required this.score,
    required this.createdAt,
  });

  factory RatingResponseDto.fromJson(Map<String, dynamic> json) {
    return RatingResponseDto(
      id: json['id'] as int,
      projectId: json['projectId'] as int,
      raterFreelancerId: json['raterFreelancerId'] as int?,
      raterClientId: json['raterClientId'] as int?,
      targetFreelancerId: json['targetFreelancerId'] as int?,
      targetClientId: json['targetClientId'] as int?,
      score: json['score'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'raterFreelancerId': raterFreelancerId,
    'raterClientId': raterClientId,
    'targetFreelancerId': targetFreelancerId,
    'targetClientId': targetClientId,
    'score': score,
    'createdAt': createdAt.toIso8601String(),
  };
}