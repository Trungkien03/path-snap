import 'package:flutter/cupertino.dart';

class UserLocationMarker extends StatefulWidget {
  const UserLocationMarker();

  @override
  State<UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<UserLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Vòng pulse ngoài (lan tỏa + mờ dần)
            Container(
              width: 40 + (value * 30),
              height: 40 + (value * 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue.withOpacity(
                  0.35 * (1 - value),
                ),
              ),
            ),

            // Vòng pulse thứ 2 (lệch phase một chút cho mượt)
            Container(
              width: 30 + (value * 20),
              height: 30 + (value * 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue.withOpacity(
                  0.25 * (1 - value),
                ),
              ),
            ),

            // Chấm xanh chính (giống Google Maps)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue,
                border: Border.all(color: CupertinoColors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
