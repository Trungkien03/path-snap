import 'package:flutter/cupertino.dart';

class BottomActionBar extends StatelessWidget {
  final bool hasActiveJourney;
  final VoidCallback onJourneysTap;
  final VoidCallback onStartTap;

  const BottomActionBar({
    required this.hasActiveJourney,
    required this.onJourneysTap,
    required this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Nút Journeys (luôn có)
          Expanded(
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 14),
              onPressed: onJourneysTap,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.collections, size: 20),
                  SizedBox(width: 8),
                  Text('Journeys'),
                ],
              ),
            ),
          ),

          // Nút Start (chỉ hiện khi chưa có journey active)
          if (!hasActiveJourney) ...[
            Container(width: 1, height: 28, color: CupertinoColors.systemGrey4),
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: onStartTap,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.play_fill, size: 20),
                    SizedBox(width: 8),
                    Text('Start'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
