import 'package:get/get.dart';

import 'post_model.dart';
import 'posts_service.dart';

class PostsController extends GetxController {
  PostsController(this._service);

  final PostsService _service;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final posts = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      posts.assignAll(await _service.getPosts());
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}