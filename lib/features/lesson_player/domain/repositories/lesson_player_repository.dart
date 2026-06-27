import 'package:lexmastery_mobile/features/lesson_player/domain/entities/lesson_content.dart';

abstract interface class LessonPlayerRepository {
  Future<LessonContent> getLesson(String lessonId);
  Future<LessonProgress> getProgress(String lessonId);
  Future<LessonProgress> updateProgress({
    required String lessonId,
    required int readParagraphs,
    required int totalParagraphs,
  });
}
