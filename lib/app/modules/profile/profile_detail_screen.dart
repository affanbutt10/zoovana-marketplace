import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/user.dart';
import 'controllers/profile_controller.dart';
import '../../../l10n/app_localizations.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        final user = controller.user;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _ProfileDetailView(user: user, controller: controller);
      },
    );
  }
}

class _ProfileDetailView extends StatelessWidget {
  const _ProfileDetailView({required this.user, required this.controller});

  final User user;
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Hero App Bar ───
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.brand,
            leading: IconButton(
              tooltip: AppLocalizations.of(context)?.back ?? 'Back',
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.brand, Color(0xFF0056B3)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.xxl,
                      AppSpacing.xl,
                      AppSpacing.base,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppColors.brand,
                                size: 38,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: const Offset(0.8, 0.8)),
                        const SizedBox(height: AppSpacing.base),
                        Text(
                              user.name.isNotEmpty ? user.name : 'User',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 80.ms)
                            .slideX(begin: -0.1, end: 0),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontWeight: FontWeight.w500,
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 120.ms)
                            .slideX(begin: -0.1, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── Content ───
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ─── Account Info ───
                _DetailSection(
                  title:
                      AppLocalizations.of(context)?.profileAccountInfo ??
                      'Account Information',
                  delay: 0,
                  children: [
                    _DetailRow(
                      icon: Icons.person_outline_rounded,
                      label:
                          AppLocalizations.of(context)?.profileFullName ??
                          'Full Name',
                      value: user.name.isNotEmpty ? user.name : '—',
                    ),
                    _DetailRow(
                      icon: Icons.email_outlined,
                      label:
                          AppLocalizations.of(context)?.profileEmail ?? 'Email',
                      value: user.email.isNotEmpty ? user.email : '—',
                      trailing: user.isEmailVerified
                          ? _VerifiedBadge()
                          : _UnverifiedBadge(),
                    ),
                    _DetailRow(
                      icon: Icons.phone_outlined,
                      label:
                          AppLocalizations.of(context)?.profilePhone ?? 'Phone',
                      value: user.phone.isNotEmpty ? user.phone : '—',
                      trailing: user.isPhoneVerified
                          ? _VerifiedBadge()
                          : _UnverifiedBadge(),
                      isLast: user.username == null || user.username!.isEmpty,
                    ),
                    if (user.username != null && user.username!.isNotEmpty)
                      _DetailRow(
                        icon: Icons.alternate_email_rounded,
                        label:
                            AppLocalizations.of(context)?.profileUsername ??
                            'Username',
                        value: '@${user.username}',
                        isLast: true,
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.base),

                // ─── Account Status ───
                _DetailSection(
                  title:
                      AppLocalizations.of(context)?.profileAccountStatus ??
                      'Account Status',
                  delay: 60,
                  children: [
                    _DetailRow(
                      icon: Icons.verified_user_outlined,
                      label:
                          AppLocalizations.of(
                            context,
                          )?.profileAccountVerified ??
                          'Account Verified',
                      value: user.isVerified
                          ? (AppLocalizations.of(context)?.profileVerified ??
                                'Verified')
                          : (AppLocalizations.of(context)?.profilePending ??
                                'Pending'),
                      trailing: user.isVerified
                          ? _VerifiedBadge()
                          : _UnverifiedBadge(),
                    ),
                    _DetailRow(
                      icon: Icons.toggle_on_outlined,
                      label:
                          AppLocalizations.of(context)?.profileAccountActive ??
                          'Account Active',
                      value: user.isActive
                          ? (AppLocalizations.of(context)?.profileActive ??
                                'Active')
                          : (AppLocalizations.of(context)?.profileInactive ??
                                'Inactive'),
                      trailing: _StatusDot(active: user.isActive),
                    ),
                    _DetailRow(
                      icon: Icons.assignment_ind_outlined,
                      label:
                          AppLocalizations.of(context)?.profileRegistration ??
                          'Registration',
                      value: _formatStatus(user.registrationStatus),
                      isLast: true,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.base),

                // ─── Addresses ───
                _DetailSection(
                  title:
                      AppLocalizations.of(context)?.profileSavedAddresses ??
                      'Saved Addresses',
                  delay: 120,
                  children: controller.addresses.isEmpty
                      ? [
                          _EmptyRow(
                            icon: Icons.location_off_outlined,
                            message:
                                AppLocalizations.of(
                                  context,
                                )?.profileNoAddressesSaved ??
                                'No addresses saved yet.',
                          ),
                        ]
                      : controller.addresses
                            .asMap()
                            .entries
                            .map(
                              (e) => _AddressRow(
                                address: e.value,
                                isLast:
                                    e.key == controller.addresses.length - 1,
                              ),
                            )
                            .toList(),
                ),

                const SizedBox(height: AppSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

// ─── Section Container ───
class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.children,
    required this.delay,
  });

  final String title;
  final List<Widget> children;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xs,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(AppRadius.xxLarge),
                border: Border.all(
                  color: AppColors.borderSubtle.withValues(alpha: 0.6),
                ),
                boxShadow: AppShadows.elevation1,
              ),
              child: Column(children: children),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: AppMotion.medium, delay: delay.ms)
        .slideY(
          begin: 0.05,
          end: 0,
          duration: AppMotion.medium,
          delay: delay.ms,
          curve: AppMotion.emphasis,
        );
  }
}

// ─── Detail Row ───
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(icon, size: 18, color: AppColors.brand),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: AppSpacing.base + 36 + AppSpacing.base,
            endIndent: AppSpacing.base,
            color: AppColors.borderSubtle.withValues(alpha: 0.6),
          ),
      ],
    );
  }
}

// ─── Address Row ───
class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address, required this.isLast});

  final Address address;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: AppColors.brand,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            address.name.isNotEmpty ? address.name : 'Address',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ),
                        if (address.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandSoft,
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)?.profileDefault ??
                                  'Default',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.brand,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${address.street}, ${address.city}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (address.phone.isNotEmpty ||
                        address.postalCode.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          [
                            if (address.phone.isNotEmpty) address.phone,
                            if (address.postalCode.isNotEmpty)
                              address.postalCode,
                          ].join(' · '),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: AppSpacing.base + 36 + AppSpacing.base,
            endIndent: AppSpacing.base,
            color: AppColors.borderSubtle.withValues(alpha: 0.6),
          ),
      ],
    );
  }
}

// ─── Empty Row ───
class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textTertiary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─── Verified Badge ───
class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 3),
          Text(
            AppLocalizations.of(context)?.profileVerified ?? 'Verified',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Unverified Badge ───
class _UnverifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pending_rounded, size: 12, color: AppColors.warning),
          const SizedBox(width: 3),
          Text(
            AppLocalizations.of(context)?.profilePending ?? 'Pending',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status Dot ───
class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.success : AppColors.textTertiary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          active
              ? (AppLocalizations.of(context)?.profileActive ?? 'Active')
              : (AppLocalizations.of(context)?.profileInactive ?? 'Inactive'),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: active ? AppColors.success : AppColors.textTertiary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
