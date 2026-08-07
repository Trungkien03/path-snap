// lib/ui/map/camera_capture_screen.dart

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_snap/ui/components/circle_icon_button.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  String? _lastCapturedPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Lắng nghe vòng đời ứng dụng
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // 1. Lấy danh sách camera có sẵn
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        debugPrint('Không tìm thấy camera nào.');
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Lỗi'),
            content: const Text('Không tìm thấy camera nào trên thiết bị.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        Navigator.pop(context);
        return;
      }

      // 2. Khởi tạo CameraController với camera đầu tiên (thường là camera sau)
      // ResolutionPreset.high cho chất lượng ảnh tốt
      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false, // Tắt audio nếu chỉ chụp ảnh
      );

      // 3. Khởi tạo controller
      await _controller!.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Lỗi khởi tạo camera: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose(); // Quan trọng: Phải giải phóng controller
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Xử lý khi ứng dụng bị suspend/resume (ví dụ: chuyển sang app khác)
    final CameraController? cameraController = _controller;

    // App bị pause -> hủy controller
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    }
    // App resume -> khởi tạo lại camera
    else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        _initializeCamera();
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (_controller!.value.isTakingPicture) {
      // Đang chụp, tránh bấm liên tục
      return;
    }

    try {
      // 1. Chụp ảnh. File tạm sẽ được lưu vào bộ nhớ tạm
      final XFile image = await _controller!.takePicture();

      if (!mounted) return;

      // 2. (Tùy chọn) Lưu ảnh vào thư mục vĩnh viễn của app
      // Đối với Path Snap, có thể bạn muốn lưu tạm rồi xử lý sau,
      // hoặc lưu vĩnh viễn luôn. Ở đây ta lấy path.

      // final directory = await getApplicationDocumentsDirectory();
      // final String fileName = 'snap_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // final String permanentPath = join(directory.path, fileName);
      // await image.saveTo(permanentPath); // Lưu sang chỗ mới

      debugPrint('Đã chụp ảnh tại: ${image.path}');

      // 3. Trả kết quả file ảnh về màn hình Map
      Navigator.pop(context, image);
    } catch (e) {
      debugPrint('Lỗi khi chụp ảnh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return const CupertinoPageScaffold(
        backgroundColor: CupertinoColors.black,
        child: Center(
          child: CupertinoActivityIndicator(color: CupertinoColors.white),
        ),
      );
    }

    // Lấy tỷ lệ màn hình để preview camera không bị méo
    var scale =
        _controller!.value.aspectRatio *
        MediaQuery.of(context).size.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          // ===== CAMERA PREVIEW (Toàn màn hình) =====
          ClipRect(
            child: Container(
              color: CupertinoColors.black,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: CameraPreview(_controller!),
              ),
            ),
          ),

          // ===== TOP TOOLBAR =====
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: CircleIconButton(
              icon: CupertinoIcons.back,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // ===== BOTTOM BAR =====
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CupertinoColors.white,
                        width: 4,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: CupertinoColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tap to Snap',
                  style: TextStyle(color: CupertinoColors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
