import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../auth/auth_controller.dart';
import '../../posts/posts_screen.dart';
import '../dashboard_controller.dart';
import 'dashboard_home.dart';
import 'sidebar_item.dart';
import '../../matches/matches_screen.dart';
import '../../users/users_screen.dart';
import '../../reports/reports_screen.dart';

class AdminLayout extends GetView<DashboardController> {
  const AdminLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: Colors.white,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Obx(
              () => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          'مدرج',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 32),

                        SidebarItem(
                          title: 'الرئيسية',
                          icon: Icons.dashboard_outlined,
                          isSelected: controller.selectedIndex.value == 0,
                          onTap: () => controller.changePage(0),
                        ),
                        SidebarItem(
                          title: 'المباريات',
                          icon: Icons.sports_soccer,
                          isSelected: controller.selectedIndex.value == 1,
                          onTap: () => controller.changePage(1),
                        ),
                        SidebarItem(
                          title: 'المستخدمين',
                          icon: Icons.people_outline,
                          isSelected: controller.selectedIndex.value == 2,
                          onTap: () => controller.changePage(2),
                        ),
                        SidebarItem(
                          title: 'المنشورات',
                          icon: Icons.article_outlined,
                          isSelected: controller.selectedIndex.value == 3,
                          onTap: () => controller.changePage(3),
                        ),
                        SidebarItem(
                          title: 'البلاغات',
                          icon: Icons.report_outlined,
                          isSelected: controller.selectedIndex.value == 4,
                          onTap: () => controller.changePage(4),
                        ),

                        const Spacer(),

                        SidebarItem(
                          title: 'تسجيل الخروج',
                          icon: Icons.logout,
                          isSelected: false,
                          onTap: () {
                            Get.defaultDialog(
                              title: 'تسجيل الخروج',
                              middleText:
                                  'هل تريد تسجيل الخروج من لوحة التحكم؟',
                              textConfirm: 'خروج',
                              textCancel: 'إلغاء',
                              confirmTextColor: Colors.white,
                              buttonColor: AppColors.red,
                              onConfirm: () async {
                                Get.back();
                                await Get.find<AuthController>().logout();
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          return const DashboardHome();

        case 1:
          return const MatchesScreen();

        case 2:
          return const UsersScreen();

        case 3:
          return const PostsScreen();

        case 4:
          return const ReportsScreen();

        default:
          return const DashboardHome();
      }
    });
  }
}
