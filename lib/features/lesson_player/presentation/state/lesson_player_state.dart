import 'package:lexmastery_mobile/features/lesson_player/domain/entities/lesson_content.dart';

enum LessonPlayerStatus {
  loading,
  ready,
  syncingProgress,
  failure,
}

class LessonPlayerState {
  const LessonPlayerState({
    required this.status,
    this.lessonContent,
    this.lessonProgress,
    this.message,
  });

  const LessonPlayerState.initial()
      : status = LessonPlayerStatus.loading,
        lessonContent = null,
        lessonProgress = null,
        message = null;

  final LessonPlayerStatus status;
  final LessonContent? lessonContent;
  final LessonProgress? lessonProgress;
  final String? message;

  LessonPlayerState copyWith({
    LessonPlayerStatus? status,
    LessonContent? lessonContent,
    LessonProgress? lessonProgress,
    String? message,
  }) {
    return LessonPlayerState(
      status: status ?? this.status,
      lessonContent: lessonContent ?? this.lessonContent,
      lessonProgress: lessonProgress ?? this.lessonProgress,
      message: message,
    );
  }
}
