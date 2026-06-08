import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/pet_ui_adapter.dart';
import '../../data/models/product.dart';
import '../../widgets/cached_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/shared/premium_surface_card.dart';

/// Refined Pet Adoption Card — Improved contrast, visual hierarchy, and depth
/// through strategic use of elevation, color layers, and spacing.
class AppProductCard extends StatefulWidget {
  const AppProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.ctaLabel = 'Get Started',
    this.isCompact = false,
    this.heroTag,
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final String ctaLabel;
  final bool isCompact;
  final String? heroTag;

  @override
  State<AppProductCard> createState() => _AppProductCardState();
}

class _AppProductCardState extends State<AppProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _ctrl, curve: AppMotion.emphasis));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final tags = PetUiAdapter.tags(p);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Determine fallback asset
    final imageWidget = CachedImage(
      url: p.imageUrl,
      fallbackAsset: 'assets/welcome_cat.png',
      fit: BoxFit.contain,
    );

    final cardRadius = BorderRadius.circular(AppRadius.xxLarge);

    return Semantics(
      button: widget.onTap != null,
      label: PetUiAdapter.petName(p, context),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnim.value, child: child);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: cardRadius,
            onTapDown: (_) => _ctrl.forward(),
            onTapUp: (_) => _ctrl.reverse(),
            onTapCancel: () => _ctrl.reverse(),
            onTap: widget.onTap == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    widget.onTap?.call();
                  },
            child: PremiumSurfaceCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: cardRadius,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Positioned.fill(
                            child: ColoredBox(color: AppColors.surfaceRaised),
                          ),
                          Positioned(
                            bottom: -AppSpacing.sm,
                            right: -AppSpacing.xs,
                            left: AppSpacing.xxxxl,
                            top: AppSpacing.xxl,
                            child: widget.heroTag != null
                                ? Hero(tag: widget.heroTag!, child: imageWidget)
                                : imageWidget,
                          ),
                          PositionedDirectional(
                            top: AppSpacing.xl,
                            start: AppSpacing.lg,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoSection(
                                  context,
                                  label: l10n.productDistanceLabel,
                                  value: PetUiAdapter.distance(p),
                                  icon: Icons.location_on_outlined,
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                Text(
                                  l10n.productTags,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.textMain.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...tags
                                    .take(3)
                                    .map(
                                      (tag) => Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.xLarge,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: AppColors.textMain,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ColoredBox(
                      color: AppColors.brandOrange,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    PetUiAdapter.petName(p, context),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.medium,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: 6,
                                    ),
                                    child: Semantics(
                                      label: PetUiAdapter.priceLabel(p),
                                      child: Text(
                                        PetUiAdapter.priceLabel(p),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              PetUiAdapter.subtitle(p),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.textMain.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMain.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textMain,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
