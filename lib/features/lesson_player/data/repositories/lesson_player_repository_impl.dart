import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/lesson_player/data/contracts/lesson_player_api_contract.dart';
import 'package:lexmastery_mobile/features/lesson_player/domain/entities/lesson_content.dart';
import 'package:lexmastery_mobile/features/lesson_player/domain/repositories/lesson_player_repository.dart';

class LessonPlayerRepositoryImpl implements LessonPlayerRepository {
  LessonPlayerRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final LessonContentApiContract _contentContract = LessonContentApiContract();

  @override
  Future<LessonContent> getLesson(String lessonId) async {
    final key = '${StorageKeys.lessonContentPrefix}$lessonId';
    final cached = LocalStorageService.readValue<String>(key);
    if (cached != null) {
      return LessonContent.fromJson(
          jsonDecode(cached) as Map<dynamic, dynamic>);
    }

    LessonContent content;
    try {
      final response = await _apiClient.get(
        _contentContract.path,
        queryParameters: _contentContract.toRequest(lessonId),
      );
      final parsed =
          _contentContract.parseResponse(response.data as Map<String, dynamic>);
      content = LessonContent.fromJson(parsed.payload);
    } catch (_) {
      content = LessonContent(
        lessonId: lessonId,
        title: 'Offer and Acceptance - Core Principles',
        paragraphs: const <String>[
          'A valid offer is a clear expression of willingness to contract.',
          'Acceptance must mirror the offer terms and be communicated effectively.',
          'Courts distinguish offers from invitations to treat by intention.',
        ],
      );
    }

    await LocalStorageService.writeValue(key, jsonEncode(content.toJson()));
    return content;
  }

  @override
  Future<LessonProgress> getProgress(String lessonId) async {
    final key = '${StorageKeys.lessonProgressPrefix}$lessonId';
    final cached = LocalStorageService.readValue<String>(key);
    if (cached != null) {
      return LessonProgress.fromJson(
          jsonDecode(cached) as Map<dynamic, dynamic>);
    }
    return LessonProgress(
      lessonId: lessonId,
      readParagraphs: 0,
      totalParagraphs: 0,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<LessonProgress> updateProgress({
    required String lessonId,
    required int readParagraphs,
    required int totalParagraphs,
  }) async {
    final progress = LessonProgress(
      lessonId: lessonId,
      readParagraphs: readParagraphs,
      totalParagraphs: totalParagraphs,
      updatedAt: DateTime.now(),
    );
    final key = '${StorageKeys.lessonProgressPrefix}$lessonId';
    await LocalStorageService.writeValue(key, jsonEncode(progress.toJson()));
    return progress;
  }
}
