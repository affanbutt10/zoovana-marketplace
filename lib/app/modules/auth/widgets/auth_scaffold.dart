import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

/// Premium auth scaffold with a top hero gradient block and a sliding bottom sheet 
/// designed to elevate the auth screens to world-class standards.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: Stack(
        children: [
          // ─── Top Hero Background ───
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.brandGradient,
              ),
              child: Stack(
                children: [
                  // Abstract vibrant shapes
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: const Duration(seconds: 4)),
                  Positioned(
                    bottom: -100,
                    left: -100,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .move(begin: const Offset(0, 0), end: const Offset(20, -20), duration: const Duration(seconds: 5)),
                ],
              ),
            ),
          ),

          // ─── Back Button ───
          if (showBackButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.md,
              left: AppSpacing.md,
              child: IconButton.filledTonal(
                onPressed: Get.back,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                ),
              ),
            ),

          // ─── Bottom Sliding Sheet (Content) ───
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.75, // Cover most of screen
              decoration: BoxDecoration(
                color: AppColors.surfaceBase,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xxLarge),
                  topRight: Radius.circular(AppRadius.xxLarge),
                ),
                boxShadow: AppShadows.elevation3,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xxLarge),
                  topRight: Radius.circular(AppRadius.xxLarge),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      const _BrandMark(),
                      const SizedBox(height: AppSpacing.sectionGap),
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900, color: AppColors.navy, letterSpacing: -0.5),
                      )
                          .animate()
                          .fadeIn(duration: AppMotion.medium, delay: const Duration(milliseconds: 100))
                          .slideX(begin: -0.05, end: 0, duration: AppMotion.medium, delay: const Duration(milliseconds: 100)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.textSecondary, height: 1.4),
                      )
                          .animate()
                          .fadeIn(duration: AppMotion.medium, delay: const Duration(milliseconds: 200)),
                      
                      const SizedBox(height: AppSpacing.heroGap),
                      
                      // Child Form
                      child
                          .animate()
                          .fadeIn(duration: AppMotion.medium, delay: const Duration(milliseconds: 300))
                          .slideY(begin: 0.1, end: 0, duration: AppMotion.medium, delay: const Duration(milliseconds: 300)),
                      
                      if (footer != null) ...[
                        const SizedBox(height: AppSpacing.xl),
                        footer!.animate().fadeIn(duration: AppMotion.slow, delay: const Duration(milliseconds: 500)),
                      ],
                    ],
                  ),
                ),
              ),
            )
                .animate()
                .slideY(begin: 1, end: 0, duration: AppMotion.heroTransition, curve: AppMotion.spring)
                .fadeIn(duration: AppMotion.medium),
          ),
        ],
      ),
    );
  }
}

/// Trust strip with pills.
class AuthTrustStrip extends StatelessWidget {
  const AuthTrustStrip({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.center,
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: AppColors.brandLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: AppColors.brandDeep,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    item,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.brandSoft,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.pets_rounded,
            color: AppColors.brand,
            size: 32,
          ),
        ),
      )
          .animate()
          .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: AppMotion.medium, curve: AppMotion.spring),
    );
  }
}
