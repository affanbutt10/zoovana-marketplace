import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/controllers/locale_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../../widgets/shared/premium_page_header.dart';
import 'bindings/profile_binding.dart';
import 'controllers/profile_controller.dart';
import '../../../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileBinding.ensureInitialized();

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,

      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const _ProfileShimmer();
          }
          if (controller.error != null || controller.user == null) {
            return AppStateView.error(
              message:
                  controller.error ??
                  (AppLocalizations.of(context)?.profileCouldNotLoad ??
                      'Could not load profile.'),
              actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
              onAction: controller.loadProfile,
            ).animate().fadeIn(duration: AppMotion.medium);
          }

          final user = controller.user!;
          final locale = Get.find<LocaleController>().locale;
          final primaryAddress =
              controller.addresses.cast<dynamic>().firstWhereOrNull(
                (address) => address.isDefault,
              ) ??
              controller.addresses.firstOrNull;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 390;
              final cardPadding = isCompact ? AppSpacing.base : AppSpacing.xl;
              final sectionGap = isCompact
                  ? AppSpacing.lg
                  : AppSpacing.sectionGap;
              final heroRadius = isCompact
                  ? AppRadius.xLarge
                  : AppRadius.xxLarge;

              return ListView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom +
                      kBottomNavigationBarHeight +
                      AppSpacing.base,
                ),
                children: [
                  PremiumPageHeader(
                    title:
                        AppLocalizations.of(context)?.profileDetailTitle ??
                        'My Profile',
                    subtitle:
                        AppLocalizations.of(context)?.profilePreferences ??
                        'Preferences',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Hero Profile Card (tappable) ───
                        Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  Get.toNamed(AppRoutes.profileDetail);
                                },
                                borderRadius: BorderRadius.circular(heroRadius),
                                child: Container(
                                  padding: EdgeInsets.all(cardPadding),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.brand,
                                        Color(0xFF0056B3),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      heroRadius,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.brand.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: isCompact ? 26 : 34,
                                            backgroundColor:
                                                AppColors.surfaceRaised,
                                            child: Icon(
                                              Icons.person_rounded,
                                              color: AppColors.brand,
                                              size: isCompact ? 24 : 32,
                                            ),
                                          ),
                                          SizedBox(
                                            width: isCompact
                                                ? AppSpacing.sm
                                                : AppSpacing.base,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      (isCompact
                                                              ? Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .titleLarge
                                                              : Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .headlineSmall)
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Colors.white,
                                                          ),
                                                ),
                                                const SizedBox(
                                                  height: AppSpacing.xs,
                                                ),
                                                Text(
                                                  user.email,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.9,
                                                            ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                if (user.phone.isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: AppSpacing.xs,
                                                        ),
                                                    child: Text(
                                                      user.phone,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.78,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          // ─── Subtle "view profile" hint ───
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: AppSpacing.sm,
                                                      vertical: AppSpacing.xs,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppRadius.pill,
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.profileView,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.9,
                                                                ),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 11,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Icon(
                                                      Icons
                                                          .chevron_right_rounded,
                                                      size: 14,
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.base),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _MetricTile(
                                              value:
                                                  '${controller.recentOrders.length}',
                                              label:
                                                  AppLocalizations.of(
                                                    context,
                                                  )?.profileOrders ??
                                                  'Orders',
                                              compact: isCompact,
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          Expanded(
                                            child: _MetricTile(
                                              value:
                                                  '${controller.addresses.length}',
                                              label:
                                                  AppLocalizations.of(
                                                    context,
                                                  )?.profileAddresses ??
                                                  'Addresses',
                                              compact: isCompact,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: AppMotion.medium)
                            .slideY(
                              begin: 0.05,
                              end: 0,
                              duration: AppMotion.medium,
                              curve: AppMotion.emphasis,
                            ),
                        SizedBox(height: sectionGap),
                        _SectionTitle(
                          title:
                              AppLocalizations.of(
                                context,
                              )?.profileQuickAccess ??
                              'Quick Access',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.inventory_2_rounded,
                                    title:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileOrders ??
                                        'Orders',
                                    subtitle:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileOrdersTrack ??
                                        'Track',
                                    compact: isCompact,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      Get.toNamed(AppRoutes.orders);
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.receipt_long_rounded,
                                    title:
                                        AppLocalizations.of(
                                          context,
                                        )?.receiptsTitle ??
                                        'Receipts',
                                    subtitle:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileReceiptsInvoices ??
                                        'Invoices',
                                    compact: isCompact,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      Get.toNamed(AppRoutes.receipts);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.pets_rounded,
                                    title:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileMyPets ??
                                        'My Pets',
                                    subtitle:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileMyPetsSubtitle ??
                                        'Manage your pets',
                                    compact: isCompact,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      Get.toNamed(AppRoutes.myPets);
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.calendar_month_rounded,
                                    title:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileMyBookings ??
                                        'My Bookings',
                                    subtitle:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileMyBookingsSubtitle ??
                                        'View appointments',
                                    compact: isCompact,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      Get.toNamed(AppRoutes.myBookings);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 80.ms)
                        .slideY(
                          begin: 0.04,
                          end: 0,
                          duration: AppMotion.medium,
                          curve: AppMotion.emphasis,
                        ),
                        SizedBox(height: sectionGap),
                        _InfoPanel(
                              title:
                                  AppLocalizations.of(
                                    context,
                                  )?.profilePrimaryAddress ??
                                  'Primary Address',
                              compact: isCompact,
                              child: primaryAddress == null
                                  ? Text(
                                      AppLocalizations.of(
                                            context,
                                          )?.profileNoAddress ??
                                          'No address saved yet.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              color: AppColors.brand,
                                              size: isCompact ? 18 : 20,
                                            ),
                                            const SizedBox(
                                              width: AppSpacing.xs,
                                            ),
                                            Expanded(
                                              child: Text(
                                                primaryAddress.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Text(
                                          '${primaryAddress.street}, ${primaryAddress.city}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          '${primaryAddress.phone} · ${primaryAddress.postalCode}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.textTertiary,
                                              ),
                                        ),
                                      ],
                                    ),
                            )
                            .animate()
                            .fadeIn(delay: 140.ms)
                            .slideY(
                              begin: 0.04,
                              end: 0,
                              duration: AppMotion.medium,
                              curve: AppMotion.emphasis,
                            ),
                        const SizedBox(height: AppSpacing.base),
                        _InfoPanel(
                              title:
                                  AppLocalizations.of(
                                    context,
                                  )?.profilePreferences ??
                                  'Preferences',
                              compact: isCompact,
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: isCompact,
                                    title: Text(
                                      AppLocalizations.of(
                                            context,
                                          )?.profileLanguage ??
                                          'Language',
                                    ),
                                    subtitle: Text(
                                      AppLocalizations.of(
                                            context,
                                          )?.profileLanguageSubtitle ??
                                          'English / Arabic',
                                    ),
                                    trailing: SegmentedButton<String>(
                                      segments: [
                                        ButtonSegment(
                                          value: 'en',
                                          label: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.profileLanguageEnglishCode,
                                          ),
                                        ),
                                        ButtonSegment(
                                          value: 'ar',
                                          label: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.profileLanguageArabicCode,
                                          ),
                                        ),
                                      ],
                                      selected: {locale.languageCode},
                                      onSelectionChanged: (selection) {
                                        HapticFeedback.selectionClick();
                                        controller.setLocale(
                                          Locale(selection.first),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.base),
                                  AppButton(
                                    label:
                                        AppLocalizations.of(
                                          context,
                                        )?.profileLogout ??
                                        'Logout',
                                    variant: AppButtonVariant.secondary,
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      _confirmLogout(context, controller);
                                    },
                                    icon: const Icon(
                                      Icons.logout_rounded,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(
                              begin: 0.04,
                              end: 0,
                              duration: AppMotion.medium,
                              curve: AppMotion.emphasis,
                            ),
                        SizedBox(height: sectionGap),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    ProfileController controller,
  ) async {
    final l10n = AppLocalizations.of(context);
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n?.profileLogout ?? 'Logout'),
          content: Text(
            l10n?.profileLogoutConfirm ?? 'Are you sure you want to log out?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n?.cancel ?? 'Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n?.profileLogout ?? 'Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await controller.logout();
    }
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.value,
    required this.label,
    required this.compact,
  });

  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? AppSpacing.sm : AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        children: [
          Text(
            value,
            style:
                (compact
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.titleLarge)
                    ?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
              fontSize: compact ? 11 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.compact,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        child: Container(
          padding: EdgeInsets.all(compact ? AppSpacing.base : AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppRadius.xxLarge),
            border: Border.all(
              color: AppColors.brand.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 38 : 44,
                height: compact ? 38 : 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  icon,
                  color: AppColors.brand,
                  size: compact ? 20 : 24,
                ),
              ),
              SizedBox(height: compact ? AppSpacing.sm : AppSpacing.base),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    required this.child,
    required this.compact,
  });

  final String title;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.base : AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        border: Border.all(
          color: AppColors.brand.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: AppShadows.elevation1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

// ─── Profile Skeleton Shimmer ───
class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    return AppShimmer(
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          topPad + 60,
          AppSpacing.screenPadding,
          AppSpacing.screenPadding,
        ),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // ─── Hero card skeleton ───
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xxLarge),
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar circle
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: AppColors.skeletonBase,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBox(width: 140, height: 16),
                          const SizedBox(height: AppSpacing.sm),
                          _ShimmerBox(width: 200, height: 12),
                          const SizedBox(height: AppSpacing.xs),
                          _ShimmerBox(width: 100, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Metric tiles row
                Row(
                  children: [
                    Expanded(child: _ShimmerBox(height: 44)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _ShimmerBox(height: 44)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _ShimmerBox(height: 44)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sectionGap),

          // ─── Section label ───
          _ShimmerBox(width: 100, height: 14),
          const SizedBox(height: AppSpacing.sm),

          // ─── Quick access cards ───
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sectionGap),

          // ─── Info panel skeleton ───
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xxLarge),
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 120, height: 14),
                const SizedBox(height: AppSpacing.base),
                _ShimmerBox(height: 14),
                const SizedBox(height: AppSpacing.sm),
                _ShimmerBox(width: 200, height: 14),
                const SizedBox(height: AppSpacing.sm),
                _ShimmerBox(width: 160, height: 14),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.base),

          // ─── Preferences panel skeleton ───
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xxLarge),
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 100, height: 14),
                const SizedBox(height: AppSpacing.base),
                Row(
                  children: [
                    Expanded(child: _ShimmerBox(height: 14)),
                    const SizedBox(width: AppSpacing.base),
                    _ShimmerBox(width: 80, height: 32),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),
                _ShimmerBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single shimmer placeholder box.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({this.width, required this.height});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
    );
  }
}
