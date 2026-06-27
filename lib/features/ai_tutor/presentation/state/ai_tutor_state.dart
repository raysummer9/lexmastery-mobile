import 'package:lexmastery_mobile/features/ai_tutor/domain/entities/ai_tutor_message.dart';

enum AiTutorStatus {
  idle,
  loading,
  streaming,
  responding,
  error,
  completed,
}

class AiTutorState {
  const AiTutorState({
    required this.status,
    required this.messages,
    required this.mode,
    this.message,
  });

  const AiTutorState.initial()
      : status = AiTutorStatus.idle,
        messages = const <AiTutorMessage>[],
        mode = 'explanation',
        message = null;

  final AiTutorStatus status;
  final List<AiTutorMessage> messages;
  final String mode;
  final String? message;

  AiTutorState copyWith({
    AiTutorStatus? status,
    List<AiTutorMessage>? messages,
    String? mode,
    String? message,
  }) {
    return AiTutorState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      mode: mode ?? this.mode,
      message: message,
    );
  }
}
