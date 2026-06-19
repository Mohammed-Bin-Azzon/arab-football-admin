import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../dashboard_controller.dart';
import 'stat_card.dart';

class DashboardHome extends GetView<DashboardController> {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = _getCrossAxisCount(width);
        final spacing = width < 600 ? 16.0 : 24.0;
        final padding = width < 500 ? 20.0 : 32.0;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'لوحة التحكم',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'نظرة عامة على المنصة',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: Obx(() {
                  if (controller.isLoadingStats.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.statsError.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.statsError.value,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final stats = controller.stats.value;

                  if (stats == null) {
                    return const Center(child: Text('لا توجد إحصائيات'));
                  }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 0.72,
                    children: [
                      StatCard(
                        title: 'المستخدمون',
                        value: stats.usersCount.toString(),
                        icon: Icons.people,
                        accentColor: AppColors.red,
                      ),
                      StatCard(
                        title: 'المباريات',
                        value: stats.matchesCount.toString(),
                        icon: Icons.sports_soccer,
                        accentColor: Colors.green,
                      ),
                      StatCard(
                        title: 'المنشورات',
                        value: stats.postsCount.toString(),
                        icon: Icons.article,
                        accentColor: Colors.deepPurple,
                      ),
                      StatCard(
                        title: 'البلاغات',
                        value: stats.reportsCount.toString(),
                        icon: Icons.report,
                        accentColor: Colors.deepOrange,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1000) return 4;
    if (width >= 760) return 3;
    if (width >= 500) return 2;
    return 1;
  }
}