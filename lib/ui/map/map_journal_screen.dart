// lib/ui/map/map_journey_screen.dart  (hoặc home_screen.dart tùy bạn đặt tên)

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_snap/ui/journeys/journeys_screen.dart';
import 'package:path_snap/ui/map/map_journal_view_model.dart';
import 'package:path_snap/ui/map/widgets/bottom_action_bar.dart';
import 'package:path_snap/ui/map/widgets/user_location_marker.dart';
import 'package:path_snap/ui/settings/settings_screen.dart';

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

  void _showSettings() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return const SettingsScreen();
      },
    );
  }

  void _showJourneysSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.3,
            maxChildSize: 1.0,
            snap: true,
            snapSizes: const [0.45, 1.0],
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: JourneysScreen(scrollController: scrollController),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // ===== MAP =====
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      _viewModel.currentPosition ??
                      const LatLng(10.8231, 106.6297),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.pathsnap.app',
                  ),
                  if (_viewModel.currentPosition != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _viewModel.currentPosition!,
                          width: 80,
                          height: 80,
                          child: const UserLocationMarker(),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),

          // ===== SETTINGS Button =====
          _buildTopRightSettingsButton(),

          // ===== BOTTOM BUTTON GROUP =====
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildTopRightSettingsButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      right: 16,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _showSettings,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            CupertinoIcons.gear,
            size: 22,
            color: CupertinoColors.label,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 32,
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return BottomActionBar(
            hasActiveJourney: _viewModel.hasActiveJourney,
            onJourneysTap: _showJourneysSheet,
            onStartTap: () {
              // TODO: start journey
            },
          );
        },
      ),
    );
  }
}
