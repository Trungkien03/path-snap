import 'package:flutter/cupertino.dart';
import 'config/app_config.dart';
import 'main.dart'; // import PathSnapApp

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(
    appTitle: 'PathSnap [STAGING]',
    dbName: 'path_snap_staging.db',
    environment: Environment.staging,
    showDebugBanner: true,
  );

  runApp(PathSnapApp());
}
