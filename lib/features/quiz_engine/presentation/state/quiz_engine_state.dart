import 'package:lexmastery_mobile/features/quiz_engine/domain/entities/quiz_question.dart';

enum QuizEngineStatus {
  loading,
  active,
  submitting,
  completed,
  reviewing,
  failure,
}

class QuizEngineState {
  const QuizEngineState({
    required this.status,
    required this.questions,
    required this.answers,
    required this.currentIndex,
    required this.score,
    required this.secondsRemaining,
    this.message,
  });

  const QuizEngineState.initial()
      : status = QuizEngineStatus.loading,
        questions = const <QuizQuestion>[],
        answers = const <String, int>{},
        currentIndex = 0,
        score = 0,
        secondsRemaining = 0,
        message = null;

  final QuizEngineStatus status;
  final List<QuizQuestion> questions;
  final Map<String, int> answers;
  final int currentIndex;
  final int score;
  final int secondsRemaining;
  final String? message;

  QuizEngineState copyWith({
    QuizEngineStatus? status,
    List<QuizQuestion>? questions,
    Map<String, int>? answers,
    int? currentIndex,
    int? score,
    int? secondsRemaining,
    String? message,
  }) {
    return QuizEngineState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      message: message,
    );
  }
}
