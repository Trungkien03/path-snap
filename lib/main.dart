import 'package:flutter/cupertino.dart';
import 'package:path_snap/config/app_config.dart';
import 'package:path_snap/ui/journeys/journeys_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(
    appTitle: 'PathSnap',
    dbName: 'path_snap.db',
    environment: Environment.prod,
    showDebugBanner: false,
  );

  runApp(const PathSnapApp());
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
            switch (index) {
              case 0:
                return const JourneysScreen();
              case 1:
                return const CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text('Map Journal'),
                  ),
                  child: Center(child: Text('Map View')),
                );
              case 2:
                return const CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text('Settings'),
                  ),
                  child: Center(child: Text('Settings')),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
