import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import 'post_model.dart';
import 'posts_controller.dart';

class PostsScreen extends GetView<PostsController> {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),

          Obx(() {
            final posts = controller.posts;

            return _buildStats(posts);
          }),

          const SizedBox(height: 24),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              if (controller.posts.isEmpty) {
                return const Center(child: Text('لا توجد منشورات'));
              }

              return _buildTable();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'إدارة المنشورات',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text(
            'عرض وإدارة منشورات المنصة',
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(List<PostModel> posts) {
    final totalPosts = posts.length;

    final totalLikes = posts.fold(0, (sum, post) => sum + post.likeCount);

    final totalComments = posts.fold(0, (sum, post) => sum + post.commentCount);

    final totalBookmarks = posts.fold(
      0,
      (sum, post) => sum + post.bookmarkCount,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _statItem(
            'إجمالي المنشورات',
            totalPosts.toString(),
            Icons.article_outlined,
            AppColors.red,
          ),
          _divider(),
          _statItem(
            'الإعجابات',
            totalLikes.toString(),
            Icons.favorite_outline,
            Colors.pink,
          ),
          _divider(),
          _statItem(
            'التعليقات',
            totalComments.toString(),
            Icons.chat_bubble_outline,
            Colors.green,
          ),
          _divider(),
          _statItem(
            'المحفوظات',
            totalBookmarks.toString(),
            Icons.bookmark_outline,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppColors.red.withValues(alpha: 0.05),
            ),
            horizontalMargin: 24,
            columnSpacing: 100,
            dataRowMinHeight: 72,
            dataRowMaxHeight: 82,
            columns: const [
              DataColumn(label: Text('المستخدم')),
              DataColumn(label: Text('رقم المنشور')),
              DataColumn(label: Text('الإعجابات')),
              DataColumn(label: Text('التعليقات')),
              DataColumn(label: Text('المحفوظات')),
              DataColumn(label: Text('التاريخ')),
            ],
            rows: controller.posts.map(_buildRow).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(PostModel post) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            post.fanDisplayName,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),

        DataCell(Text('#${post.id}')),

        DataCell(Text(post.likeCount.toString())),

        DataCell(Text(post.commentCount.toString())),

        DataCell(Text(post.bookmarkCount.toString())),

        DataCell(Text(post.createdAt.toString().split(' ').first)),
      ],
    );
  }

  Widget _statItem(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
