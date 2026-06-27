import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:lexmastery_mobile/features/ai_chat/domain/entities/ai_chat_thread.dart';
import 'package:lexmastery_mobile/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:lexmastery_mobile/features/ai_chat/presentation/state/ai_chat_state.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>(
  (ref) => AiChatRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final aiChatControllerProvider =
    NotifierProvider<AiChatController, AiChatState>(
  AiChatController.new,
);

class AiChatController extends Notifier<AiChatState> {
  late final AiChatRepository _repository;

  @override
  AiChatState build() {
    _repository = ref.read(aiChatRepositoryProvider);
    return const AiChatState.initial();
  }

  Future<void> loadThreads() async {
    state = state.copyWith(status: AiChatStatus.loading);
    final threads = await _repository.loadThreads();
    final activeId = threads.isEmpty ? null : threads.first.id;
    state = state.copyWith(
      status: AiChatStatus.idle,
      threads: threads,
      activeThreadId: activeId,
    );
  }

  Future<void> startThread() async {
    final thread = AiChatThread(
      id: 'thread-${DateTime.now().microsecondsSinceEpoch}',
      title: 'New Thread',
      messages: const <AiChatMessage>[],
      updatedAt: DateTime.now(),
    );
    final updated = <AiChatThread>[thread, ...state.threads];
    await _repository.saveThreads(updated);
    state = state.copyWith(threads: updated, activeThreadId: thread.id);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final currentThread = state.activeThread;
    if (currentThread == null) {
      await startThread();
    }
    final thread = state.activeThread!;
    final userMessage = AiChatMessage(
      role: 'user',
      content: text,
      createdAt: DateTime.now(),
    );
    final botMessage = AiChatMessage(
      role: 'assistant',
      content: '',
      createdAt: DateTime.now(),
    );
    var messages = <AiChatMessage>[...thread.messages, userMessage, botMessage];
    _setThreadMessages(thread.id, messages, status: AiChatStatus.streaming);

    final routingTarget = _detectRoutingTarget(text);
    if (routingTarget != AiChatRoutingTarget.none) {
      state = state.copyWith(routingTarget: routingTarget);
    }

    await for (final token in _repository.streamAssistantResponse(
        message: text, mode: state.mode)) {
      final last = messages.last;
      final updatedLast = AiChatMessage(
        role: last.role,
        content: '${last.content}$token',
        createdAt: last.createdAt,
      );
      messages = <AiChatMessage>[
        ...messages.take(messages.length - 1),
        updatedLast,
      ];
      _setThreadMessages(thread.id, messages, status: AiChatStatus.streaming);
    }

    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'ai_chat_message_sent',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{'mode': state.mode},
          ),
        );
    _setThreadMessages(thread.id, messages, status: AiChatStatus.responding);
  }

  void setMode(String mode) {
    state = state.copyWith(mode: mode);
  }

  void consumeRoutingSignal() {
    state = state.copyWith(routingTarget: AiChatRoutingTarget.none);
  }

  AiChatRoutingTarget _detectRoutingTarget(String text) {
    final normalized = text.toLowerCase();
    if (normalized.contains('teach') ||
        normalized.contains('step-by-step') ||
        normalized.contains('quiz me')) {
      return AiChatRoutingTarget.tutor;
    }
    return AiChatRoutingTarget.none;
  }

  Future<void> _setThreadMessages(
    String threadId,
    List<AiChatMessage> messages, {
    required AiChatStatus status,
  }) async {
    final updated = state.threads.map((AiChatThread thread) {
      if (thread.id != threadId) return thread;
      return AiChatThread(
        id: thread.id,
        title: thread.title,
        messages: messages,
        updatedAt: DateTime.now(),
      );
    }).toList();
    await _repository.saveThreads(updated);
    state = state.copyWith(
      status: status,
      threads: updated,
      activeThreadId: threadId,
    );
  }
}
