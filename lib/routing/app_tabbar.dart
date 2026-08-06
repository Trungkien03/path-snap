import 'package:flutter/cupertino.dart';
import 'package:path_snap/ui/journeys/journeys_screen.dart';
import 'package:path_snap/ui/map/map_journal_screen.dart';
import 'package:path_snap/ui/settings/settings_screen.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key});

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
                return const MapJournalScreen();
              case 2:
                return const SettingsScreen();
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
