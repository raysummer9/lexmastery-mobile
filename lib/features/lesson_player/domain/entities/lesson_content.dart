class LessonContent {
  const LessonContent({
    required this.lessonId,
    required this.title,
    required this.paragraphs,
  });

  final String lessonId;
  final String title;
  final List<String> paragraphs;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lessonId': lessonId,
      'title': title,
      'paragraphs': paragraphs,
    };
  }

  factory LessonContent.fromJson(Map<dynamic, dynamic> json) {
    return LessonContent(
      lessonId: json['lessonId'] as String,
      title: json['title'] as String,
      paragraphs: (json['paragraphs'] as List<dynamic>)
          .map((dynamic e) => '$e')
          .toList(),
    );
  }
}

class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    required this.readParagraphs,
    required this.totalParagraphs,
    required this.updatedAt,
  });

  final String lessonId;
  final int readParagraphs;
  final int totalParagraphs;
  final DateTime updatedAt;

  int get progressPercent => totalParagraphs == 0
      ? 0
      : ((readParagraphs / totalParagraphs) * 100).round();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lessonId': lessonId,
      'readParagraphs': readParagraphs,
      'totalParagraphs': totalParagraphs,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory LessonProgress.fromJson(Map<dynamic, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] as String,
      readParagraphs: json['readParagraphs'] as int,
      totalParagraphs: json['totalParagraphs'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
