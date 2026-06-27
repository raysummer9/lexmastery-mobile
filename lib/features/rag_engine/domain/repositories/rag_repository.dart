import 'package:lexmastery_mobile/features/rag_engine/domain/entities/rag_chunk.dart';

abstract interface class RagRepository {
  Future<List<RagChunk>> retrieveChunks(String query);
}
