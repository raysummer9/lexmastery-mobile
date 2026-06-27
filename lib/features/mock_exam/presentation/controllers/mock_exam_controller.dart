import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/features/mock_exam/data/repositories/mock_exam_repository_impl.dart';
import 'package:lexmastery_mobile/features/mock_exam/domain/repositories/mock_exam_repository.dart';
import 'package:lexmastery_mobile/features/mock_exam/presentation/state/mock_exam_state.dart';

final mockExamRepositoryProvider = Provider<MockExamRepository>(
  (ref) => MockExamRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final mockExamControllerProvider =
    NotifierProvider<MockExamController, MockExamState>(
  MockExamController.new,
);

class MockExamController extends Notifier<MockExamState> {
  late final MockExamRepository _repository;
  Timer? _timer;

  @override
  MockExamState build() {
    _repository = ref.read(mockExamRepositoryProvider);
    ref.onDispose(() => _timer?.cancel());
    return const MockExamState.initial();
  }

  Future<void> startExam() async {
    final restored = await _repository.restoreExamSession();
    final questions = await _repository.getExamQuestions();
    state = state.copyWith(
      status: MockExamStatus.inProgress,
      questions: questions,
      answers: (restored?['answers'] as Map?)?.cast<String, int>() ??
          const <String, int>{},
      currentIndex: restored?['currentIndex'] as int? ?? 0,
      secondsRemaining: restored?['secondsRemaining'] as int? ?? 1200,
    );
    _startTimer();
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'mock_exam_start',
            occurredAt: DateTime.now(),
          ),
        );
  }

  Future<void> answerCurrent(int answer) async {
    final q = state.questions[state.currentIndex];
    final updated = <String, int>{...state.answers, q.id: answer};
    final nextIndex =
        (state.currentIndex + 1).clamp(0, state.questions.length - 1);
    state = state.copyWith(answers: updated, currentIndex: nextIndex);
    await _persist();
  }

  Future<void> submitExam() async {
    _timer?.cancel();
    final score = _calculateScore();
    state = state.copyWith(
      status: MockExamStatus.submitted,
      score: score,
      message: 'Mock exam submitted.',
    );
    await ref.read(syncControllerProvider.notifier).enqueue(
          SyncJob(
            id: 'mock-exam-result-${DateTime.now().microsecondsSinceEpoch}',
            entityType: 'mock_exam_result',
            payload: <String, dynamic>{
              'score': score,
              'answers': state.answers
            },
            retryCount: 0,
            createdAt: DateTime.now(),
          ),
        );
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'mock_exam_complete',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{'score': score},
          ),
        );
  }

  Future<void> reviewExam() async {
    state = state.copyWith(status: MockExamStatus.reviewing);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining <= 1) {
        timer.cancel();
        submitExam();
        return;
      }
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      _persist();
    });
  }

  Future<void> _persist() async {
    await _repository.saveExamSession(<String, dynamic>{
      'answers': state.answers,
      'currentIndex': state.currentIndex,
      'secondsRemaining': state.secondsRemaining,
    });
  }

  int _calculateScore() {
    var score = 0;
    for (final q in state.questions) {
      if (state.answers[q.id] == q.correctIndex) score += 1;
    }
    return score;
  }
}
