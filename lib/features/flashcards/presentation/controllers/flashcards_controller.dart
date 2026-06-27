import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/config/providers.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/sync/sync_controller.dart';
import 'package:lexmastery_mobile/core/sync/sync_job.dart';
import 'package:lexmastery_mobile/features/flashcards/data/repositories/flashcards_repository_impl.dart';
import 'package:lexmastery_mobile/features/flashcards/domain/entities/flashcard_item.dart';
import 'package:lexmastery_mobile/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:lexmastery_mobile/features/flashcards/presentation/state/flashcards_state.dart';

final flashcardsRepositoryProvider = Provider<FlashcardsRepository>(
  (ref) => FlashcardsRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final flashcardsControllerProvider =
    NotifierProvider<FlashcardsController, FlashcardsState>(
  FlashcardsController.new,
);

class FlashcardsController extends Notifier<FlashcardsState> {
  late final FlashcardsRepository _repository;

  @override
  FlashcardsState build() {
    _repository = ref.read(flashcardsRepositoryProvider);
    return const FlashcardsState.initial();
  }

  Future<void> loadDeck() async {
    state = state.copyWith(status: FlashcardsStatus.loading);
    final deck = await _repository.getDeck();
    state = state.copyWith(status: FlashcardsStatus.reviewing, deck: deck);
  }

  Future<void> rateCurrentCard({
    required int quality,
    required int responseTimeMs,
  }) async {
    final card = state.currentCard;
    if (card == null) return;
    final updatedCard = _applySrs(
      card: card,
      quality: quality,
      responseTimeMs: responseTimeMs,
    );
    final updatedDeck = state.deck
        .map((FlashcardItem item) => item.id == card.id ? updatedCard : item)
        .toList();

    final isLast = state.currentIndex >= updatedDeck.length - 1;
    state = state.copyWith(
      deck: updatedDeck,
      currentIndex: isLast ? state.currentIndex : state.currentIndex + 1,
      status: isLast ? FlashcardsStatus.completed : FlashcardsStatus.answered,
    );

    await _repository.saveDeck(updatedDeck);
    await ref.read(syncControllerProvider.notifier).enqueue(
          SyncJob(
            id: 'flashcard-review-${DateTime.now().microsecondsSinceEpoch}',
            entityType: 'flashcard_review',
            payload: updatedCard.toJson(),
            retryCount: 0,
            createdAt: DateTime.now(),
          ),
        );
    await ref.read(analyticsControllerProvider.notifier).track(
          AnalyticsEvent(
            type: AnalyticsEventType.featureUsed,
            name: 'flashcard_answer',
            occurredAt: DateTime.now(),
            payload: <String, dynamic>{'quality': quality},
          ),
        );
  }

  FlashcardItem _applySrs({
    required FlashcardItem card,
    required int quality,
    required int responseTimeMs,
  }) {
    final boundedQuality = quality.clamp(0, 5);
    final speedModifier = responseTimeMs < 3000 ? 0.05 : -0.05;
    final nextEase =
        (card.easeFactor + (0.1 - (5 - boundedQuality) * 0.08) + speedModifier)
            .clamp(1.3, 2.8);
    final nextInterval = boundedQuality < 3
        ? 1
        : (card.intervalDays * nextEase).round().clamp(1, 60);
    return FlashcardItem(
      id: card.id,
      front: card.front,
      back: card.back,
      easeFactor: nextEase,
      intervalDays: nextInterval,
      nextReviewAt: DateTime.now().add(Duration(days: nextInterval)),
    );
  }
}
