import 'package:lexmastery_mobile/core/network/api_contract.dart';

class CourseDetailResponse {
  const CourseDetailResponse({
    required this.payload,
  });

  final Map<String, dynamic> payload;
}

class CourseDetailApiContract
    implements ApiContract<String, CourseDetailResponse> {
  @override
  String get method => 'GET';

  @override
  String get path => '/courses/detail';

  @override
  CourseDetailResponse parseResponse(Map<String, dynamic> json) {
    return CourseDetailResponse(payload: json);
  }

  @override
  Map<String, dynamic> toRequest(String request) {
    return <String, dynamic>{'courseId': request};
  }
}
