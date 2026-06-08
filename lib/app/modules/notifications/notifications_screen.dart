import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../../l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = [
      {
        'title': l10n.notificationOrderShippedTitle,
        'body': l10n.notificationOrderShippedBody,
        'time': l10n.notificationOrderShippedTime,
        'type': 'shipping',
      },
      {
        'title': l10n.notificationFlashSaleTitle,
        'body': l10n.notificationFlashSaleBody,
        'time': l10n.notificationFlashSaleTime,
        'type': 'promo',
      },
      {
        'title': l10n.notificationWelcomeTitle,
        'body': l10n.notificationWelcomeBody,
        'time': l10n.notificationWelcomeTime,
        'type': 'system',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppTopBar(title: Text(l10n.notificationsTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: notifications.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final note = notifications[index];
          final isPromo = note['type'] == 'promo';

          return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(AppRadius.xLarge),
                  boxShadow: AppShadows.elevation1,
                  border: Border.all(
                    color: AppColors.borderSubtle.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon block
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: isPromo
                            ? AppColors.warmGradient
                            : AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      child: Icon(
                        isPromo
                            ? Icons.local_offer_rounded
                            : Icons.mark_email_unread_rounded,
                        color: isPromo
                            ? AppColors.accentDeep
                            : AppColors.brandDeep,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['title']!,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            note['body']!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            note['time']!,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: AppMotion.medium, delay: (index * 80).ms)
              .slideX(
                begin: 0.05,
                end: 0,
                duration: AppMotion.medium,
                curve: AppMotion.spring,
              );
        },
      ),
    );
  }
}
