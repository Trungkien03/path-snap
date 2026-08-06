import 'package:go_router/go_router.dart';
import 'package:path_snap/ui/journeys/journeys_screen.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const JourneysScreen()),
  ],
);
