class LessonSummary {
  const LessonSummary({
    required this.id,
    required this.title,
    required this.durationMinutes,
  });

  final String id;
  final String title;
  final int durationMinutes;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
    };
  }

  factory LessonSummary.fromJson(Map<dynamic, dynamic> json) {
    return LessonSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      durationMinutes: json['durationMinutes'] as int,
    );
  }
}

class CourseModuleSummary {
  const CourseModuleSummary({
    required this.id,
    required this.title,
    required this.lessons,
  });

  final String id;
  final String title;
  final List<LessonSummary> lessons;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'lessons':
          lessons.map((LessonSummary lesson) => lesson.toJson()).toList(),
    };
  }

  factory CourseModuleSummary.fromJson(Map<dynamic, dynamic> json) {
    return CourseModuleSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((dynamic lesson) => LessonSummary.fromJson(lesson as Map))
          .toList(),
    );
  }
}

class CourseSummary {
  const CourseSummary({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.progressPercent,
    required this.modules,
  });

  final String id;
  final String title;
  final String difficulty;
  final int progressPercent;
  final List<CourseModuleSummary> modules;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'difficulty': difficulty,
      'progressPercent': progressPercent,
      'modules':
          modules.map((CourseModuleSummary module) => module.toJson()).toList(),
    };
  }

  factory CourseSummary.fromJson(Map<dynamic, dynamic> json) {
    return CourseSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
      progressPercent: json['progressPercent'] as int,
      modules: (json['modules'] as List<dynamic>)
          .map((dynamic module) => CourseModuleSummary.fromJson(module as Map))
          .toList(),
    );
  }
}
