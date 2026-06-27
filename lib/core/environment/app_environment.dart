enum AppEnvironment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  const EnvironmentConfig({
    required this.environment,
    required this.apiBaseUrl,
  });

  final AppEnvironment environment;
  final String apiBaseUrl;

  bool get isProduction => environment == AppEnvironment.production;
}
