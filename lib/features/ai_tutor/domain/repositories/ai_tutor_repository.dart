import 'package:lexmastery_mobile/features/rag_engine/domain/entities/rag_chunk.dart';

abstract interface class AiTutorRepository {
  Stream<String> streamTutorResponse({
    required String question,
    required String mode,
    required String renderedPrompt,
    required List<RagChunk> groundedChunks,
  });
}
