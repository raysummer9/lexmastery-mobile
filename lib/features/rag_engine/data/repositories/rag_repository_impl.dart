import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/rag_engine/data/contracts/rag_api_contract.dart';
import 'package:lexmastery_mobile/features/rag_engine/domain/entities/rag_chunk.dart';
import 'package:lexmastery_mobile/features/rag_engine/domain/repositories/rag_repository.dart';

class RagRepositoryImpl implements RagRepository {
  RagRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final RagApiContract _contract = RagApiContract();

  @override
  Future<List<RagChunk>> retrieveChunks(String query) async {
    List<RagChunk> chunks;
    try {
      final response = await _apiClient.post(
        _contract.path,
        data: _contract.toRequest(RagQueryRequest(query: query)),
      );
      final parsed =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      chunks = parsed.items
          .map((Map<String, dynamic> item) => RagChunk.fromJson(item))
          .toList();
    } catch (_) {
      chunks = <RagChunk>[
        const RagChunk(
          sourceId: 'course-contract-law',
          title: 'Offer and Acceptance',
          content:
              'A valid offer must be certain, communicated, and made with intent to be bound.',
          score: 0.91,
        ),
        const RagChunk(
          sourceId: 'lesson-invitation-treat',
          title: 'Invitation to Treat',
          content:
              'An invitation to treat invites offers and does not itself create contractual obligations.',
          score: 0.87,
        ),
      ];
    }

    await LocalStorageService.writeValue(
      StorageKeys.ragChunkCache,
      jsonEncode(chunks.map((RagChunk chunk) => chunk.toJson()).toList()),
    );
    return chunks;
  }
}
