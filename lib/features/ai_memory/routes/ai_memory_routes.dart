import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/ai_memory/presentation/screens/ai_memory_screen.dart';

class AiMemoryRoutes {
  const AiMemoryRoutes._();

  static const String memoryPath = '/ai-memory';
  static const String memoryName = 'aiMemory';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: memoryPath,
      name: memoryName,
      builder: (context, state) => const AiMemoryScreen(),
    ),
  ];
}
