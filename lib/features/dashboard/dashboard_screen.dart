import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_controller.dart';
import 'widgets/admin_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());

    return const AdminLayout();
  }
}