import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/profile/presentation/screens/profile_screen.dart';

class ProfileRoutes {
  const ProfileRoutes._();

  static const String profilePath = '/profile';
  static const String profileName = 'profile';

  static List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: profilePath,
      name: profileName,
      builder: (context, state) => const ProfileScreen(),
    ),
  ];
}
