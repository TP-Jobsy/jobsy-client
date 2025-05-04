class ProjectUpdate {
  final String? title;
  final String? description;
  final String? complexity;
  final String? paymentType;
  final double? fixedPrice;
  final String? duration;
  final int? categoryId;
  final int? specializationId;
  final List<int>? skillIds;
  final String? status;

  ProjectUpdate({
    this.title,
    this.description,
    this.complexity,
    this.paymentType,
    this.fixedPrice,
    this.duration,
    this.categoryId,
    this.specializationId,
    this.skillIds,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    if (title != null) m['title'] = title;
    if (description != null) m['description'] = description;
    if (complexity != null) m['complexity'] = complexity;
    if (paymentType != null) m['paymentType'] = paymentType;
    if (fixedPrice != null) m['fixedPrice'] = fixedPrice;
    if (duration != null) m['duration'] = duration;
    if (categoryId != null) m['category'] = {'id': categoryId};
    if (specializationId != null) m['specialization'] = {'id': specializationId};
    if (skillIds != null) {
      m['skills'] = skillIds!.map((id) => {'id': id}).toList();
    }
    if (status != null) m['status'] = status;
    return m;
  }
}