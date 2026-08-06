import 'package:flutter/cupertino.dart';

import 'config/app_config.dart';
import 'main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(
    appTitle: 'PathSnap [STG]',
    dbName: 'path_snap_stg.db',
    environment: Environment.staging,
    showDebugBanner: true,
  );

  runApp(PathSnapApp());
}
