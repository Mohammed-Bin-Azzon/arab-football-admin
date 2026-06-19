import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import 'report_model.dart';
import 'reports_controller.dart';

class ReportsScreen extends GetView<ReportsController> {
  const ReportsScreen({super.key});

  static const double _reporterWidth = 170;
  static const double _targetTypeWidth = 150;
  static const double _targetIdWidth = 130;
  static const double _reasonWidth = 160;
  static const double _statusWidth = 170;
  static const double _actionsWidth = 210;

  static const double _tableWidth =
      _reporterWidth +
      _targetTypeWidth +
      _targetIdWidth +
      _reasonWidth +
      _statusWidth +
      _actionsWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              if (controller.filteredReports.isEmpty) {
                return const Center(child: Text('لا توجد بلاغات'));
              }

              return _buildTable();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إدارة البلاغات',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 6),
        Text(
          'مراجعة وإدارة البلاغات الواردة من المستخدمين',
          style: TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Obx(
      () => Row(
        children: [
          const Text('الحالة', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(width: 12),
          _filterChip('الكل', null),
          const SizedBox(width: 8),
          _filterChip('قيد الانتظار', 0),
          const SizedBox(width: 8),
          _filterChip('تمت المراجعة', 1),
          const SizedBox(width: 8),
          _filterChip('مرفوض', 2),
        ],
      ),
    );
  }

  Widget _filterChip(String title, int? value) {
    final selected = controller.selectedStatus.value == value;

    return InkWell(
      onTap: () => controller.changeStatus(value),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.red : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.red : AppColors.border,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Align(
      alignment: Alignment.topRight,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: _tableWidth,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.red.withValues(alpha: 0.06),
                  ),
                  dataRowMinHeight: 62,
                  dataRowMaxHeight: 72,
                  columnSpacing: 0,
                  horizontalMargin: 0,
                  columns: [
                    _column('منشئ البلاغ', _reporterWidth),
                    _column('نوع المحتوى', _targetTypeWidth),
                    _column('رقم المحتوى', _targetIdWidth),
                    _column('سبب البلاغ', _reasonWidth),
                    _column('حالة البلاغ', _statusWidth),
                    _column('الإجراءات', _actionsWidth),
                  ],
                  rows: controller.filteredReports.map((report) {
                    return DataRow(
                      cells: [
                        DataCell(_textCell(report.reporterUsername, _reporterWidth)),
                        DataCell(_textCell(report.targetTypeArabic, _targetTypeWidth)),
                        DataCell(_textCell(report.targetId.toString(), _targetIdWidth)),
                        DataCell(_textCell(report.reasonArabic, _reasonWidth)),
                        DataCell(_statusCell(report)),
                        DataCell(_actionsCell(report)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _column(String title, double width) {
    return DataColumn(
      label: SizedBox(
        width: width,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _textCell(String value, double width) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          value.isEmpty ? '-' : value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _statusCell(ReportModel report) {
    return SizedBox(
      width: _statusWidth,
      child: Center(child: _statusChip(report)),
    );
  }

  Widget _actionsCell(ReportModel report) {
    return SizedBox(
      width: _actionsWidth,
      child: Center(child: _actions(report)),
    );
  }

  Widget _statusChip(ReportModel report) {
    Color color;

    switch (report.status) {
      case 1:
        color = Colors.green;
        break;
      case 2:
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        report.statusArabic,
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _actions(ReportModel report) {
    if (report.status != 0) {
      return const Text('-');
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 38,
          child: ElevatedButton.icon(
            onPressed: () => controller.reviewReport(report.id),
            icon: const Icon(Icons.check, size: 17),
            label: const Text('مراجعة'),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 38,
          child: OutlinedButton.icon(
            onPressed: () => controller.rejectReport(report.id),
            icon: const Icon(Icons.close, size: 17),
            label: const Text('رفض'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}