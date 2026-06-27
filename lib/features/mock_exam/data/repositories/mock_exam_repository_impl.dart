import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/mock_exam/data/contracts/mock_exam_api_contract.dart';
import 'package:lexmastery_mobile/features/mock_exam/domain/entities/mock_exam_question.dart';
import 'package:lexmastery_mobile/features/mock_exam/domain/repositories/mock_exam_repository.dart';

class MockExamRepositoryImpl implements MockExamRepository {
  MockExamRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  final MockExamApiContract _contract = MockExamApiContract();

  @override
  Future<List<MockExamQuestion>> getExamQuestions() async {
    try {
      final response = await _apiClient.get(_contract.path);
      final parsed =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      return parsed.items
          .map(
            (Map<String, dynamic> item) => MockExamQuestion(
              id: item['id'] as String,
              prompt: item['prompt'] as String,
              options: (item['options'] as List<dynamic>)
                  .map((dynamic e) => '$e')
                  .toList(),
              correctIndex: item['correctIndex'] as int,
            ),
          )
          .toList();
    } catch (_) {
      return const <MockExamQuestion>[
        MockExamQuestion(
          id: 'mq1',
          prompt: 'Which statement best describes promissory estoppel?',
          options: <String>[
            'A cause of action for damages.',
            'A doctrine preventing strict legal rights enforcement in equity.',
            'A criminal-law defense.',
            'A tax-law exception.',
          ],
          correctIndex: 1,
        ),
      ];
    }
  }

  @override
  Future<Map<String, dynamic>?> restoreExamSession() async {
    final raw =
        LocalStorageService.readValue<String>(StorageKeys.mockExamSessionState);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<void> saveExamSession(Map<String, dynamic> session) async {
    await LocalStorageService.writeValue(
      StorageKeys.mockExamSessionState,
      jsonEncode(session),
    );
  }
}
