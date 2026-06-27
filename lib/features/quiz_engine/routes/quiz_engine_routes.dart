import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/quiz_engine/presentation/screens/quiz_engine_screen.dart';

class QuizEngineRoutes {
  const QuizEngineRoutes._();

  static const String quizPath = '/quiz-engine';
  static const String quizName = 'quizEngine';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: quizPath,
      name: quizName,
      builder: (context, state) => const QuizEngineScreen(),
    ),
  ];
}
