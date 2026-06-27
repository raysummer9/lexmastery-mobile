import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/mock_exam/presentation/screens/mock_exam_screen.dart';

class MockExamRoutes {
  const MockExamRoutes._();

  static const String mockExamPath = '/mock-exam';
  static const String mockExamName = 'mockExam';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: mockExamPath,
      name: mockExamName,
      builder: (context, state) => const MockExamScreen(),
    ),
  ];
}
