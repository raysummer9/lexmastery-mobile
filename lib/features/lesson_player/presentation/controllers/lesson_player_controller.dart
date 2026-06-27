import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/features/lesson_player/data/repositories/lesson_player_repository_impl.dart';
import 'package:lexmastery_mobile/features/lesson_player/domain/repositories/lesson_player_repository.dart';
import 'package:lexmastery_mobile/features/lesson_player/presentation/state/lesson_player_state.dart';

final lessonPlayerRepositoryProvider = Provider<LessonPlayerRepository>(
  (ref) => LessonPlayerRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final lessonPlayerControllerProvider =
    NotifierProvider<LessonPlayerController, LessonPlayerState>(
  LessonPlayerController.new,
);

class LessonPlayerController extends Notifier<LessonPlayerState> {
  late final LessonPlayerRepository _repository;

  @override
  LessonPlayerState build() {
    _repository = ref.read(lessonPlayerRepositoryProvider);
    return const LessonPlayerState.initial();
  }

  Future<void> loadLesson(String lessonId) async {
    state = state.copyWith(status: LessonPlayerStatus.loading);
    try {
      final lesson = await _repository.getLesson(lessonId);
      final progress = await _repository.getProgress(lessonId);
      state = state.copyWith(
        status: LessonPlayerStatus.ready,
        lessonContent: lesson,
        lessonProgress: progress,
      );
      await ref.read(analyticsControllerProvider.notifier).track(
            AnalyticsEvent(
              type: AnalyticsEventType.featureUsed,
              name: 'lesson_open',
              occurredAt: DateTime.now(),
              payload: <String, dynamic>{'lessonId': lessonId},
            ),
          );
    } catch (_) {
      state = state.copyWith(
        status: LessonPlayerStatus.failure,
        message: 'Unable to load lesson.',
      );
    }
  }

  Future<void> markParagraphRead(int paragraphIndex) async {
    final lesson = state.lessonContent;
    final progress = state.lessonProgress;
    if (lesson == null || progress == null) return;

    state = state.copyWith(status: LessonPlayerStatus.syncingProgress);
    final read = paragraphIndex + 1 > progress.readParagraphs
        ? paragraphIndex + 1
        : progress.readParagraphs;

    final updated = await _repository.updateProgress(
      lessonId: lesson.lessonId,
      readParagraphs: read,
      totalParagraphs: lesson.paragraphs.length,
    );

    await ref.read(syncControllerProvider.notifier).enqueue(
          SyncJob(
            id: 'lesson-progress-${DateTime.now().microsecondsSinceEpoch}',
            entityType: 'lesson_progress',
            payload: updated.toJson(),
            retryCount: 0,
            createdAt: DateTime.now(),
          ),
        );
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'lesson_progress_update',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{
              'lessonId': lesson.lessonId,
              'progressPercent': updated.progressPercent,
            },
          ),
        );

    state = state.copyWith(
      status: LessonPlayerStatus.ready,
      lessonProgress: updated,
    );
  }
}
