import 'package:lexmastery_mobile/features/quiz_engine/domain/entities/quiz_question.dart';

abstract interface class QuizEngineRepository {
  Future<List<QuizQuestion>> getQuestions();
  Future<void> saveSession(Map<String, dynamic> session);
  Future<Map<String, dynamic>?> restoreSession();
}
