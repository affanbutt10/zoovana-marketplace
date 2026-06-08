import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/cart.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_input.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/quantity_stepper.dart';
import '../../../widgets/shared/premium_page_header.dart';
import '../../../widgets/shared/premium_surface_card.dart';
import '../../../widgets/shared/sticky_action_bar.dart';
import 'bindings/cart_binding.dart';
import 'controllers/cart_controller.dart';
import '../../../l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    CartBinding.ensureInitialized();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        final state = controller.state;
        final cart = state.cart;

        return Scaffold(
          backgroundColor: AppColors.surfaceBase,
          bottomNavigationBar: cart == null || cart.items.isEmpty
              ? null
              : _CartSummaryBar(cart: cart, controller: controller),
          body: _buildBody(context, controller),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CartController controller) {
    final state = controller.state;
    final cart = state.cart;

    if (state.isLoading && cart == null) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: AppLocalizations.of(context)?.cartYourCart ?? 'Your Cart',
              subtitle:
                  AppLocalizations.of(context)?.cartReviewItems ??
                  'Review your selected items',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            sliver: SliverToBoxAdapter(child: AppShimmer.list(count: 3)),
          ),
        ],
      );
    }

    if (state.error != null && cart == null) {
      return AppStateView.error(
        message: state.error!,
        actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
        onAction: controller.refreshCart,
      );
    }

    if (cart == null || cart.items.isEmpty) {
      return AppStateView.empty(
        message:
            AppLocalizations.of(context)?.cartEmptyMessage ??
            'Your cart is empty. Start browsing curated products.',
        actionLabel:
            AppLocalizations.of(context)?.cartBrowseCategories ??
            'Browse Categories',
        onAction: () => Get.offNamed('/categories'),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: PremiumPageHeader(
            title: AppLocalizations.of(context)?.cartYourCart ?? 'Your Cart',
            subtitle:
                AppLocalizations.of(context)?.cartReviewBeforeCheckout ??
                'Review your selected items before checkout',
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ─── Promo Code ───
              PremiumSurfaceCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.cartHavePromoCode ??
                              'Have a promo code?',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppInput(
                                controller: controller.promoController,
                                hintText:
                                    AppLocalizations.of(
                                      context,
                                    )?.cartEnterCode ??
                                    'Enter code here',
                                prefixIcon: const Icon(
                                  Icons.local_offer_outlined,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AppButton(
                              label:
                                  AppLocalizations.of(context)?.cartApply ??
                                  'Apply',
                              isSmall: true,
                              fullWidth: false,
                              variant: AppButtonVariant.secondary,
                              isLoading: state.isApplyingPromo,
                              onPressed: () async {
                                await controller.applyPromo();
                                if (context.mounted &&
                                    controller.state.error == null) {
                                  AppSnackbar.show(
                                    context,
                                    message:
                                        AppLocalizations.of(
                                          context,
                                        )?.cartPromoApplied ??
                                        'Promo code applied.',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: AppMotion.medium)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: AppMotion.medium,
                    curve: AppMotion.emphasis,
                  ),

              const SizedBox(height: AppSpacing.sectionGap),

              ..._buildCartItemSections(context, controller, cart),

              // ─── Summary Breakdown ───
              const SizedBox(height: AppSpacing.lg),
              PremiumSurfaceCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: CartTotals(cart: cart),
                  )
                  .animate()
                  .fadeIn(duration: AppMotion.medium, delay: 300.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: AppMotion.medium,
                    delay: 300.ms,
                    curve: AppMotion.emphasis,
                  ),

              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCartItemSections(
    BuildContext context,
    CartController controller,
    Cart cart,
  ) {
    final sections = <Widget>[];
    var itemIndex = 0;

    void addItems(List<CartItem> items, {String? businessName}) {
      if (businessName != null && businessName.isNotEmpty) {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              businessName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      } else {
        sections.add(
          Text(
            AppLocalizations.of(context)?.cartItems(cart.items.length) ??
                'Cart Items (${cart.items.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(duration: AppMotion.medium, delay: 50.ms),
        );
        sections.add(const SizedBox(height: AppSpacing.base));
      }

      for (final item in items) {
        final index = itemIndex++;
        sections.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.base),
            child: _PremiumCartItemCard(
              item: item,
              onQuantityChanged: (quantity) =>
                  controller.updateQuantity(item.id, quantity),
              onRemove: () {
                HapticFeedback.mediumImpact();
                controller.removeItem(item.id);
              },
            )
                .animate()
                .fadeIn(
                  duration: AppMotion.medium,
                  delay: (100 + (50 * index)).ms,
                )
                .slideY(
                  begin: 0.1,
                  end: 0,
                  duration: AppMotion.medium,
                  delay: (100 + (50 * index)).ms,
                  curve: AppMotion.emphasis,
                ),
          ),
        );
      }
    }

    if (cart.businesses.isNotEmpty) {
      for (final business in cart.businesses) {
        addItems(business.items, businessName: business.businessName);
        sections.add(const SizedBox(height: AppSpacing.sm));
      }
    } else {
      addItems(cart.items);
    }

    return sections;
  }
}

// ─── Premium Cart Item Card ───
class _PremiumCartItemCard extends StatelessWidget {
  const _PremiumCartItemCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return PremiumSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xLarge),
              child: CachedImage(
                url: item.imageUrl,
                width: 96,
                height: 96,
                fallbackAsset: 'assets/category_img01.png',
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        (() {
                          final isAr =
                              Localizations.localeOf(context).languageCode ==
                              'ar';
                          final name = isAr && item.productNameAr.isNotEmpty
                              ? item.productNameAr
                              : item.productName;
                          return name.isNotEmpty
                              ? name
                              : (AppLocalizations.of(context)?.cartProduct ??
                                    'Product');
                        })(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.3,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip:
                          AppLocalizations.of(context)?.cartRemoveItem ??
                          'Remove',
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.dangerSoft.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!item.isAvailable) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Unavailable',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'SAR ${item.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.brand,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                QuantityStepper(
                  value: item.quantity,
                  max: item.isAvailable
                      ? (item.stock > 0 ? item.stock.clamp(1, 100) : 100)
                      : item.quantity,
                  onChanged: onQuantityChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Bar ───
class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({required this.cart, required this.controller});

  final Cart cart;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    final canCheckout = !cart.hasUnavailableItems;
    return StickyActionBar(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.cartEstimatedTotal ??
                      'Estimated Total',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'SAR ${cart.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: AppButton(
              label: AppLocalizations.of(context)?.cartCheckout ?? 'Checkout',
              isSmall: true,
              isLoading: controller.state.isProceedingToCheckout,
              onPressed: canCheckout
                  ? () => controller.proceedToCheckout()
                  : null,
            ),
          ),
        ],
      ),
    ).animate().slideY(
      begin: 1.0,
      end: 0,
      duration: AppMotion.heroTransition,
      curve: AppMotion.emphasis,
    );
  }
}

// ─── Cart Totals ───
class CartTotals extends StatelessWidget {
  const CartTotals({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _TotalRow(
          label: l10n?.cartSubtotal ?? 'Subtotal',
          value: 'SAR ${cart.subtotal.toStringAsFixed(2)}',
        ),
        if (cart.discountAmount > 0)
          _TotalRow(
            label: l10n?.cartDiscount ?? 'Discount',
            value: '- SAR ${cart.discountAmount.toStringAsFixed(2)}',
            valueColor: AppColors.error,
          ),
        if (cart.taxAmount > 0)
          _TotalRow(
            label: 'Tax',
            value: 'SAR ${cart.taxAmount.toStringAsFixed(2)}',
          ),
        _TotalRow(
          label: l10n?.cartShipping ?? 'Shipping',
          value: l10n?.cartShippingFree ?? 'Free',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
        ),
        _TotalRow(
          label: l10n?.cartTotal ?? 'Total',
          value: 'SAR ${cart.total.toStringAsFixed(2)}',
          valueColor: AppColors.textMain,
          isBold: true,
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: valueColor ?? AppColors.textPrimary,
      fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
      fontSize: isBold ? 16 : 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isBold ? AppColors.textMain : AppColors.textSecondary,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isBold) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text(
                    '.' * (constraints.maxWidth / 4).floor(),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: AppColors.borderSubtle.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}
