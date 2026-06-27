import 'package:lexmastery_mobile/features/mock_exam/domain/entities/mock_exam_question.dart';

enum MockExamStatus {
  loading,
  ready,
  inProgress,
  submitted,
  reviewing,
  failure,
}

class MockExamState {
  const MockExamState({
    required this.status,
    required this.questions,
    required this.answers,
    required this.currentIndex,
    required this.secondsRemaining,
    required this.score,
    this.message,
  });

  const MockExamState.initial()
      : status = MockExamStatus.loading,
        questions = const <MockExamQuestion>[],
        answers = const <String, int>{},
        currentIndex = 0,
        secondsRemaining = 0,
        score = 0,
        message = null;

  final MockExamStatus status;
  final List<MockExamQuestion> questions;
  final Map<String, int> answers;
  final int currentIndex;
  final int secondsRemaining;
  final int score;
  final String? message;

  MockExamState copyWith({
    MockExamStatus? status,
    List<MockExamQuestion>? questions,
    Map<String, int>? answers,
    int? currentIndex,
    int? secondsRemaining,
    int? score,
    String? message,
  }) {
    return MockExamState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      score: score ?? this.score,
      message: message,
    );
  }
}
