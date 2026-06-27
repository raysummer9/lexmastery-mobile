import 'package:lexmastery_mobile/core/network/api_contract.dart';

class LessonContentResponse {
  const LessonContentResponse({
    required this.payload,
  });

  final Map<String, dynamic> payload;
}

class LessonContentApiContract
    implements ApiContract<String, LessonContentResponse> {
  @override
  String get method => 'GET';

  @override
  String get path => '/lessons/content';

  @override
  LessonContentResponse parseResponse(Map<String, dynamic> json) {
    return LessonContentResponse(payload: json);
  }

  @override
  Map<String, dynamic> toRequest(String request) {
    return <String, dynamic>{'lessonId': request};
  }
}
