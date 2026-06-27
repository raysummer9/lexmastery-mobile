import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/ai_tutor/presentation/screens/ai_tutor_screen.dart';

class AiTutorRoutes {
  const AiTutorRoutes._();

  static const String tutorPath = '/ai-tutor';
  static const String tutorName = 'aiTutor';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: tutorPath,
      name: tutorName,
      builder: (context, state) => const AiTutorScreen(),
    ),
  ];
}
