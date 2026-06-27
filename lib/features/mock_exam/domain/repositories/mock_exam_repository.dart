import 'package:lexmastery_mobile/features/mock_exam/domain/entities/mock_exam_question.dart';

abstract interface class MockExamRepository {
  Future<List<MockExamQuestion>> getExamQuestions();
  Future<void> saveExamSession(Map<String, dynamic> session);
  Future<Map<String, dynamic>?> restoreExamSession();
}
