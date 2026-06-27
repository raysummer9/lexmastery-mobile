import 'package:lexmastery_mobile/core/network/api_contract.dart';

class QuizQuestionsResponse {
  const QuizQuestionsResponse({required this.items});
  final List<Map<String, dynamic>> items;
}

class QuizQuestionsApiContract
    implements ApiContract<void, QuizQuestionsResponse> {
  @override
  String get method => 'GET';

  @override
  String get path => '/quizzes';

  @override
  QuizQuestionsResponse parseResponse(Map<String, dynamic> json) {
    return QuizQuestionsResponse(
      items: (json['items'] as List<dynamic>)
          .map((dynamic e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toRequest(void request) => const <String, dynamic>{};
}
