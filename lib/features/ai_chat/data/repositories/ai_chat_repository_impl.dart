import 'dart:async';
import 'dart:convert';

import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/storage/local_storage_service.dart';
import 'package:lexmastery_mobile/core/storage/storage_keys.dart';
import 'package:lexmastery_mobile/features/ai_chat/data/contracts/ai_chat_api_contract.dart';
import 'package:lexmastery_mobile/features/ai_chat/domain/entities/ai_chat_thread.dart';
import 'package:lexmastery_mobile/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  AiChatRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final AiChatApiContract _contract = AiChatApiContract();

  @override
  Future<List<AiChatThread>> loadThreads() async {
    final cached =
        LocalStorageService.readValue<String>(StorageKeys.aiChatThreads);
    if (cached == null) return const <AiChatThread>[];
    final decoded = jsonDecode(cached) as List<dynamic>;
    return decoded
        .map((dynamic thread) => AiChatThread.fromJson(thread as Map))
        .toList();
  }

  @override
  Future<void> saveThreads(List<AiChatThread> threads) async {
    await LocalStorageService.writeValue(
      StorageKeys.aiChatThreads,
      jsonEncode(threads.map((AiChatThread t) => t.toJson()).toList()),
    );
  }

  @override
  Stream<String> streamAssistantResponse({
    required String message,
    required String mode,
  }) async* {
    String responseText;
    try {
      final response = await _apiClient.post(
        _contract.path,
        data: _contract.toRequest(AiChatRequest(message: message, mode: mode)),
      );
      responseText =
          _contract.parseResponse(response.data as Map<String, dynamic>).text;
    } catch (_) {
      responseText =
          'In $mode mode, I would answer: "$message". This is a Phase 3 streaming scaffold.';
    }

    final tokens = responseText.split(' ');
    for (final token in tokens) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
      yield '$token ';
    }
  }
}
