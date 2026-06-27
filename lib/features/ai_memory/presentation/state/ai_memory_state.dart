import 'package:lexmastery_mobile/features/ai_memory/domain/entities/ai_memory_profile.dart';

enum AiMemoryStatus {
  loading,
  ready,
  syncing,
  failure,
}

class AiMemoryState {
  const AiMemoryState({
    required this.status,
    this.profile,
    this.message,
  });

  const AiMemoryState.initial()
      : status = AiMemoryStatus.loading,
        profile = null,
        message = null;

  final AiMemoryStatus status;
  final AiMemoryProfile? profile;
  final String? message;

  AiMemoryState copyWith({
    AiMemoryStatus? status,
    AiMemoryProfile? profile,
    String? message,
  }) {
    return AiMemoryState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      message: message,
    );
  }
}
