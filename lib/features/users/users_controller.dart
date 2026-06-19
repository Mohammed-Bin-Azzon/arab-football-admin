import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_model.dart';
import 'users_service.dart';

class UsersController extends GetxController {
  UsersController(this._service);

  final UsersService _service;

  final searchController = TextEditingController();

  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers({String? search}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getUsers(search: search);
      users.assignAll(response.data ?? []);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchUsers() async {
    final query = searchController.text.trim();
    await fetchUsers(search: query.isEmpty ? null : query);
  }

  Future<void> clearSearch() async {
    searchController.clear();
    searchText.value = '';
    await fetchUsers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}