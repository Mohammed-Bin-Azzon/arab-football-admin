import 'package:get/get.dart';

import 'dashboard_service.dart';
import 'dashboard_stats_model.dart';

class DashboardController extends GetxController {
  DashboardController(this._service);

  final DashboardService _service;

  final selectedIndex = 0.obs;

  final stats = Rxn<DashboardStatsModel>();
  final isLoadingStats = false.obs;
  final statsError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  void changePage(int index) {
    selectedIndex.value = index;

    if (index == 0) {
      fetchStats();
    }
  }

  Future<void> fetchStats() async {
    try {
      isLoadingStats.value = true;
      statsError.value = '';

      final response = await _service.getStats();
      stats.value = response.data;
    } catch (e) {
      statsError.value = e.toString();
    } finally {
      isLoadingStats.value = false;
    }
  }
}