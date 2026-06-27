class CourseDetailLesson {
  const CourseDetailLesson({
    required this.id,
    required this.title,
    required this.durationMinutes,
  });

  final String id;
  final String title;
  final int durationMinutes;
}

class CourseDetailModule {
  const CourseDetailModule({
    required this.id,
    required this.title,
    required this.lessons,
  });

  final String id;
  final String title;
  final List<CourseDetailLesson> lessons;
}

class CourseDetail {
  const CourseDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.isEnrolled,
    required this.progressPercent,
    required this.modules,
  });

  final String id;
  final String title;
  final String description;
  final bool isEnrolled;
  final int progressPercent;
  final List<CourseDetailModule> modules;
}
