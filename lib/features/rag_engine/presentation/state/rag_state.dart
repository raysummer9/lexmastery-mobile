import 'package:lexmastery_mobile/features/rag_engine/domain/entities/rag_chunk.dart';

enum RagStatus {
  loading,
  retrieved,
  merged,
  failure,
}

class RagState {
  const RagState({
    required this.status,
    required this.chunks,
    this.message,
  });

  const RagState.initial()
      : status = RagStatus.loading,
        chunks = const <RagChunk>[],
        message = null;

  final RagStatus status;
  final List<RagChunk> chunks;
  final String? message;

  RagState copyWith({
    RagStatus? status,
    List<RagChunk>? chunks,
    String? message,
  }) {
    return RagState(
      status: status ?? this.status,
      chunks: chunks ?? this.chunks,
      message: message,
    );
  }
}
