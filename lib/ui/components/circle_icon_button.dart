import 'package:flutter/cupertino.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground
              .resolveFrom(context)
              .withValues(alpha: 0.72),
          shape: BoxShape.circle,
          border: Border.all(
            color: CupertinoColors.systemGrey4
                .resolveFrom(context)
                .withValues(alpha: 0.5),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: CupertinoColors.label.resolveFrom(context),
        ),
      ),
    );
  }
}
