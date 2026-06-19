import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';
import 'dashboard_stats_model.dart';

class DashboardService {
  DashboardService(this._api);

  final ApiClient _api;

  Future<ApiResponse<DashboardStatsModel>> getStats() {
    return _api.get<DashboardStatsModel>(
      '${ApiConstants.dashboard}/stats',
      decoder: DashboardStatsModel.fromJson,
    );
  }
}