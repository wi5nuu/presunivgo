enum AppEnvironment { dev, staging, prod }

class AppConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final String algoliaAppId;
  final String algoliaApiKey;

  AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.algoliaAppId,
    required this.algoliaApiKey,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized. Call AppConfig.initialize()');
    }
    return _instance!;
  }

  static void initialize({
    required AppEnvironment environment,
    String? apiBaseUrl,
    String? algoliaAppId,
    String? algoliaApiKey,
  }) {
    _instance = AppConfig(
      environment: environment,
      apiBaseUrl: apiBaseUrl ?? 'https://api.puconnect.dev',
      algoliaAppId: algoliaAppId ?? '',
      algoliaApiKey: algoliaApiKey ?? '',
    );
  }
}
