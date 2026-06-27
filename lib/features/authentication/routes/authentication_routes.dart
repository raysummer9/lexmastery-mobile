import 'package:go_router/go_router.dart';
import 'package:lexmastery_mobile/features/authentication/presentation/screens/login_screen.dart';

class AuthenticationRoutes {
  const AuthenticationRoutes._();

  static const String loginPath = '/auth/login';
  static const String loginName = 'authLogin';

  static List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: loginPath,
      name: loginName,
      builder: (context, state) => const LoginScreen(),
    ),
  ];
}
