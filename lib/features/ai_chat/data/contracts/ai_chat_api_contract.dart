import 'package:lexmastery_mobile/core/network/api_contract.dart';

class AiChatRequest {
  const AiChatRequest({
    required this.message,
    required this.mode,
  });

  final String message;
  final String mode;
}

class AiChatResponse {
  const AiChatResponse({required this.text});
  final String text;
}

class AiChatApiContract implements ApiContract<AiChatRequest, AiChatResponse> {
  @override
  String get method => 'POST';

  @override
  String get path => '/ai/chat';

  @override
  AiChatResponse parseResponse(Map<String, dynamic> json) {
    return AiChatResponse(text: json['text'] as String);
  }

  @override
  Map<String, dynamic> toRequest(AiChatRequest request) {
    return <String, dynamic>{
      'message': request.message,
      'mode': request.mode,
    };
  }
}
