import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/course_details/presentation/screens/course_details_screen.dart';

class CourseDetailsRoutes {
  const CourseDetailsRoutes._();

  static const String courseDetailsBasePath = '/course-details';
  static const String courseDetailsName = 'courseDetails';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: '$courseDetailsBasePath/:courseId',
      name: courseDetailsName,
      builder: (context, state) => CourseDetailsScreen(
        courseId: state.pathParameters['courseId']!,
      ),
    ),
  ];
}
