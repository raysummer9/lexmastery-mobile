import 'package:lexmastery_mobile/features/ai_chat/domain/entities/ai_chat_thread.dart';

abstract interface class AiChatRepository {
  Future<List<AiChatThread>> loadThreads();
  Future<void> saveThreads(List<AiChatThread> threads);
  Stream<String> streamAssistantResponse({
    required String message,
    required String mode,
  });
}
