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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Clear any error left over from a previous auth screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthLayout(
      title: l10n?.loginWelcome ?? 'Welcome Back, Pet Parent!',
      subtitle:
          l10n?.loginSubtitle ??
          'Sign in to access your cart, orders, and exclusive member deals',
      child: GetBuilder<AuthController>(
        builder: (controller) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthComponents.buildShopInput(
                context: context,
                controller: _emailController,
                label: l10n?.loginEmail ?? 'Email',
                hint: l10n?.loginEmailHint ?? 'you@example.com',
                icon: Icons.email_outlined,
                delay: const Duration(milliseconds: 400),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                  if (controller.error != null) controller.clearError();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n?.loginValidateEmail ??
                        'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return l10n?.loginValidateEmailFormat ??
                        'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AuthComponents.buildShopInput(
                context: context,
                controller: _passwordController,
                label: l10n?.loginPassword ?? 'Password',
                hint: l10n?.loginPasswordHint ?? '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onPasswordToggle: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                delay: const Duration(milliseconds: 500),
                onChanged: (_) {
                  if (controller.error != null) controller.clearError();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n?.loginValidatePassword ??
                        'Please enter your password';
                  }
                  if (value.length < 6) {
                    return l10n?.loginValidatePasswordLength ??
                        'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.brand,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                  ),
                  child: Text(
                    l10n?.loginForgotPassword ?? 'Forgot password?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
              const SizedBox(height: AppSpacing.sm),
              AuthComponents.buildShoppingButton(
                label: l10n?.loginButton ?? 'Sign In',
                isLoading: controller.isLoading,
                delay: const Duration(milliseconds: 700),
                onTap: () async {
                  debugPrint('[LoginScreen] Sign In tapped');
                  if (_formKey.currentState?.validate() ?? false) {
                    debugPrint(
                      '[LoginScreen] Form valid — calling login with email: ${_emailController.text.trim()}',
                    );
                    final success = await controller.login(
                      _emailController.text.trim(),
                      _passwordController.text,
                    );
                    debugPrint(
                      '[LoginScreen] Login result: $success | error: ${controller.error}',
                    );
                    if (success) {
                      debugPrint(
                        '[LoginScreen] Login success — navigating to home',
                      );
                      Get.offAllNamed(AppRoutes.home);
                    }
                  } else {
                    debugPrint('[LoginScreen] Form validation failed');
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildDivider(),
              const SizedBox(height: AppSpacing.md),
              _buildSocialLoginRow(controller),
              if (controller.error != null) ...[
                const SizedBox(height: AppSpacing.md),
                _buildError(controller.error!),
              ],
              const SizedBox(height: AppSpacing.lg),
              _buildJoinRow(l10n),
              const SizedBox(height: AppSpacing.md),
              _buildTrustBadges(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            'or',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 760));
  }

  Widget _buildSocialLoginRow(AuthController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIconButton(
          // Use g_mobiledata_rounded or a custom google SVG if you prefer
          icon: Icons.g_mobiledata_rounded,
          isLoading: controller.isLoading,
          onTap: () async {
            debugPrint('[LoginScreen] Continue with Google tapped');
            final success = await controller.loginWithGoogle();
            debugPrint(
              '[LoginScreen] Google login result: $success | error: ${controller.error}',
            );
            if (!success) return;

            final profileCompleted =
                controller.lastSocialLoginProfileCompleted ?? true;
            if (profileCompleted) {
              Get.offAllNamed(AppRoutes.home);
            } else {
              Get.offAllNamed(AppRoutes.profileDetail);
            }
          },
        ),
        if (GetPlatform.isIOS) ...[
          const SizedBox(width: AppSpacing.md),
          _buildSocialIconButton(
            icon: Icons.apple,
            isLoading: controller.isLoading,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Apple sign-in coming soon!')),
              );
            },
          ),
        ],
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 800));
  }

  Widget _buildSocialIconButton({
    required IconData icon,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        onPressed: isLoading ? null : onTap,
        icon: Icon(icon, size: 36, color: AppColors.textPrimary),
      ),
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

  Widget _buildJoinRow(AppLocalizations? l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n?.loginNewToZoovana ?? 'New to Zoovana?',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        TextButton(
          onPressed: () => Get.offNamed(AppRoutes.register),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.brand,
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: Text(
            l10n?.loginCreateAccount ?? 'Create Account',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 800));
  }

  Widget _buildTrustBadges(AppLocalizations? l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBadge(
          Icons.local_shipping_outlined,
          l10n?.loginFreeShipping ?? 'Free Shipping',
        ),
        _buildDot(),
        _buildBadge(
          Icons.verified_outlined,
          l10n?.loginVetApproved ?? 'Vet Approved',
        ),
        _buildDot(),
        _buildBadge(
          Icons.replay_outlined,
          l10n?.loginEasyReturns ?? 'Easy Returns',
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 900));
  }

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.brand),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '·',
        style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
      ),
    );
  }
}
