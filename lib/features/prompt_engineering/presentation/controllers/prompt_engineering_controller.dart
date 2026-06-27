import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/data/repositories/prompt_engineering_repository_impl.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/domain/entities/prompt_template.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/domain/repositories/prompt_engineering_repository.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/presentation/state/prompt_engineering_state.dart';

final promptEngineeringRepositoryProvider =
    Provider<PromptEngineeringRepository>(
  (ref) =>
      PromptEngineeringRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final promptEngineeringControllerProvider =
    NotifierProvider<PromptEngineeringController, PromptEngineeringState>(
  PromptEngineeringController.new,
);

class PromptEngineeringController extends Notifier<PromptEngineeringState> {
  late final PromptEngineeringRepository _repository;

  @override
  PromptEngineeringState build() {
    _repository = ref.read(promptEngineeringRepositoryProvider);
    return const PromptEngineeringState.initial();
  }

  Future<void> loadTemplates() async {
    state = state.copyWith(status: PromptEngineeringStatus.loading);
    try {
      final templates = await _repository.getTemplates();
      state = state.copyWith(
        status: PromptEngineeringStatus.ready,
        templates: templates,
      );
    } catch (_) {
      state = state.copyWith(
        status: PromptEngineeringStatus.failure,
        message: 'Unable to load prompt templates.',
      );
    }
  }

  Future<void> render({
    required PromptTemplate template,
    required Map<String, String> context,
  }) async {
    state = state.copyWith(status: PromptEngineeringStatus.rendering);
    final rendered = await _repository.renderPrompt(
      template: template,
      context: context,
    );
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'prompt_rendered',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{'templateId': template.id},
          ),
        );
    state = state.copyWith(
      status: PromptEngineeringStatus.ready,
      renderedPrompt: rendered,
    );
  }
}
