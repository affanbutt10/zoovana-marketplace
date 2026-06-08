import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../routes/app_routes.dart';
import 'widgets/auth_layout.dart';
import 'widgets/auth_components.dart';
import '../../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GetBuilder<AuthController>(
      builder: (controller) {
        if (controller.resetEmailSent) {
          return AuthLayout(
            title: l10n?.forgotPasswordCheckEmailTitle ?? 'Check Your Email',
            subtitle: l10n?.forgotPasswordCheckEmailSubtitle(_emailController.text.trim()) ?? 'We\'ve sent a reset link to ${_emailController.text.trim()}.',
            showBackButton: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.successSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 44,
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n?.forgotPasswordSpamNote ?? 'Didn\'t receive it? Check your spam folder or try again in a few minutes.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                    fontSize: 14,
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                const SizedBox(height: AppSpacing.xl * 2),
                AuthComponents.buildShoppingButton(
                  label: l10n?.forgotPasswordBackToLogin ?? 'Back to Login',
                  isLoading: false,
                  delay: const Duration(milliseconds: 600),
                  onTap: () => Get.offNamed(AppRoutes.login),
                ),
              ],
            ),
          );
        }

        return AuthLayout(
          title: l10n?.forgotPasswordResetTitle ?? 'Reset Password',
          subtitle: l10n?.forgotPasswordSubtitle ?? 'Enter your email and we\'ll send you a link to reset your password.',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthComponents.buildShopInput(
                  context: context,
                  controller: _emailController,
                  label: l10n?.forgotPasswordEmail ?? 'Email Address',
                  hint: l10n?.forgotPasswordEmailHint ?? 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  delay: const Duration(milliseconds: 400),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return l10n?.forgotPasswordValidateEmail ?? 'Please enter your email';
                    if (!GetUtils.isEmail(value)) return l10n?.forgotPasswordValidateEmailFormat ?? 'Please enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                AuthComponents.buildShoppingButton(
                  label: l10n?.forgotPasswordSend ?? 'Send Reset Link',
                  isLoading: controller.isLoading,
                  delay: const Duration(milliseconds: 600),
                  onTap: () async {
                    debugPrint('[ForgotPasswordScreen] Send Reset Link tapped');
                    if (_formKey.currentState?.validate() ?? false) {
                      debugPrint('[ForgotPasswordScreen] Form valid — sending reset to: ${_emailController.text.trim()}');
                      await controller.forgotPassword(_emailController.text.trim());
                      debugPrint('[ForgotPasswordScreen] forgotPassword done | resetEmailSent: ${controller.resetEmailSent} | error: ${controller.error}');
                    } else {
                      debugPrint('[ForgotPasswordScreen] Form validation failed');
                    }
                  },
                ),
                if (controller.error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildError(controller.error!),
                ],
                const SizedBox(height: AppSpacing.xl),
                _buildFooter(l10n),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(String error) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ).animate().shake();
  }

  Widget _buildFooter(AppLocalizations? l10n) {
    return Center(
      child: TextButton.icon(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
        icon: const Icon(Icons.arrow_back_rounded, size: 16),
        label: Text(
          l10n?.forgotPasswordBackToLoginLink ?? 'Back to login',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 800));
  }
}
