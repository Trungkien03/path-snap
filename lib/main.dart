import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(
    appTitle: 'PathSnap',
    dbName: 'path_snap.db',
    environment: Environment.prod,
    showDebugBanner: false,
  );

  runApp(const ProviderScope(child: PathSnapApp()));
}

class PathSnapApp extends StatelessWidget {
  const PathSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return CupertinoApp(
      title: config.appTitle,
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.activeOrange,
        barBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Color(0xCCFFFFFF),
          darkColor: Color(0xCC1E1E1E),
        ),
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      ),
      home: const PathSnapMainHomeScreen(),
    );
  }
}

class PathSnapMainHomeScreen extends StatelessWidget {
  const PathSnapMainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.compass),
            label: 'Journeys',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map),
            label: 'Map View',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(
                  index == 0
                      ? 'My Journeys'
                      : index == 1
                      ? 'Map Journal'
                      : 'Settings',
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Text(
                    'PathSnap - Cupertino Tab $index',
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
