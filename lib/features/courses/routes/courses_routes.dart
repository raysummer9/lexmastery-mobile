import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/courses/presentation/screens/courses_screen.dart';

class CoursesRoutes {
  const CoursesRoutes._();

  static const String coursesPath = '/courses';
  static const String coursesName = 'courses';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: coursesPath,
      name: coursesName,
      builder: (context, state) => const CoursesScreen(),
    ),
  ];
}
