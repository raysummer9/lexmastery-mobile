import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/features/quiz_engine/data/repositories/quiz_engine_repository_impl.dart';
import 'package:lexmastery_mobile/features/quiz_engine/domain/repositories/quiz_engine_repository.dart';
import 'package:lexmastery_mobile/features/quiz_engine/presentation/state/quiz_engine_state.dart';

final quizEngineRepositoryProvider = Provider<QuizEngineRepository>(
  (ref) => QuizEngineRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final quizEngineControllerProvider =
    NotifierProvider<QuizEngineController, QuizEngineState>(
  QuizEngineController.new,
);

class QuizEngineController extends Notifier<QuizEngineState> {
  late final QuizEngineRepository _repository;
  Timer? _timer;

  @override
  QuizEngineState build() {
    _repository = ref.read(quizEngineRepositoryProvider);
    ref.onDispose(() => _timer?.cancel());
    return const QuizEngineState.initial();
  }

  Future<void> startQuiz({required bool timedMode}) async {
    state = state.copyWith(status: QuizEngineStatus.loading);
    final questions = await _repository.getQuestions();
    final restored = await _repository.restoreSession();
    final seconds = timedMode ? 300 : 0;
    state = state.copyWith(
      status: QuizEngineStatus.active,
      questions: questions,
      answers: (restored?['answers'] as Map?)?.cast<String, int>() ??
          const <String, int>{},
      currentIndex: restored?['currentIndex'] as int? ?? 0,
      secondsRemaining: restored?['secondsRemaining'] as int? ?? seconds,
    );
    if (timedMode) {
      _startTimer();
    }
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'quiz_start',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{'timedMode': timedMode},
          ),
        );
  }

  Future<void> answerCurrentQuestion(int optionIndex) async {
    final question = state.questions[state.currentIndex];
    final updatedAnswers = <String, int>{
      ...state.answers,
      question.id: optionIndex
    };
    final nextIndex =
        (state.currentIndex + 1).clamp(0, state.questions.length - 1);
    state = state.copyWith(answers: updatedAnswers, currentIndex: nextIndex);
    await _persistSession();
  }

  Future<void> submitQuiz() async {
    _timer?.cancel();
    state = state.copyWith(status: QuizEngineStatus.submitting);
    final score = _calculateScore();
    state = state.copyWith(
      status: QuizEngineStatus.completed,
      score: score,
      message: 'Quiz completed. Review explanations for reinforcement.',
    );
    await ref.read(syncControllerProvider.notifier).enqueue(
          SyncJob(
            id: 'quiz-result-${DateTime.now().microsecondsSinceEpoch}',
            entityType: 'quiz_result',
            payload: <String, dynamic>{
              'score': score,
              'total': state.questions.length,
              'answers': state.answers,
            },
            retryCount: 0,
            createdAt: DateTime.now(),
          ),
        );
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'quiz_complete',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{'score': score},
          ),
        );
  }

  Future<void> openReview() async {
    state = state.copyWith(status: QuizEngineStatus.reviewing);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining <= 1) {
        timer.cancel();
        submitQuiz();
        return;
      }
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      _persistSession();
    });
  }

  int _calculateScore() {
    var score = 0;
    for (final question in state.questions) {
      final answer = state.answers[question.id];
      if (answer == question.correctIndex) score += 1;
    }
    return score;
  }

  Future<void> _persistSession() async {
    await _repository.saveSession(<String, dynamic>{
      'answers': state.answers,
      'currentIndex': state.currentIndex,
      'secondsRemaining': state.secondsRemaining,
    });
  }
}
