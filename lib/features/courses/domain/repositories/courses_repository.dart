import 'package:lexmastery_mobile/features/courses/domain/entities/course_summary.dart';

abstract interface class CoursesRepository {
  Future<List<CourseSummary>> getCourses();
  Future<void> enrollInCourse(String courseId);
}
