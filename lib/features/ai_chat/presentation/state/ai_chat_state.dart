import 'package:lexmastery_mobile/features/ai_chat/domain/entities/ai_chat_thread.dart';

enum AiChatStatus {
  idle,
  loading,
  streaming,
  responding,
  failure,
}

enum AiChatRoutingTarget {
  none,
  tutor,
}

class AiChatState {
  const AiChatState({
    required this.status,
    required this.threads,
    required this.mode,
    required this.routingTarget,
    this.activeThreadId,
    this.message,
  });

  const AiChatState.initial()
      : status = AiChatStatus.idle,
        threads = const <AiChatThread>[],
        mode = 'general',
        routingTarget = AiChatRoutingTarget.none,
        activeThreadId = null,
        message = null;

  final AiChatStatus status;
  final List<AiChatThread> threads;
  final String mode;
  final AiChatRoutingTarget routingTarget;
  final String? activeThreadId;
  final String? message;

  AiChatThread? get activeThread {
    if (activeThreadId == null) return null;
    final filtered =
        threads.where((AiChatThread thread) => thread.id == activeThreadId);
    return filtered.isEmpty ? null : filtered.first;
  }

  AiChatState copyWith({
    AiChatStatus? status,
    List<AiChatThread>? threads,
    String? mode,
    AiChatRoutingTarget? routingTarget,
    String? activeThreadId,
    String? message,
  }) {
    return AiChatState(
      status: status ?? this.status,
      threads: threads ?? this.threads,
      mode: mode ?? this.mode,
      routingTarget: routingTarget ?? this.routingTarget,
      activeThreadId: activeThreadId ?? this.activeThreadId,
      message: message,
    );
  }
}
