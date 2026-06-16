import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'match_model.dart';
import 'matches_controller.dart';

class EditMatchDialog extends StatefulWidget {
  const EditMatchDialog({
    super.key,
    required this.match,
  });

  final MatchModel match;

  @override
  State<EditMatchDialog> createState() => _EditMatchDialogState();
}

class _EditMatchDialogState extends State<EditMatchDialog> {
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

  @override
  void initState() {
    super.initState();

    homeTeamController.text = widget.match.homeTeam;
    awayTeamController.text = widget.match.awayTeam;
    leagueController.text = widget.match.league;
    dateController.text = widget.match.matchDate;
    hourController.text = widget.match.hour.toString();
    minuteController.text = widget.match.minute.toString();

    period = widget.match.period.trim().isEmpty ? 'مساء' : widget.match.period;
  }

  Future<void> pickHomeLogo() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    setState(() {
      homeLogoBytes = result.files.single.bytes;
      homeLogoName = result.files.single.name;
    });
  }

  Future<void> pickAwayLogo() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    setState(() {
      awayLogoBytes = result.files.single.bytes;
      awayLogoName = result.files.single.name;
    });
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
        minute == null) {
      Get.snackbar(
        'تنبيه',
        'يرجى تعبئة جميع الحقول المطلوبة',
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

    final success = await controller.updateMatch(
      id: widget.match.id,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      league: league,
      matchDate: matchDate,
      hour: hour,
      minute: minute,
      period: period,
      homeTeamLogoBytes: homeLogoBytes,
      homeTeamLogoName: homeLogoName,
      awayTeamLogoBytes: awayLogoBytes,
      awayTeamLogoName: awayLogoName,
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
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تعديل مباراة',
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
                      label: homeLogoName ?? 'تغيير شعار الفريق المضيف',
                      hasFile: homeLogoBytes != null,
                      onTap: pickHomeLogo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LogoPicker(
                      label: awayLogoName ?? 'تغيير شعار الفريق الضيف',
                      hasFile: awayLogoBytes != null,
                      onTap: pickAwayLogo,
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

              CustomTextField(
                controller: dateController,
                hint: 'تاريخ المباراة مثال: 2026-06-20',
                icon: Icons.calendar_today_outlined,
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
                  label: 'حفظ التعديلات',
                  icon: Icons.save_outlined,
                  isLoading: controller.isSaving.value,
                  onPressed: submit,
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
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}