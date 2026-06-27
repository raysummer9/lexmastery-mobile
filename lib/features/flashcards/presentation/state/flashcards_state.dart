import 'package:lexmastery_mobile/features/flashcards/domain/entities/flashcard_item.dart';

enum FlashcardsStatus {
  loading,
  reviewing,
  answered,
  completed,
  failure,
}

class FlashcardsState {
  const FlashcardsState({
    required this.status,
    required this.deck,
    required this.currentIndex,
    this.message,
  });

  const FlashcardsState.initial()
      : status = FlashcardsStatus.loading,
        deck = const <FlashcardItem>[],
        currentIndex = 0,
        message = null;

  final FlashcardsStatus status;
  final List<FlashcardItem> deck;
  final int currentIndex;
  final String? message;

  FlashcardItem? get currentCard =>
      deck.isEmpty ? null : deck[currentIndex.clamp(0, deck.length - 1)];

  FlashcardsState copyWith({
    FlashcardsStatus? status,
    List<FlashcardItem>? deck,
    int? currentIndex,
    String? message,
  }) {
    return FlashcardsState(
      status: status ?? this.status,
      deck: deck ?? this.deck,
      currentIndex: currentIndex ?? this.currentIndex,
      message: message,
    );
  }
}
