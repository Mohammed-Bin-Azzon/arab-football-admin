import 'package:get/get.dart';

import 'report_model.dart';
import 'reports_service.dart';

class ReportsController extends GetxController {
  ReportsController(this._service);

  final ReportsService _service;

  final reports = <ReportModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedStatus = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getReports();

      reports.assignAll(response.data ?? []);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reviewReport(int reportId) async {
    try {
      await _service.reviewReport(reportId);

      final report = reports.firstWhereOrNull(
        (x) => x.id == reportId,
      );

      if (report != null) {
        final index = reports.indexOf(report);

        reports[index] = ReportModel(
          id: report.id,
          reporterId: report.reporterId,
          reporterUsername: report.reporterUsername,
          adminId: report.adminId,
          adminUsername: report.adminUsername,
          targetType: report.targetType,
          targetTypeName: report.targetTypeName,
          targetId: report.targetId,
          reason: report.reason,
          reasonName: report.reasonName,
          status: 1,
          statusName: 'Reviewed',
          createdAt: report.createdAt,
        );
      }
    } catch (_) {}
  }

  Future<void> rejectReport(int reportId) async {
    try {
      await _service.rejectReport(reportId);

      final report = reports.firstWhereOrNull(
        (x) => x.id == reportId,
      );

      if (report != null) {
        final index = reports.indexOf(report);

        reports[index] = ReportModel(
          id: report.id,
          reporterId: report.reporterId,
          reporterUsername: report.reporterUsername,
          adminId: report.adminId,
          adminUsername: report.adminUsername,
          targetType: report.targetType,
          targetTypeName: report.targetTypeName,
          targetId: report.targetId,
          reason: report.reason,
          reasonName: report.reasonName,
          status: 2,
          statusName: 'Rejected',
          createdAt: report.createdAt,
        );
      }
    } catch (_) {}
  }

  List<ReportModel> get filteredReports {
    if (selectedStatus.value == null) {
      return reports;
    }

    return reports
        .where((r) => r.status == selectedStatus.value)
        .toList();
  }

  void changeStatus(int? value) {
    selectedStatus.value = value;
  }
}