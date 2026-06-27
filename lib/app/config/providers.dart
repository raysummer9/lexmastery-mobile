import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lexmastery_mobile/core/environment/app_environment.dart';
import 'package:lexmastery_mobile/core/network/api_client.dart';
import 'package:lexmastery_mobile/core/navigation/app_router.dart';

final environmentConfigProvider = Provider<EnvironmentConfig>(
  (ref) => const EnvironmentConfig(
    environment: AppEnvironment.development,
    apiBaseUrl: 'https://api.placeholder.lexmastery.ai',
  ),
);

final loggerProvider = Provider<Logger>(
  (ref) => Logger(
    level: Level.debug,
  ),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    environment: ref.watch(environmentConfigProvider),
    logger: ref.watch(loggerProvider),
  ),
);

final goRouterProvider = Provider<GoRouter>(
  (ref) => ref.watch(appRouterProvider),
);

class AppProviders {
  const AppProviders._();

  static Future<void> preload() async {
    // Reserved for preload logic (e.g., remote config bootstrap) in later phases.
  }
}
