import 'package:lexmastery_mobile/core/network/api_contract.dart';

class FlashcardsResponse {
  const FlashcardsResponse({required this.items});
  final List<Map<String, dynamic>> items;
}

class FlashcardsApiContract implements ApiContract<void, FlashcardsResponse> {
  @override
  String get method => 'GET';

  @override
  String get path => '/flashcards/decks';

  @override
  FlashcardsResponse parseResponse(Map<String, dynamic> json) {
    return FlashcardsResponse(
      items: (json['items'] as List<dynamic>)
          .map((dynamic e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toRequest(void request) => const <String, dynamic>{};
}
