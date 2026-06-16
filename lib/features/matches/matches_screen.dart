import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import 'create_match_dialog.dart';
import 'edit_match_dialog.dart';
import 'match_model.dart';
import 'matches_controller.dart';

class MatchesScreen extends GetView<MatchesController> {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              if (controller.matches.isEmpty) {
                return const Center(child: Text('لا توجد مباريات'));
              }

              return _buildTable();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إدارة المباريات',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 6),
            Text(
              'عرض وإدارة مباريات المنصة',
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: 170,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.dialog(const CreateMatchDialog());
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة مباراة'),
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.red.withValues(alpha: 0.06),
              ),
              dataRowMinHeight: 64,
              dataRowMaxHeight: 72,
              columnSpacing: 38,
              horizontalMargin: 24,
              columns: const [
                DataColumn(label: Text('الفريق الأول')),
                DataColumn(label: Text('الفريق الثاني')),
                DataColumn(label: Text('الدوري')),
                DataColumn(label: Text('التاريخ')),
                DataColumn(label: Text('الوقت')),
                DataColumn(label: Text('الحالة')),
                DataColumn(label: Text('التوقعات')),
                DataColumn(label: Text('تعديل')),
                DataColumn(label: Text('حذف')),
              ],
              rows: controller.matches.map((match) {
                return DataRow(
                  cells: [
                    DataCell(_teamCell(match.homeTeam)),
                    DataCell(_teamCell(match.awayTeam)),
                    DataCell(Text(match.league)),
                    DataCell(Text(match.matchDate)),
                    DataCell(Text(match.formattedTime)),
                    DataCell(_statusAction(match)),
                    DataCell(_predictionAction(match)),
                    DataCell(_editButton(match)),
                    DataCell(_deleteButton(match)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _teamCell(String name) {
    return SizedBox(
      width: 150,
      child: Text(
        name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _statusAction(MatchModel match) {
    return PopupMenuButton<String>(
      tooltip: 'تغيير الحالة',
      onSelected: (value) async {
        if (value == 'upcoming') {
          await controller.changeStatus(id: match.id, status: 0);
        } else if (value == 'live') {
          await controller.changeStatus(id: match.id, status: 1);
        } else if (value == 'finished') {
          await controller.changeStatus(id: match.id, status: 2);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'upcoming', child: Text('قادمة')),
        PopupMenuItem(value: 'live', child: Text('مباشرة')),
        PopupMenuItem(value: 'finished', child: Text('منتهية')),
      ],
      child: _chipButton(
        label: match.status,
        color: _statusColor(match.status),
        icon: Icons.keyboard_arrow_down,
      ),
    );
  }

  Widget _predictionAction(MatchModel match) {
    return PopupMenuButton<String>(
      tooltip: 'إدارة التوقعات',
      onSelected: (value) async {
        if (value == 'open') {
          await controller.openPredictions(match.id);
        } else if (value == 'close') {
          await controller.closePredictions(match.id);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'open', child: Text('فتح التوقعات')),
        PopupMenuItem(value: 'close', child: Text('إغلاق التوقعات')),
      ],
      child: _chipButton(
        label: match.predictionState,
        color: match.predictionState == 'مفتوحة' ? Colors.green : AppColors.red,
        icon: Icons.keyboard_arrow_down,
      ),
    );
  }

  Widget _editButton(MatchModel match) {
    return OutlinedButton.icon(
      onPressed: () {
        Get.dialog(EditMatchDialog(match: match));
      },
      icon: const Icon(Icons.edit_outlined, size: 17),
      label: const Text('تعديل'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.red,
        side: const BorderSide(color: AppColors.red),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _deleteButton(MatchModel match) {
    return IconButton(
      tooltip: 'حذف',
      onPressed: () {
        Get.defaultDialog(
          title: 'تأكيد الحذف',
          middleText: 'هل تريد حذف هذه المباراة؟',
          textConfirm: 'حذف',
          textCancel: 'إلغاء',
          confirmTextColor: Colors.white,
          buttonColor: AppColors.red,
          onConfirm: () async {
            Get.back();
            await controller.deleteMatch(match.id);
          },
        );
      },
      icon: const Icon(Icons.delete_outline),
      color: Colors.red,
    );
  }

  Widget _chipButton({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 16, color: color),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'قادمة':
        return Colors.orange;
      case 'مباشرة':
        return Colors.green;
      case 'منتهية':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}