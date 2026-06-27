import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/quiz_engine/data/contracts/quiz_engine_api_contract.dart';
import 'package:lexmastery_mobile/features/quiz_engine/domain/entities/quiz_question.dart';
import 'package:lexmastery_mobile/features/quiz_engine/domain/repositories/quiz_engine_repository.dart';

class QuizEngineRepositoryImpl implements QuizEngineRepository {
  QuizEngineRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  final QuizQuestionsApiContract _contract = QuizQuestionsApiContract();

  @override
  Future<List<QuizQuestion>> getQuestions() async {
    try {
      final response = await _apiClient.get(_contract.path);
      final parsed =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      return parsed.items
          .map((Map<String, dynamic> item) => QuizQuestion.fromJson(item))
          .toList();
    } catch (_) {
      return const <QuizQuestion>[
        QuizQuestion(
          id: 'q1',
          prompt: 'Which element is required for a valid contract?',
          options: <String>[
            'Public opinion',
            'Consideration',
            'Media coverage',
            'Court attendance',
          ],
          correctIndex: 1,
          explanation: 'Consideration is a core legal requirement.',
        ),
      ];
    }
  }

  @override
  Future<Map<String, dynamic>?> restoreSession() async {
    final raw =
        LocalStorageService.readValue<String>(StorageKeys.quizSessionState);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<void> saveSession(Map<String, dynamic> session) async {
    await LocalStorageService.writeValue(
      StorageKeys.quizSessionState,
      jsonEncode(session),
    );
  }
}
