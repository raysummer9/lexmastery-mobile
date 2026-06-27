import 'package:lexmastery_mobile/core/network/api_contract.dart';

class AiTutorRequest {
  const AiTutorRequest({
    required this.question,
    required this.mode,
    required this.prompt,
    required this.contextChunks,
  });

  final String question;
  final String mode;
  final String prompt;
  final List<Map<String, dynamic>> contextChunks;
}

class AiTutorResponse {
  const AiTutorResponse({required this.text});
  final String text;
}

class AiTutorApiContract
    implements ApiContract<AiTutorRequest, AiTutorResponse> {
  @override
  String get method => 'POST';

  @override
  String get path => '/ai/tutor';

  @override
  AiTutorResponse parseResponse(Map<String, dynamic> json) {
    return AiTutorResponse(text: json['text'] as String);
  }

  @override
  Map<String, dynamic> toRequest(AiTutorRequest request) {
    return <String, dynamic>{
      'question': request.question,
      'mode': request.mode,
      'prompt': request.prompt,
      'contextChunks': request.contextChunks,
    };
  }
}
