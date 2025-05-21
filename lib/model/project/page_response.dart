class PageResponse<T> {
  final List<T> content;
  final int number;
  final int size;
  final int totalElements;
  final int totalPages;

  PageResponse({
    required this.content,
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory PageResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) itemParser,
      ) {
    return PageResponse(
      content: (json['content'] as List)
          .map((e) => itemParser(e as Map<String, dynamic>))
          .toList(),
      number: json['number'] as int,
      size: json['size'] as int,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}