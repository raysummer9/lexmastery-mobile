import 'package:lexmastery_mobile/features/flashcards/domain/entities/flashcard_item.dart';

abstract interface class FlashcardsRepository {
  Future<List<FlashcardItem>> getDeck();
  Future<void> saveDeck(List<FlashcardItem> deck);
}
