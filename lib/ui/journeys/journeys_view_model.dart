// lib/ui/journeys/viewmodels/journeys_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:path_snap/domain/models/journey.dart';

class JourneysViewModel extends ChangeNotifier {
  List<Journey> _journeys = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Journey> get journeys => _journeys;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _journeys.isEmpty;

  Future<void> loadJourneys() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final now = DateTime.now();

      _journeys = [
        Journey(
          id: '1',
          title: 'Đà Lạt 2025',
          description: 'Chuyến đi ngắm hoa và săn mây',
          startDate: now.subtract(const Duration(days: 45)),
          endDate: now.subtract(const Duration(days: 40)),
          coverPhotoPath: null,
          createdAt: now.subtract(const Duration(days: 50)),
          updatedAt: now.subtract(const Duration(days: 40)),
        ),
        Journey(
          id: '2',
          title: 'Phú Quốc - Biển xanh',
          description: 'Nghỉ dưỡng 4 ngày 3 đêm',
          startDate: now.subtract(const Duration(days: 20)),
          endDate: null, // đang active
          coverPhotoPath: null,
          createdAt: now.subtract(const Duration(days: 25)),
          updatedAt: now.subtract(const Duration(days: 20)),
        ),
        Journey(
          id: '3',
          title: 'Sapa - Fansipan',
          description: 'Chinh phục nóc nhà Đông Dương',
          startDate: now.subtract(const Duration(days: 90)),
          endDate: now.subtract(const Duration(days: 85)),
          coverPhotoPath: null,
          createdAt: now.subtract(const Duration(days: 95)),
          updatedAt: now.subtract(const Duration(days: 85)),
        ),
        Journey(
          id: '4',
          title: 'Hội An cổ kính',
          description: 'Dạo phố đèn lồng về đêm',
          startDate: now.subtract(const Duration(days: 10)),
          endDate: null,
          coverPhotoPath: null,
          createdAt: now.subtract(const Duration(days: 12)),
          updatedAt: now.subtract(const Duration(days: 10)),
        ),
        Journey(
          id: '5',
          title: 'Nha Trang - Lặn biển',
          description: 'Khám phá đại dương',
          startDate: now.subtract(const Duration(days: 60)),
          endDate: now.subtract(const Duration(days: 55)),
          coverPhotoPath: null,
          createdAt: now.subtract(const Duration(days: 65)),
          updatedAt: now.subtract(const Duration(days: 55)),
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
