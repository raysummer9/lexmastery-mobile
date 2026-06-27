import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/notifications/presentation/screens/notifications_screen.dart';

class NotificationsRoutes {
  const NotificationsRoutes._();

  static const String notificationsPath = '/notifications';
  static const String notificationsName = 'notifications';

  static List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: notificationsPath,
      name: notificationsName,
      builder: (context, state) => const NotificationsScreen(),
    ),
  ];
}
