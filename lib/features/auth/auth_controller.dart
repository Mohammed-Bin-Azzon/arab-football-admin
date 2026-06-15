import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../core/network/api_response.dart';
import '../../core/services/storage_service.dart';
import 'auth_service.dart';

class AuthController extends GetxController {
  AuthController(this._authService);

  final AuthService _authService;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال البريد الإلكتروني وكلمة المرور',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final auth = await _authService.login(
        email: email,
        password: password,
      );

      if (!auth.isAdmin) {
        throw const ApiException('هذا الحساب لا يملك صلاحية الدخول للوحة الإدارة.');
      }

      await StorageService.saveSession(
        token: auth.token,
        userId: auth.userId,
        username: auth.username,
        email: auth.email,
        role: auth.role,
      );

      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}