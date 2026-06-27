import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/lesson_player/presentation/screens/lesson_player_screen.dart';

class LessonPlayerRoutes {
  const LessonPlayerRoutes._();

  static const String lessonBasePath = '/lesson';
  static const String lessonName = 'lessonPlayer';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: '$lessonBasePath/:lessonId',
      name: lessonName,
      builder: (context, state) => LessonPlayerScreen(
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
  ];
}
