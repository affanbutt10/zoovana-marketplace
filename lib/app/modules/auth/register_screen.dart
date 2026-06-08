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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().clearError();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AuthLayout(
      title: l10n.registerCreateAccount,
      subtitle: l10n.registerSubtitle,
      child: GetBuilder<AuthController>(
        builder: (controller) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthComponents.buildShopInput(
                context: context,
                controller: _nameController,
                label: l10n.registerName,
                hint: l10n.registerNameHint,
                icon: Icons.person_outline_rounded,
                delay: const Duration(milliseconds: 300),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.registerValidateName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AuthComponents.buildShopInput(
                context: context,
                controller: _emailController,
                label: l10n.registerEmail,
                hint: l10n.loginEmailHint,
                icon: Icons.mail_outline_rounded,
                delay: const Duration(milliseconds: 400),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.registerValidateEmail;
                  }
                  if (!GetUtils.isEmail(value)) {
                    return l10n.registerValidateEmailFormat;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AuthComponents.buildShopInput(
                context: context,
                controller: _phoneController,
                label: l10n.registerPhone,
                hint: l10n.registerPhoneHint,
                icon: Icons.phone_outlined,
                delay: const Duration(milliseconds: 500),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              AuthComponents.buildShopInput(
                context: context,
                controller: _passwordController,
                label: l10n.registerPassword,
                hint: l10n.loginPasswordHint,
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onPasswordToggle: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                delay: const Duration(milliseconds: 600),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.registerValidatePassword;
                  }
                  if (value.length < 6) {
                    return l10n.registerValidatePasswordLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              AuthComponents.buildShoppingButton(
                label: l10n.registerButton,
                isLoading: controller.isLoading,
                delay: const Duration(milliseconds: 700),
                onTap: () async {
                  debugPrint('[RegisterScreen] Create Account tapped');
                  if (_formKey.currentState?.validate() ?? false) {
                    debugPrint(
                      '[RegisterScreen] Form valid — registering email: ${_emailController.text.trim()}, name: ${_nameController.text.trim()}',
                    );
                    final success = await controller.register(
                      _emailController.text.trim(),
                      _passwordController.text,
                      _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                    );
                    debugPrint(
                      '[RegisterScreen] Register result: $success | error: ${controller.error}',
                    );
                    if (success) {
                      debugPrint(
                        '[RegisterScreen] Register success — redirecting to login',
                      );
                      Get.offNamed(AppRoutes.login);
                      Get.snackbar(
                        l10n.registerAccountCreated,
                        l10n.registerCheckEmail,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                      );
                    }
                  } else {
                    debugPrint('[RegisterScreen] Form validation failed');
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

  Widget _buildFooter(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.registerAlreadyHaveAccount,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        TextButton(
          onPressed: () => Get.offNamed(AppRoutes.login),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.brand,
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: Text(
            l10n.registerSignIn,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 800));
  }
}
