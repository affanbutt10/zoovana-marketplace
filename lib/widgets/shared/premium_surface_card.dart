import 'package:flutter/material.dart';

import '../../app/core/theme/app_colors.dart';
import '../../app/core/theme/app_radius.dart';
import '../../app/core/theme/app_shadows.dart';
import '../../app/core/theme/app_spacing.dart';

/// Shared elevated surface for cards and grouped content.
///
/// Centralizes background color, radius, border, shadow, and optional tap
/// behavior so product, cart, category, and form cards feel consistent.
class PremiumSurfaceCard extends StatelessWidget {
  const PremiumSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(AppRadius.xxLarge);
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: radius,
        border: Border.all(
          color: AppColors.borderSubtle.withValues(alpha: 0.6),
        ),
        boxShadow:
            theme.brightness == Brightness.dark ? null : AppShadows.elevation1,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.base),
        child: child,
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: card,
      ),
    );
  }
}
