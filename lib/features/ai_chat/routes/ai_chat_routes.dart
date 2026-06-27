import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/ai_chat/presentation/screens/ai_chat_screen.dart';

class AiChatRoutes {
  const AiChatRoutes._();

  static const String chatPath = '/ai-chat';
  static const String chatName = 'aiChat';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: chatPath,
      name: chatName,
      builder: (context, state) => const AiChatScreen(),
    ),
  ];
}
