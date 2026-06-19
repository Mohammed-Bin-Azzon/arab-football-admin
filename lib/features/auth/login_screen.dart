import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            const _LoginBackground(),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: 430,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: AppColors.red.withValues(alpha: 0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.red.withValues(alpha: 0.08),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 18),

                      const Text(
                        'لوحة تحكم مدرج',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'تسجيل دخول المشرف',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 20),
                      _dividerBall(),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: controller.emailController,
                        hint: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),

                      Obx(
                        () => CustomTextField(
                          controller: controller.passwordController,
                          hint: 'كلمة المرور',
                          icon: Icons.lock_outline,
                          obscureText: controller.isPasswordHidden.value,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => controller.login(),
                          suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Obx(
                        () => SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: CustomButton(
                            label: 'تسجيل الدخول',
                            isLoading: controller.isLoading.value,
                            onPressed: controller.login,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),
                      _bottomDecoration(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF2A2A),
            AppColors.red,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: const Icon(
        Icons.admin_panel_settings,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _dividerBall() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.red.withValues(alpha: 0.12),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.red,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.red.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }

  Widget _bottomDecoration() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.red.withValues(alpha: 0.10),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.red.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.sports_soccer,
            color: AppColors.red.withValues(alpha: 0.25),
            size: 26,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.red.withValues(alpha: 0.10),
          ),
        ),
      ],
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFF6F6),
                Color(0xFFFFFFFF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          left: -190,
          bottom: -155,
          child: _RedWave(
            width: 660,
            height: 290,
            opacity: 0.18,
          ),
        ),
        Positioned(
          right: -180,
          bottom: -125,
          child: _RedWave(
            width: 720,
            height: 270,
            opacity: 0.14,
          ),
        ),
        Positioned(
          left: 60,
          top: 200,
          child: _Dots(color: AppColors.red.withValues(alpha: 0.12)),
        ),
        Positioned(
          right: 90,
          bottom: 80,
          child: _Dots(color: AppColors.red.withValues(alpha: 0.10)),
        ),
      ],
    );
  }
}

class _RedWave extends StatelessWidget {
  const _RedWave({
    required this.width,
    required this.height,
    required this.opacity,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.18,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 78,
      child: GridView.count(
        crossAxisCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          16,
          (_) => Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}