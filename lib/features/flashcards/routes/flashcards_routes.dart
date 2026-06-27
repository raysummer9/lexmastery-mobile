import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/flashcards/presentation/screens/flashcards_screen.dart';

class FlashcardsRoutes {
  const FlashcardsRoutes._();

  static const String flashcardsPath = '/flashcards';
  static const String flashcardsName = 'flashcards';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: flashcardsPath,
      name: flashcardsName,
      builder: (context, state) => const FlashcardsScreen(),
    ),
  ];
}
