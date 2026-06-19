import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';
import 'report_model.dart';

class ReportsService {
  ReportsService(this._api);

  final ApiClient _api;

  Future<ApiResponse<List<ReportModel>>> getReports() {
    return _api.get<List<ReportModel>>(
      '${ApiConstants.reports}/admin',
      decoder: (json) {
        final list = json is List ? json : [];
        return list.map(ReportModel.fromJson).toList();
      },
    );
  }

  Future<ApiResponse<bool>> reviewReport(int reportId) {
    return _api.patch<bool>(
      '${ApiConstants.reports}/$reportId/review',
      decoder: (_) => true,
    );
  }

  Future<ApiResponse<bool>> rejectReport(int reportId) {
    return _api.patch<bool>(
      '${ApiConstants.reports}/$reportId/reject',
      decoder: (_) => true,
    );
  }
}