import 'package:lexmastery_mobile/core/network/api_contract.dart';

class MockExamResponse {
  const MockExamResponse({required this.items});
  final List<Map<String, dynamic>> items;
}

class MockExamApiContract implements ApiContract<void, MockExamResponse> {
  @override
  String get method => 'GET';

  @override
  String get path => '/exams';

  @override
  MockExamResponse parseResponse(Map<String, dynamic> json) {
    return MockExamResponse(
      items: (json['items'] as List<dynamic>)
          .map((dynamic e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toRequest(void request) => const <String, dynamic>{};
}
