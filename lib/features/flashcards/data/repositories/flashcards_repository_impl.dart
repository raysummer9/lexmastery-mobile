import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/flashcards/data/contracts/flashcards_api_contract.dart';
import 'package:lexmastery_mobile/features/flashcards/domain/entities/flashcard_item.dart';
import 'package:lexmastery_mobile/features/flashcards/domain/repositories/flashcards_repository.dart';

class FlashcardsRepositoryImpl implements FlashcardsRepository {
  FlashcardsRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;
  final FlashcardsApiContract _contract = FlashcardsApiContract();

  @override
  Future<List<FlashcardItem>> getDeck() async {
    final cached =
        LocalStorageService.readValue<String>(StorageKeys.flashcardDeckState);
    if (cached != null) {
      final decoded = jsonDecode(cached) as List<dynamic>;
      return decoded
          .map((dynamic item) => FlashcardItem.fromJson(item as Map))
          .toList();
    }
    try {
      final response = await _apiClient.get(_contract.path);
      final parsed =
          _contract.parseResponse(response.data as Map<String, dynamic>);
      return parsed.items
          .map((Map<String, dynamic> item) => FlashcardItem.fromJson(item))
          .toList();
    } catch (_) {
      return <FlashcardItem>[
        FlashcardItem(
          id: 'fc1',
          front: 'What is consideration?',
          back:
              'Consideration is value exchanged between parties, making a promise enforceable.',
          easeFactor: 2.5,
          intervalDays: 1,
          nextReviewAt: DateTime.now(),
        ),
      ];
    }
  }

  @override
  Future<void> saveDeck(List<FlashcardItem> deck) async {
    await LocalStorageService.writeValue(
      StorageKeys.flashcardDeckState,
      jsonEncode(deck.map((FlashcardItem item) => item.toJson()).toList()),
    );
  }
}
