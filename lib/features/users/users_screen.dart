import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/loading_widget.dart';
import 'users_controller.dart';

class UsersScreen extends GetView<UsersController> {
  const UsersScreen({super.key});

  static const double _usernameWidth = 260;
  static const double _emailWidth = 360;
  static const double _followersWidth = 150;
  static const double _followingWidth = 150;

  static const double _tableWidth =
      _usernameWidth + _emailWidth + _followersWidth + _followingWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              if (controller.users.isEmpty) {
                return const Center(child: Text('لا توجد مستخدمين'));
              }

              return _buildUsersTable();
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
          'إدارة المستخدمين',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 6),
        Text(
          'عرض وإدارة مستخدمين المنصة',
          style: TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        SizedBox(
          width: 500,
          child: Obx(
            () => CustomTextField(
              controller: controller.searchController,
              hint: 'ابحث باسم المستخدم أو البريد الإلكتروني',
              icon: Icons.search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => controller.searchUsers(),
              onChanged: (_) {
                controller.searchText.value = controller.searchController.text;
              },
              suffixIcon: controller.searchText.value.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'مسح',
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: controller.clearSearch,
                    ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 130,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: controller.searchUsers,
            icon: const Icon(Icons.search),
            label: const Text('بحث'),
          ),
        ),
      ],
    );
  }

  Widget _buildUsersTable() {
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
                    _column('اسم المستخدم', _usernameWidth),
                    _column('البريد الإلكتروني', _emailWidth),
                    _column('المتابعون', _followersWidth),
                    _column('يتابع', _followingWidth),
                  ],
                  rows: controller.users.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(_usernameCell(user.username)),
                        DataCell(_emailCell(user.email)),
                        DataCell(_numberCell(user.followersCount, _followersWidth)),
                        DataCell(_numberCell(user.followingCount, _followingWidth)),
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

  Widget _usernameCell(String username) {
    return SizedBox(
      width: _usernameWidth,
      child: Center(
        child: Text(
          username.isEmpty ? '-' : username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _emailCell(String email) {
    return SizedBox(
      width: _emailWidth,
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            email.isEmpty ? '-' : email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _numberCell(int value, double width) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(value.toString()),
      ),
    );
  }
}