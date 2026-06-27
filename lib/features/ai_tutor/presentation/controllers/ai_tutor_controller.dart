import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/ai_memory/presentation/controllers/ai_memory_controller.dart';
import 'package:lexmastery_mobile/features/ai_tutor/data/repositories/ai_tutor_repository_impl.dart';
import 'package:lexmastery_mobile/features/ai_tutor/domain/entities/ai_tutor_message.dart';
import 'package:lexmastery_mobile/features/ai_tutor/domain/repositories/ai_tutor_repository.dart';
import 'package:lexmastery_mobile/features/ai_tutor/presentation/state/ai_tutor_state.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/presentation/controllers/prompt_engineering_controller.dart';
import 'package:lexmastery_mobile/features/rag_engine/domain/entities/rag_chunk.dart';
import 'package:lexmastery_mobile/features/rag_engine/presentation/controllers/rag_controller.dart';

final aiTutorRepositoryProvider = Provider<AiTutorRepository>(
  (ref) => AiTutorRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final aiTutorControllerProvider =
    NotifierProvider<AiTutorController, AiTutorState>(
  AiTutorController.new,
);

class AiTutorController extends Notifier<AiTutorState> {
  late final AiTutorRepository _repository;

  @override
  AiTutorState build() {
    _repository = ref.read(aiTutorRepositoryProvider);
    return const AiTutorState.initial();
  }

  void setMode(String mode) {
    state = state.copyWith(mode: mode);
  }

  Future<void> askTutor(String question) async {
    if (question.trim().isEmpty) return;
    state = state.copyWith(status: AiTutorStatus.loading);

    final chunks =
        await ref.read(ragControllerProvider.notifier).retrieve(question);
    if (chunks.isEmpty) {
      state = state.copyWith(
        status: AiTutorStatus.error,
        message:
            'No grounded context available. AI Tutor requires RAG evidence.',
      );
      return;
    }

    final templates =
        await ref.read(promptEngineeringRepositoryProvider).getTemplates();
    final tutorTemplate = templates.firstWhere(
      (template) => template.mode == 'tutor',
      orElse: () => templates.first,
    );
    final memory = await ref.read(aiMemoryRepositoryProvider).getProfile();
    final renderedPrompt =
        await ref.read(promptEngineeringRepositoryProvider).renderPrompt(
      template: tutorTemplate,
      context: <String, String>{
        'topic': question,
        'jurisdiction': memory.preferences['jurisdiction'] ?? 'unknown',
        'question': question,
      },
    );

    final userMessage = AiTutorMessage(
      role: 'user',
      content: question,
      createdAt: DateTime.now(),
    );
    final assistantMessage = AiTutorMessage(
      role: 'assistant',
      content: '',
      createdAt: DateTime.now(),
      citations: chunks.map((RagChunk chunk) => chunk.title).toList(),
    );
    var messages = <AiTutorMessage>[
      ...state.messages,
      userMessage,
      assistantMessage
    ];
    state = state.copyWith(status: AiTutorStatus.streaming, messages: messages);

    await for (final token in _repository.streamTutorResponse(
      question: question,
      mode: state.mode,
      renderedPrompt: renderedPrompt,
      groundedChunks: chunks,
    )) {
      final last = messages.last;
      final updatedLast = AiTutorMessage(
        role: last.role,
        content: '${last.content}$token',
        createdAt: last.createdAt,
        citations: last.citations,
      );
      messages = <AiTutorMessage>[
        ...messages.take(messages.length - 1),
        updatedLast,
      ];
      state =
          state.copyWith(status: AiTutorStatus.streaming, messages: messages);
    }

    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'ai_tutor_query',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{
              'mode': state.mode,
              'citationCount': chunks.length,
            },
          ),
        );

    state = state.copyWith(status: AiTutorStatus.completed, messages: messages);
  }
}
