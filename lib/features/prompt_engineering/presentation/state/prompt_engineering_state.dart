import 'package:lexmastery_mobile/features/prompt_engineering/domain/entities/prompt_template.dart';

enum PromptEngineeringStatus {
  loading,
  ready,
  rendering,
  failure,
}

class PromptEngineeringState {
  const PromptEngineeringState({
    required this.status,
    required this.templates,
    this.renderedPrompt,
    this.message,
  });

  const PromptEngineeringState.initial()
      : status = PromptEngineeringStatus.loading,
        templates = const <PromptTemplate>[],
        renderedPrompt = null,
        message = null;

  final PromptEngineeringStatus status;
  final List<PromptTemplate> templates;
  final String? renderedPrompt;
  final String? message;

  PromptEngineeringState copyWith({
    PromptEngineeringStatus? status,
    List<PromptTemplate>? templates,
    String? renderedPrompt,
    String? message,
  }) {
    return PromptEngineeringState(
      status: status ?? this.status,
      templates: templates ?? this.templates,
      renderedPrompt: renderedPrompt ?? this.renderedPrompt,
      message: message,
    );
  }
}
