import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../../l10n/app_localizations.dart';

class FeatureDetailScreen extends StatelessWidget {
  const FeatureDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    String title = '';
    String description = '';
    String icon = '';
    Color themeColor = AppColors.brand;
    final l10n = AppLocalizations.of(context)!;

    switch (id) {
      case 'selection':
        title = l10n.homeFeatureSelectionDetailTitle;
        description = l10n.homeFeatureSelectionDetailDescription;
        icon = '🐾';
        themeColor = AppColors.brand;
        break;
      case 'quality':
        title = l10n.homeFeatureQualityProducts;
        description = l10n.homeFeatureQualityDetailDescription;
        icon = '🛍️';
        themeColor = AppColors.brandOrange;
        break;
      case 'delivery':
        title = l10n.homeFeatureFastDelivery;
        description = l10n.homeFeatureDeliveryDetailDescription;
        icon = '🚚';
        themeColor = Colors.blueAccent;
        break;
      default:
        title = l10n.homeFeatureDefaultTitle;
        description = l10n.homeFeatureDefaultDescription;
        icon = '✨';
        themeColor = AppColors.brand;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppTopBar(
        title: Text(title),
        leading: IconButton(
          tooltip: AppLocalizations.of(context)?.back ?? 'Back',
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        children: [
          // Background soft gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [themeColor.withValues(alpha: 0.1), Colors.white],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.xxxl,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxxl),
                // Hero Icon with pulsing animation
                Container(
                      padding: const EdgeInsets.all(AppSpacing.xxxl),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withValues(alpha: 0.1),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(icon, style: const TextStyle(fontSize: 90)),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                      duration: 2000.ms,
                      curve: Curves.easeInOutSine,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms),

                const SizedBox(height: AppSpacing.xxxl * 1.5),

                Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.textMain,
                            letterSpacing: -1,
                          ),
                    )
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideY(begin: 0.2, curve: AppMotion.emphasis),

                const SizedBox(height: AppSpacing.lg),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    l10n.homePremiumFeature.toUpperCase(),
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(),

                const SizedBox(height: AppSpacing.xl * 1.5),

                Text(
                      description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.8,
                        fontSize: 17,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideY(begin: 0.2, curve: AppMotion.emphasis),

                const SizedBox(height: AppSpacing.xxxl * 2),

                AppButton(
                      label: AppLocalizations.of(
                        context,
                      )!.homeExploreCategoriesCta,
                      onPressed: () => Get.offNamed('/categories'),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 0.2, curve: AppMotion.emphasis),

                const SizedBox(height: AppSpacing.xxl),

                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    AppLocalizations.of(context)!.back,
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
