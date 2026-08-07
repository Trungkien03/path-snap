// lib/ui/home/viewmodels/home_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_snap/domain/models/journey.dart';

class MapJourneyViewModel extends ChangeNotifier {
  List<Journey> _journeys = [];
  bool _isLoading = true;

  LatLng? _currentPosition;
  String? _locationError;

  bool get isLoading => _isLoading;
  List<Journey> get journeys => _journeys;
  LatLng? get currentPosition => _currentPosition;
  String? get locationError => _locationError;
  bool get hasActiveJourney => _journeys.any((j) => j.endDate == null);

  bool _isJourneyStarted = false;

  bool get isJourneyStarted => _isJourneyStarted;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    await getCurrentLocation();

    _isLoading = false;
    notifyListeners();
  }

  void startJourney() {
    _isJourneyStarted = true;
    notifyListeners();
  }

  void stopJourney() {
    _isJourneyStarted = false;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'Location services are disabled.';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationError = 'Bạn đã từ chối quyền vị trí';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError = 'Bạn đã từ chối quyền vị trí vĩnh viễn';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _currentPosition = LatLng(position.latitude, position.longitude);
      _locationError = null;
    } catch (e) {
      _locationError = 'Không thể lấy vị trí hiện tại: $e';
    }
  }

  Future<void> refreshLocation() async {
    await getCurrentLocation();
    notifyListeners();
  }
}
