import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/data/contracts/prompt_engineering_api_contract.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/domain/entities/prompt_template.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/domain/repositories/prompt_engineering_repository.dart';

class PromptEngineeringRepositoryImpl implements PromptEngineeringRepository {
  PromptEngineeringRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  final PromptEngineeringApiContract _contract = PromptEngineeringApiContract();

  @override
  Future<List<PromptTemplate>> getTemplates() async {
    final cached =
        LocalStorageService.readValue<String>(StorageKeys.promptTemplates);
    if (cached != null) {
      final decoded = jsonDecode(cached) as List<dynamic>;
      return decoded
          .map((dynamic item) => PromptTemplate.fromJson(item as Map))
          .toList();
    }
    final templates = <PromptTemplate>[
      const PromptTemplate(
        id: 'tutor_explanation',
        name: 'Tutor Explanation',
        mode: 'tutor',
        template:
            'Role: legal mentor. Topic: {{topic}}. Jurisdiction: {{jurisdiction}}. Explain with citations.',
      ),
      const PromptTemplate(
        id: 'chat_general',
        name: 'Chat General',
        mode: 'chat',
        template:
            'Role: assistant. User question: {{question}}. Keep response professional and concise.',
      ),
    ];
    await LocalStorageService.writeValue(
      StorageKeys.promptTemplates,
      jsonEncode(
        templates.map((PromptTemplate template) => template.toJson()).toList(),
      ),
    );
    return templates;
  }

  @override
  Future<String> renderPrompt({
    required PromptTemplate template,
    required Map<String, String> context,
  }) async {
    try {
      final response = await _apiClient.post(
        _contract.path,
        data: _contract.toRequest(
          PromptRenderRequest(
            templateId: template.id,
            context: context,
          ),
        ),
      );
      final parsed =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      return parsed.renderedPrompt;
    } catch (_) {
      var rendered = template.template;
      for (final entry in context.entries) {
        rendered = rendered.replaceAll('{{${entry.key}}}', entry.value);
      }
      return rendered;
    }
  }
}
