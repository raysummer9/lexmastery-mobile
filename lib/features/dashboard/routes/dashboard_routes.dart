import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/dashboard/presentation/screens/dashboard_screen.dart';

class DashboardRoutes {
  const DashboardRoutes._();

  static const String dashboardPath = '/dashboard';
  static const String dashboardName = 'dashboard';

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: dashboardPath,
      name: dashboardName,
      builder: (context, state) => const DashboardScreen(),
    ),
  ];
}
