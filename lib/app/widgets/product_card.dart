import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/core/controllers/auth_controller.dart';
import '../../app/core/errors/app_error_mapper.dart';
import '../../app/core/theme/app_colors.dart';
import '../../app/core/theme/app_radius.dart';
import '../../app/core/theme/app_spacing.dart';
import '../../app/data/models/product.dart';
import '../../app/data/repositories/cart_repository.dart';
import '../../app/widgets/cached_image.dart';
import '../../app/widgets/product_badge.dart';
import '../shared/widgets/app_snackbar.dart';
import '../../../l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.isAuthenticated,
    this.onAddToCartAuthenticated,
    this.onAddToGuestCart,
  });

  final Product product;
  final bool? isAuthenticated;
  final Future<void> Function(String productId, int quantity)?
      onAddToCartAuthenticated;
  final Future<void> Function(String productId, int quantity)? onAddToGuestCart;

  bool _resolveIsAuthenticated() {
    if (isAuthenticated != null) {
      return isAuthenticated!;
    }
    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>().isAuthenticated;
    }
    return false;
  }

  Future<void> _handleAddToCart() async {
    if (product.isOutOfStock) {
      if (Get.context != null) {
        AppSnackbar.show(
          Get.context!,
          message: AppLocalizations.of(Get.context!)?.outOfStock ??
              'Out of Stock',
          type: SnackbarType.error,
        );
      }
      return;
    }

    final authenticated = _resolveIsAuthenticated();
    if (authenticated) {
      if (onAddToCartAuthenticated != null) {
        await onAddToCartAuthenticated!(product.id, 1);
        return;
      }
      if (Get.isRegistered<CartRepository>()) {
        final repo = Get.find<CartRepository>();
        try {
          await repo.addToCart(
            product.id,
            1,
            catalogId: product.catalogId,
            variantId: product.variantId,
          );
          if (Get.context != null) {
            AppSnackbar.show(
              Get.context!,
              message: AppLocalizations.of(Get.context!)?.productAddedToCart ??
                  'Added to cart',
            );
          }
        } catch (error) {
          if (Get.context != null) {
            AppSnackbar.show(
              Get.context!,
              message: AppErrorMapper.isOutOfStockError(error)
                  ? (AppLocalizations.of(Get.context!)?.outOfStock ??
                      'Out of Stock')
                  : AppErrorMapper.map(error).message,
              type: SnackbarType.error,
            );
          }
        }
      }
      return;
    }

    if (onAddToGuestCart != null) {
      await onAddToGuestCart!(product.id, 1);
      return;
    }
    if (Get.isRegistered<CartRepository>()) {
      await Get.find<CartRepository>().addToGuestCart(
        product.id,
        1,
        catalogId: product.catalogId,
        variantId: product.variantId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = product.stock == 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'product-image-${product.id}',
                child: CachedImage(
                  url: product.imageUrl,
                  width: double.infinity,
                  height: 140,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.medium),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: ProductBadge(product: product),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              0,
            ),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xs,
              0,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Text(
                  'SAR ${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: AppSpacing.xs),
                if (product.compareAtPrice != null)
                  Text(
                    'SAR ${product.compareAtPrice!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.muted,
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  color: isOutOfStock ? AppColors.muted : AppColors.primary,
                  onPressed: isOutOfStock ? null : _handleAddToCart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
