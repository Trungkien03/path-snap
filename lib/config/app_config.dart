enum Environment { dev, staging, prod }

class AppConfig {
  final String appTitle;
  final String dbName;
  final Environment environment;
  final bool showDebugBanner;

  static late AppConfig _instance;

  AppConfig._internal({
    required this.appTitle,
    required this.dbName,
    required this.environment,
    required this.showDebugBanner,
  });

  static void initialize({
    required String appTitle,
    required String dbName,
    required Environment environment,
    bool showDebugBanner = false,
  }) {
    _instance = AppConfig._internal(
      appTitle: appTitle,
      dbName: dbName,
      environment: environment,
      showDebugBanner: showDebugBanner,
    );
  }

  static AppConfig get instance => _instance;
}
