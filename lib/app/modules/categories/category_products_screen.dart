import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/app_product_card.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../shared/widgets/app_top_bar.dart';
import 'bindings/categories_binding.dart';
import 'controllers/category_products_controller.dart';
import '../../../l10n/app_localizations.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.slug});

  final String slug;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    CategoryProductsBinding.ensureInitialized(widget.slug);
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      Get.find<CategoryProductsController>(tag: widget.slug).loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (Get.isRegistered<CategoryProductsController>(tag: widget.slug)) {
      Get.delete<CategoryProductsController>(tag: widget.slug);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductsController>(
      tag: widget.slug,
      builder: (controller) {
        return Scaffold(
          appBar: AppTopBar(
            leading: IconButton(
              tooltip: AppLocalizations.of(context)?.back ?? 'Back',
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text(_slugToDisplayName(widget.slug)),
          ),
          body: Column(
            children: [
              _buildFilterBar(context, controller),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppMotion.fast,
                  child: _buildBody(context, controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    CategoryProductsController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderSubtle.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(
                  context,
                )?.productsCount(controller.products.length) ??
                '${controller.products.length} Products',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
          ),
          _PremiumDropdown(
            value: controller.sort,
            items: [
              DropdownMenuItem(
                value: 'newest',
                child: Text(
                  AppLocalizations.of(context)?.sortNewest ?? 'Newest',
                ),
              ),
              DropdownMenuItem(
                value: 'price_asc',
                child: Text(
                  AppLocalizations.of(context)?.sortPriceAsc ??
                      'Price: Low to High',
                ),
              ),
              DropdownMenuItem(
                value: 'price_desc',
                child: Text(
                  AppLocalizations.of(context)?.sortPriceDesc ??
                      'Price: High to Low',
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                HapticFeedback.selectionClick();
                controller.changeSort(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CategoryProductsController controller,
  ) {
    if (controller.isLoading && controller.products.isEmpty) {
      return SingleChildScrollView(
        key: const ValueKey('loading'),
        child: AppShimmer.productGrid(),
      );
    }
    if (controller.error != null && controller.products.isEmpty) {
      return AppStateView.error(
        key: const ValueKey('error'),
        message: controller.error!,
        actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
        onAction: controller.loadFirstPage,
      );
    }
    if (controller.products.isEmpty) {
      return AppStateView.empty(
        key: const ValueKey('empty'),
        message:
            AppLocalizations.of(context)?.noProductsInCategory ??
            'No products found in this category.',
        actionLabel:
            AppLocalizations.of(context)?.backToCategories ??
            'Back to categories',
        onAction: () => Get.offNamed(AppRoutes.categories),
      );
    }

    return GridView.builder(
      key: const ValueKey('content'),
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.base,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.base,
        mainAxisSpacing: AppSpacing.base,
        childAspectRatio: 0.72,
      ),
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return AppProductCard(
              product: product,
              heroTag: 'cat-${widget.slug}-${product.id}',
              onTap: () => Get.toNamed(AppRoutes.productById(product.id)),
              onAddToCart: () async {
                await controller.addToCart(product);
                if (context.mounted) {
                  AppSnackbar.show(
                    context,
                    message: AppLocalizations.of(context)!.productAddedToCart,
                  );
                }
              },
            )
            .animate()
            .fadeIn(
              duration: AppMotion.medium,
              delay: (index < 6 ? 50 * index : 0).ms,
            )
            .slideY(
              begin: 0.05,
              end: 0,
              duration: AppMotion.medium,
              delay: (index < 6 ? 50 * index : 0).ms,
              curve: AppMotion.emphasis,
            );
      },
    );
  }

  String _slugToDisplayName(String slug) {
    return slug
        .split('-')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}

/// A custom dropdown that looks better than the default Material one.
class _PremiumDropdown<T> extends StatelessWidget {
  const _PremiumDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceBase,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          iconEnabledColor: AppColors.textSecondary,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          dropdownColor: AppColors.surfaceRaised,
          elevation: 4,
          borderRadius: BorderRadius.circular(AppRadius.large),
          alignment: AlignmentDirectional.centerEnd,
        ),
      ),
    );
  }
}
