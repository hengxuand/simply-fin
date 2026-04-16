import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/auth/auth_shell.dart';
import 'sign_up_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return AuthShell(
      subtitle: 'Sign in to your account',
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthFieldLabel('Email'),
          const SizedBox(height: 8),
          TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            decoration: AppTheme.authInputDecoration(
              hint: 'you@example.com',
              icon: Icons.email_outlined,
            ),
          ),
          const SizedBox(height: 20),
          const AuthFieldLabel('Password'),
          const SizedBox(height: 8),
          Obx(
            () => TextField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.login(),
              decoration: AppTheme.authInputDecoration(
                hint: '••••••••',
                icon: Icons.lock_outline,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.authTextMuted,
                    size: 20,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
              ),
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => FilledButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withAlpha(128),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(color: AppColors.authTextMuted, fontSize: 14),
          ),
          GestureDetector(
            onTap: () => Get.to(() => const SignUpPage()),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
