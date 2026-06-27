import 'package:lexmastery_mobile/core/network/api_contract.dart';

class CoursesResponse {
  const CoursesResponse({
    required this.items,
  });

  final List<Map<String, dynamic>> items;
}

class CoursesApiContract implements ApiContract<void, CoursesResponse> {
  @override
  String get method => 'GET';

  @override
  String get path => '/courses';

  @override
  CoursesResponse parseResponse(Map<String, dynamic> json) {
    return CoursesResponse(
      items: (json['items'] as List<dynamic>)
          .map((dynamic item) => Map<String, dynamic>.from(item as Map))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toRequest(void request) => const <String, dynamic>{};
}

class EnrollCourseRequest {
  const EnrollCourseRequest({required this.courseId});
  final String courseId;
}

class EnrollCourseApiContract
    implements ApiContract<EnrollCourseRequest, void> {
  @override
  String get method => 'POST';

  @override
  String get path => '/courses/enroll';

  @override
  void parseResponse(Map<String, dynamic> json) {}

  @override
  Map<String, dynamic> toRequest(EnrollCourseRequest request) {
    return <String, dynamic>{'courseId': request.courseId};
  }
}
