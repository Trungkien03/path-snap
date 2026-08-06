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
      // Giả lập gọi database (sau này thay bằng repository)
      await Future.delayed(const Duration(milliseconds: 500));

      _journeys = []; // hiện tại để rỗng
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
