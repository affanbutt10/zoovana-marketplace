import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/core/theme/app_colors.dart';
import '../../app/core/theme/app_spacing.dart';
import '../../app/data/models/product.dart';
import '../../l10n/app_localizations.dart';

/// Priority: Out of Stock > Sale > Featured > New > none
enum BadgeType { outOfStock, sale, featured, newProduct, none }

class ProductBadge extends StatelessWidget {
  final Product product;

  const ProductBadge({super.key, required this.product});

  /// Resolves the highest-priority badge for [product].
  static BadgeType resolve(Product product) {
    if (product.isOutOfStock) return BadgeType.outOfStock;
    if (product.compareAtPrice != null) return BadgeType.sale;
    if (product.isFeatured) return BadgeType.featured;
    if (DateTime.now().difference(product.createdAt).inDays <= 7) {
      return BadgeType.newProduct;
    }
    return BadgeType.none;
  }

  @override
  Widget build(BuildContext context) {
    final type = resolve(product);
    if (type == BadgeType.none) return const SizedBox.shrink();

    return _BadgeChip(type: type);
  }
}

class _BadgeChip extends StatelessWidget {
  final BadgeType type;

  const _BadgeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case BadgeType.outOfStock:
        return _chip(label: l10n.outOfStock, color: Colors.grey, icon: null);
      case BadgeType.sale:
        return _chip(
          label: l10n.productBadgeSale,
          color: AppColors.accent,
          icon: SvgPicture.asset(
            'assests/sale.svg',
            width: 12,
            height: 12,
            placeholderBuilder: (_) => const SizedBox(width: 12, height: 12),
          ),
        );
      case BadgeType.featured:
        return _chip(
          label: l10n.productBadgeFeatured,
          color: AppColors.primary,
          icon: null,
        );
      case BadgeType.newProduct:
        return _chip(
          label: l10n.productBadgeNew,
          color: Colors.blue,
          icon: null,
        );
      case BadgeType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _chip({required String label, required Color color, Widget? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon, const SizedBox(width: 4)],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
