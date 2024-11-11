import 'package:flutter/material.dart';
import '../services/api_service.dart';

class IntensityProvider with ChangeNotifier {
  final CarbonIntensityService _service = CarbonIntensityService();

  int? currentIntensity;
  List<int>? dailyIntensity;
  bool isLoading = true;
  String? errorMessage;

  IntensityProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentIntensity = await _service.fetchCurrentIntensity();
      dailyIntensity = await _service.fetchDailyIntensity();
      if (currentIntensity == null || dailyIntensity == null) {
        errorMessage =
            'Failed to load data. Please check your network and try again.';
      }
    } catch (e) {
      errorMessage = 'Error: Unable to load data. Please check the connection.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
