import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/features/ai_tutor/data/contracts/ai_tutor_api_contract.dart';
import 'package:lexmastery_mobile/features/ai_tutor/domain/repositories/ai_tutor_repository.dart';
import 'package:lexmastery_mobile/features/rag_engine/domain/entities/rag_chunk.dart';

class AiTutorRepositoryImpl implements AiTutorRepository {
  AiTutorRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  final AiTutorApiContract _contract = AiTutorApiContract();

  @override
  Stream<String> streamTutorResponse({
    required String question,
    required String mode,
    required String renderedPrompt,
    required List<RagChunk> groundedChunks,
  }) async* {
    String output;
    try {
      final response = await _apiClient.post(
        _contract.path,
        data: _contract.toRequest(
          AiTutorRequest(
            question: question,
            mode: mode,
            prompt: renderedPrompt,
            contextChunks:
                groundedChunks.map((RagChunk c) => c.toJson()).toList(),
          ),
        ),
      );
      output =
          _contract.parseResponse(response.data as Map<String, dynamic>).text;
    } catch (_) {
      final references = groundedChunks
          .map((RagChunk chunk) => '- ${chunk.title}: ${chunk.content}')
          .join('\n');
      output = '''
Answer: $question

Reasoning:
$references

Guided explanation:
Use the grounded principles above to answer in a step-by-step legal structure.
''';
    }

    for (final token in output.split(' ')) {
      await Future<void>.delayed(const Duration(milliseconds: 35));
      yield '$token ';
    }
  }
}
