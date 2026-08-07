// lib/ui/map/widgets/bottom_action_bar.dart

import 'package:flutter/cupertino.dart';

class BottomActionBar extends StatelessWidget {
  final bool isJourneyStarted;
  final VoidCallback onStartTap;
  final VoidCallback onSnapTap;

  const BottomActionBar({
    super.key,
    required this.isJourneyStarted,
    required this.onStartTap,
    required this.onSnapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isJourneyStarted)
          _PillButton(
            icon: CupertinoIcons.play_fill,
            label: 'Start',
            onTap: onStartTap,
          )
        else
          _PillButton(
            icon: CupertinoIcons.camera_fill, // Icon chụp hình
            label: 'Path Snap',
            onTap: onSnapTap,
          ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground
              .resolveFrom(context)
              .withOpacity(0.72),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: CupertinoColors.systemGrey4
                .resolveFrom(context)
                .withOpacity(0.5),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: CupertinoColors.label.resolveFrom(context),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label.resolveFrom(context),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
