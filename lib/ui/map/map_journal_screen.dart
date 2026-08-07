// lib/ui/map/map_journey_screen.dart  (hoặc home_screen.dart tùy bạn đặt tên)

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_snap/ui/components/circle_icon_button.dart';
import 'package:path_snap/ui/journeys/journeys_screen.dart';
import 'package:path_snap/ui/map/camera_capture_screen.dart';
import 'package:path_snap/ui/map/view_models/map_journal_view_model.dart';
import 'package:path_snap/ui/map/widgets/bottom_action_bar.dart';
import 'package:path_snap/ui/map/widgets/user_location_marker.dart';
import 'package:path_snap/ui/settings/settings_screen.dart';
import 'package:permission_handler/permission_handler.dart';

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

          // ===== TOP BUTTONS =====
          _buildTopLeftJourneysButton(),
          _buildTopRightSettingsButton(),

          // ===== BOTTOM CONTROLS =====
          _buildBottomLeftButton(), // Đã tích hợp ListenableBuilder bên trong
          _buildBottomActionBar(),
          _buildBottomRightLocateButton(),
        ],
      ),
    );
  }

  Widget _buildTopLeftJourneysButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      child: CircleIconButton(
        icon: CupertinoIcons.list_bullet,
        onTap: _showJourneysSheet,
      ),
    );
  }

  Widget _buildTopRightSettingsButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      right: 16,
      child: CircleIconButton(icon: CupertinoIcons.gear, onTap: _showSettings),
    );
  }

  Widget _buildBottomRightLocateButton() {
    return Positioned(
      bottom: 40,
      right: 16,
      child: CircleIconButton(
        icon: CupertinoIcons.location_fill,
        onTap: () {
          if (_viewModel.currentPosition != null) {
            _mapController.move(_viewModel.currentPosition!, 15);
          } else {
            _viewModel.refreshLocation();
          }
        },
      ),
    );
  }

  Widget _buildBottomLeftButton() {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (!_viewModel.isJourneyStarted) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 40,
          left: 16,
          child: CircleIconButton(
            icon: CupertinoIcons.stop_fill,
            onTap: () {
              _viewModel.stopJourney();
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomActionBar() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 40,
      child: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return BottomActionBar(
            isJourneyStarted: _viewModel.isJourneyStarted,
            onStartTap: () {
              _viewModel.startJourney();
            },
            onSnapTap: () async {
              // 1. Kiểm tra trạng thái quyền Camera hiện tại
              var status = await Permission.camera.status;

              // 2. Nếu chưa từng xin hoặc bị từ chối lần đầu -> Xin quyền
              if (status.isDenied) {
                status = await Permission.camera.request();
              }

              // 3. Nếu người dùng chọn "Từ chối vĩnh viễn" (Permanently Denied)
              if (status.isPermanentlyDenied) {
                if (!context.mounted) return;
                _showPermissionDialog(context);
                return;
              }

              if (status.isGranted) {
                // Mở màn hình CameraCaptureScreen để chụp ảnh
                final capturedImage = await Navigator.push<XFile?>(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const CameraCaptureScreen(),
                  ),
                );

                if (!context.mounted) return;

                // 2. Xử lý ảnh đã chụp (nếu có)
                if (capturedImage != null) {
                  // TODO: Xử lý logic Path Snap:
                  // - Lấy vị trí GPS hiện tại từ _viewModel
                  // - Tạo một entity 'Snap' (ảnh + tọa độ + thời gian)
                  // - Hiển thị preview ảnh trên bản đồ hoặc lưu vào DB

                  debugPrint(
                    'Nhận được ảnh để xử lý Snap: ${capturedImage.path}',
                  );

                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Snap Captrued'),
                      content: Text('Image saved at: ${capturedImage.name}'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cần quyền truy cập Camera'),
        content: const Text(
          'Path Snap cần quyền Camera để chụp ảnh dọc hành trình. '
          'Vui lòng bật quyền này trong Cài đặt của thiết bị.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Mở Cài đặt'),
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Hàm của permission_handler mở thẳng Settings của App
            },
          ),
        ],
      ),
    );
  }
}
