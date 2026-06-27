import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_controller.dart';
import 'package:lexmastery_mobile/core/analytics/analytics_event.dart';
import 'package:lexmastery_mobile/core/navigation/app_routes.dart';
import 'package:lexmastery_mobile/features/ai_chat/routes/ai_chat_routes.dart';
import 'package:lexmastery_mobile/features/ai_memory/routes/ai_memory_routes.dart';
import 'package:lexmastery_mobile/features/ai_tutor/routes/ai_tutor_routes.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/state/auth_state.dart';
import 'package:lexmastery_mobile/features/authentication/routes/authentication_routes.dart';
import 'package:lexmastery_mobile/features/course_details/routes/course_details_routes.dart';
import 'package:lexmastery_mobile/features/courses/routes/courses_routes.dart';
import 'package:lexmastery_mobile/features/dashboard/routes/dashboard_routes.dart';
import 'package:lexmastery_mobile/features/notifications/routes/notifications_routes.dart';
import 'package:lexmastery_mobile/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:lexmastery_mobile/features/lesson_player/routes/lesson_player_routes.dart';
import 'package:lexmastery_mobile/features/mock_exam/routes/mock_exam_routes.dart';
import 'package:lexmastery_mobile/features/prompt_engineering/routes/prompt_engineering_routes.dart';
import 'package:lexmastery_mobile/features/profile/routes/profile_routes.dart';
import 'package:lexmastery_mobile/features/quiz_engine/routes/quiz_engine_routes.dart';
import 'package:lexmastery_mobile/features/rag_engine/routes/rag_engine_routes.dart';
import 'package:lexmastery_mobile/features/settings/routes/settings_routes.dart';
import 'package:lexmastery_mobile/features/flashcards/routes/flashcards_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final analyticsController = ref.watch(analyticsControllerProvider.notifier);
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: AppRoutes.appShellPath,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.appShellPath,
        name: AppRoutes.appShellName,
        builder: (context, state) => const AppShellScreen(),
      ),
      ...AuthenticationRoutes.routes,
      ...DashboardRoutes.routes,
      ...CoursesRoutes.routes,
      ...CourseDetailsRoutes.routes,
      ...LessonPlayerRoutes.routes,
      ...AiTutorRoutes.routes,
      ...AiChatRoutes.routes,
      ...PromptEngineeringRoutes.routes,
      ...RagEngineRoutes.routes,
      ...AiMemoryRoutes.routes,
      ...QuizEngineRoutes.routes,
      ...MockExamRoutes.routes,
      ...FlashcardsRoutes.routes,
      ...ProfileRoutes.routes,
      ...SettingsRoutes.routes,
      ...NotificationsRoutes.routes,
    ],
    redirect: (context, state) {
      final isLoginRoute =
          state.matchedLocation == AuthenticationRoutes.loginPath;
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      if (!isAuthenticated && !isLoginRoute) {
        return AuthenticationRoutes.loginPath;
      }
      if (isAuthenticated && isLoginRoute) {
        return DashboardRoutes.dashboardPath;
      }
      return null;
    },
    observers: <NavigatorObserver>[
      _AnalyticsRouteObserver(analyticsController),
    ],
  );
});

class _AnalyticsRouteObserver extends NavigatorObserver {
  _AnalyticsRouteObserver(this._controller);

  final AnalyticsController _controller;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName =
        route.settings.name ?? route.settings.arguments?.toString();
    if (routeName != null) {
      _controller.track(
        AnalyticsEvent.screenViewed(
          screenName: routeName,
        ),
      );
    }
    super.didPush(route, previousRoute);
  }
}
