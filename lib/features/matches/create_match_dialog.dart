import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'matches_controller.dart';

class CreateMatchDialog extends StatefulWidget {
  const CreateMatchDialog({super.key});

  @override
  State<CreateMatchDialog> createState() => _CreateMatchDialogState();
}

class _CreateMatchDialogState extends State<CreateMatchDialog> {
  final controller = Get.find<MatchesController>();

  final homeTeamController = TextEditingController();
  final awayTeamController = TextEditingController();
  final leagueController = TextEditingController();
  final dateController = TextEditingController();
  final hourController = TextEditingController();
  final minuteController = TextEditingController();

  String period = 'مساء';

  Uint8List? homeLogoBytes;
  String? homeLogoName;

  Uint8List? awayLogoBytes;
  String? awayLogoName;

  Future<void> _pickLogo({required bool isHome}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (!mounted || result == null || result.files.single.bytes == null) return;

    setState(() {
      if (isHome) {
        homeLogoBytes = result.files.single.bytes;
        homeLogoName = result.files.single.name;
      } else {
        awayLogoBytes = result.files.single.bytes;
        awayLogoName = result.files.single.name;
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (selected == null) return;

    dateController.text =
        '${selected.year.toString().padLeft(4, '0')}-'
        '${selected.month.toString().padLeft(2, '0')}-'
        '${selected.day.toString().padLeft(2, '0')}';
  }

  Future<void> submit() async {
    final homeTeam = homeTeamController.text.trim();
    final awayTeam = awayTeamController.text.trim();
    final league = leagueController.text.trim();
    final matchDate = dateController.text.trim();
    final hour = int.tryParse(hourController.text.trim());
    final minute = int.tryParse(minuteController.text.trim());

    if (homeTeam.isEmpty ||
        awayTeam.isEmpty ||
        league.isEmpty ||
        matchDate.isEmpty ||
        hour == null ||
        minute == null ||
        homeLogoBytes == null ||
        awayLogoBytes == null ||
        homeLogoName == null ||
        awayLogoName == null) {
      Get.snackbar(
        'تنبيه',
        'يرجى تعبئة جميع الحقول واختيار شعاري الفريقين',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (hour < 1 || hour > 12) {
      Get.snackbar('تنبيه', 'الساعة يجب أن تكون بين 1 و 12');
      return;
    }

    if (minute < 0 || minute > 59) {
      Get.snackbar('تنبيه', 'الدقيقة يجب أن تكون بين 0 و 59');
      return;
    }

    final success = await controller.createMatch(
      homeTeam: homeTeam,
      homeTeamLogoBytes: homeLogoBytes!,
      homeTeamLogoName: homeLogoName!,
      awayTeam: awayTeam,
      awayTeamLogoBytes: awayLogoBytes!,
      awayTeamLogoName: awayLogoName!,
      league: league,
      matchDate: matchDate,
      hour: hour,
      minute: minute,
      period: period,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    homeTeamController.dispose();
    awayTeamController.dispose();
    leagueController.dispose();
    dateController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'إضافة مباراة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: homeTeamController,
                      hint: 'اسم الفريق المضيف',
                      icon: Icons.shield_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: awayTeamController,
                      hint: 'اسم الفريق الضيف',
                      icon: Icons.shield_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _LogoPicker(
                      label: homeLogoName ?? 'اختر شعار الفريق المضيف',
                      hasFile: homeLogoBytes != null,
                      onTap: () => _pickLogo(isHome: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LogoPicker(
                      label: awayLogoName ?? 'اختر شعار الفريق الضيف',
                      hasFile: awayLogoBytes != null,
                      onTap: () => _pickLogo(isHome: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              CustomTextField(
                controller: leagueController,
                hint: 'اسم الدوري',
                icon: Icons.emoji_events_outlined,
              ),
              const SizedBox(height: 14),

              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: dateController,
                    hint: 'تاريخ المباراة',
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: hourController,
                      hint: 'الساعة',
                      icon: Icons.schedule,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: minuteController,
                      hint: 'الدقيقة',
                      icon: Icons.timer_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: period,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.wb_sunny_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'صباح', child: Text('صباح')),
                        DropdownMenuItem(value: 'مساء', child: Text('مساء')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => period = value);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Obx(
                () => CustomButton(
                  label: 'إنشاء المباراة',
                  icon: Icons.add,
                  isLoading: controller.isSaving.value,
                  onPressed: controller.isSaving.value ? null : submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoPicker extends StatelessWidget {
  const _LogoPicker({
    required this.label,
    required this.hasFile,
    required this.onTap,
  });

  final String label;
  final bool hasFile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        hasFile ? Icons.check_circle : Icons.upload_file,
        color: hasFile ? AppColors.success : AppColors.red,
      ),
      label: Text(label, overflow: TextOverflow.ellipsis),
    );
  }
}