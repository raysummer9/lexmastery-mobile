import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/rag_engine/presentation/screens/rag_engine_screen.dart';

class RagEngineRoutes {
  const RagEngineRoutes._();

  static const String ragPath = '/rag-engine';
  static const String ragName = 'ragEngine';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: ragPath,
      name: ragName,
      builder: (context, state) => const RagEngineScreen(),
    ),
  ];
}
