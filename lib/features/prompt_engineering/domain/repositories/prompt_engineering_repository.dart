import 'package:lexmastery_mobile/features/prompt_engineering/domain/entities/prompt_template.dart';

abstract interface class PromptEngineeringRepository {
  Future<List<PromptTemplate>> getTemplates();
  Future<String> renderPrompt({
    required PromptTemplate template,
    required Map<String, String> context,
  });
}
