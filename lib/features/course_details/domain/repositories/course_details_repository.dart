import 'package:lexmastery_mobile/features/course_details/domain/entities/course_detail.dart';

abstract interface class CourseDetailsRepository {
  Future<CourseDetail> getCourseDetail(String courseId);
}
