import 'package:lexmastery_mobile/core/network/api_contract.dart';

class PromptRenderRequest {
  const PromptRenderRequest({
    required this.templateId,
    required this.context,
  });

  final String templateId;
  final Map<String, String> context;
}

class PromptRenderResponse {
  const PromptRenderResponse({
    required this.renderedPrompt,
  });

  final String renderedPrompt;
}

class PromptEngineeringApiContract
    implements ApiContract<PromptRenderRequest, PromptRenderResponse> {
  @override
  String get method => 'POST';

  @override
  String get path => '/prompt/generate';

  @override
  PromptRenderResponse parseResponse(Map<String, dynamic> json) {
    return PromptRenderResponse(
        renderedPrompt: json['renderedPrompt'] as String);
  }

  @override
  Map<String, dynamic> toRequest(PromptRenderRequest request) {
    return <String, dynamic>{
      'templateId': request.templateId,
      'context': request.context,
    };
  }
}
