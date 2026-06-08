import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

/// Animated full-page state view with illustration icons.
///
/// Fades and slides in on appearance for a polished feel.
class AppStateView extends StatelessWidget {
  const AppStateView.loading({
    super.key,
    this.message = 'Loading...',
    this.title = 'One moment',
  })  : icon = null,
        actionLabel = null,
        onAction = null,
        _tone = _AppStateTone.loading;

  const AppStateView.empty({
    super.key,
    required this.message,
    this.title = 'Nothing here yet',
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  }) : _tone = _AppStateTone.neutral;

  const AppStateView.error({
    super.key,
    required this.message,
    this.title = 'Something went wrong',
    this.icon = Icons.error_outline_rounded,
    this.actionLabel,
    this.onAction,
  }) : _tone = _AppStateTone.error;

  const AppStateView.offline({
    super.key,
    this.title = 'You are offline',
    this.message =
        'Check your connection and try again. Cached content will appear when available.',
    this.icon = Icons.wifi_off_rounded,
    this.actionLabel,
    this.onAction,
  }) : _tone = _AppStateTone.offline;

  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final _AppStateTone _tone;

  @override
  Widget build(BuildContext context) {
    final isLoading = icon == null;
    final toneColor = switch (_tone) {
      _AppStateTone.loading => AppColors.brand,
      _AppStateTone.error => AppColors.danger,
      _AppStateTone.offline => AppColors.warning,
      _AppStateTone.neutral => AppColors.textSecondary,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.xxLarge),
            border: Border.all(
              color: AppColors.borderSubtle.withValues(alpha: 0.5),
            ),
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: toneColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xLarge),
                ),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: toneColor,
                        ),
                      )
                    : Icon(
                        icon,
                        size: 36,
                        color: toneColor,
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: actionLabel!,
                    onPressed: onAction,
                    variant: _tone == _AppStateTone.error
                        ? AppButtonVariant.primary
                        : AppButtonVariant.secondary,
                  ),
                ),
              ],
            ],
          ),
        )
            .animate()
            .fadeIn(duration: AppMotion.medium, curve: AppMotion.emphasis)
            .slideY(
              begin: 0.05,
              end: 0,
              duration: AppMotion.medium,
              curve: AppMotion.emphasis,
            ),
      ),
    );
  }
}

enum _AppStateTone {
  loading,
  neutral,
  error,
  offline,
}
