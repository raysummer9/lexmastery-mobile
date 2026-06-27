import 'package:lexmastery_mobile/features/courses/domain/entities/course_summary.dart';

enum CoursesStatus {
  loading,
  loaded,
  enrolling,
  failure,
}

class CoursesState {
  const CoursesState({
    required this.status,
    required this.courses,
    this.message,
  });

  const CoursesState.initial()
      : status = CoursesStatus.loading,
        courses = const <CourseSummary>[],
        message = null;

  final CoursesStatus status;
  final List<CourseSummary> courses;
  final String? message;

  CoursesState copyWith({
    CoursesStatus? status,
    List<CourseSummary>? courses,
    String? message,
  }) {
    return CoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      message: message,
    );
  }
}
