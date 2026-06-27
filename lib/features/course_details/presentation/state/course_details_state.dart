import 'package:lexmastery_mobile/features/course_details/domain/entities/course_detail.dart';

enum CourseDetailsStatus {
  loading,
  loaded,
  refreshing,
  failure,
}

class CourseDetailsState {
  const CourseDetailsState({
    required this.status,
    this.courseDetail,
    this.message,
  });

  const CourseDetailsState.initial()
      : status = CourseDetailsStatus.loading,
        courseDetail = null,
        message = null;

  final CourseDetailsStatus status;
  final CourseDetail? courseDetail;
  final String? message;

  CourseDetailsState copyWith({
    CourseDetailsStatus? status,
    CourseDetail? courseDetail,
    String? message,
  }) {
    return CourseDetailsState(
      status: status ?? this.status,
      courseDetail: courseDetail ?? this.courseDetail,
      message: message,
    );
  }
}
