// lib/ui/home/home_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_snap/ui/map/map_journal_view_model.dart';

class MapJourneyScreen extends StatefulWidget {
  const MapJourneyScreen({super.key});

  @override
  State<MapJourneyScreen> createState() => _MapJourneyScreenState();
}

class _MapJourneyScreenState extends State<MapJourneyScreen> {
  late final MapJourneyViewModel _viewModel;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _viewModel = MapJourneyViewModel();
    _viewModel.load().then((_) {
      if (_viewModel.currentPosition != null) {
        _mapController.move(_viewModel.currentPosition!, 15);
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // ===== MAP =====
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(10.8231, 106.6297), // mặc định HCM
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.pathsnap.app',
              ),

              // Marker vị trí người dùng
              if (_viewModel.currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _viewModel.currentPosition!,
                      width: 40,
                      height: 40,
                      child: const _UserLocationMarker(),
                    ),
                  ],
                ),
            ],
          ),

          // ===== BOTTOM BUTTON GROUP =====
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return _BottomActionBar(
                  hasActiveJourney: _viewModel.hasActiveJourney,
                  onJourneysTap: () {
                    // Mở danh sách journeys (bottom sheet hoặc push)
                  },
                  onStartTap: () {
                    // Bắt đầu journey mới
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Marker đẹp cho vị trí người dùng
class _UserLocationMarker extends StatefulWidget {
  const _UserLocationMarker();

  @override
  State<_UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<_UserLocationMarker>
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

class _BottomActionBar extends StatelessWidget {
  final bool hasActiveJourney;
  final VoidCallback onJourneysTap;
  final VoidCallback onStartTap;

  const _BottomActionBar({
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
