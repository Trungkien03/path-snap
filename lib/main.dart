import 'package:flutter/cupertino.dart';
import 'package:path_snap/config/app_config.dart';
import 'package:path_snap/ui/map/map_journal_screen.dart';

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
      home: const MapJourneyScreen(),
    );
  }
}
