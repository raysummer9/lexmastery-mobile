import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/settings/presentation/screens/settings_screen.dart';

class SettingsRoutes {
  const SettingsRoutes._();

  static const String settingsPath = '/settings';
  static const String settingsName = 'settings';

  static List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: settingsPath,
      name: settingsName,
      builder: (context, state) => const SettingsScreen(),
    ),
  ];
}
