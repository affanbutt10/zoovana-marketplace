import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/pet_ui_adapter.dart';
import '../../shared/widgets/app_product_card.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/product_badge.dart';
import '../../../widgets/shared/sticky_action_bar.dart';
import 'bindings/product_binding.dart';
import 'controllers/product_controller.dart';
import '../../../l10n/app_localizations.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    ProductBinding.ensureInitialized(widget.id);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ProductController>(tag: widget.id)) {
      Get.delete<ProductController>(tag: widget.id);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      tag: widget.id,
      builder: (controller) {
        final state = controller.state;
        final product = state.product;

        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.appBg,
            body: AppStateView.loading(
              message:
                  AppLocalizations.of(context)?.productFindingPerfect ??
                  'Finding your perfect pet...',
            ),
          );
        }

        if (state.error != null || product == null) {
          return Scaffold(
            backgroundColor: AppColors.appBg,
            body: AppStateView.error(
              message:
                  state.error ??
                  (AppLocalizations.of(context)?.productCouldNotLoad ??
                      'Could not load this pet.'),
              actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
              onAction: controller.load,
            ),
          );
        }

        final screenHeight = MediaQuery.sizeOf(context).height;

        return Scaffold(
          backgroundColor: AppColors.surfaceRaised,
          extendBodyBehindAppBar: false,
          body: Stack(
            children: [
              // ─── Full-bleed Pet Image (top 45%) ───
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.45,
                child: Hero(
                  tag: 'product-${product.id}',
                  child: CachedImage(
                    url: product.imageUrl,
                    fallbackAsset: 'assets/category_img01.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: screenHeight * 0.45,
                  ),
                ),
              ),

              // ─── Status bar scrim so icons are readable over the image ───
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.paddingOf(context).top + 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Stock badge ───
              if (product.isOutOfStock)
                Positioned(
                  top: MediaQuery.paddingOf(context).top + AppSpacing.sm + 52,
                  right: AppSpacing.base,
                  child: ProductBadge(product: product),
                ),

              // ─── Back Button ───
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
                left: Directionality.of(context) == TextDirection.ltr
                    ? AppSpacing.base
                    : null,
                right: Directionality.of(context) == TextDirection.rtl
                    ? AppSpacing.base
                    : null,
                child:
                    Tooltip(
                          message: AppLocalizations.of(context)?.back ?? 'Back',
                          child: Material(
                            color: Colors.white.withValues(alpha: 0.20),
                            shape: const CircleBorder(),
                            elevation: 0,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: Get.back,
                              child: const SizedBox.square(
                                dimension: 44,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: AppMotion.fast)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: AppMotion.fast,
                        ),
              ),

              // ─── Scrollable Info Card (overlaps image) ───
              DraggableScrollableSheet(
                initialChildSize: 0.60,
                minChildSize: 0.55,
                maxChildSize: 0.92,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.xxxLarge),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.base,
                        AppSpacing.screenPadding,
                        // Enough room for the sticky CTA bar + device bottom inset
                        MediaQuery.paddingOf(context).bottom + 88,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── Drag Handle ───
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.borderSubtle,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // ─── Pet Name ───
                          Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                          context,
                                        )?.productPetName ??
                                        'Pet Name:  ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColors.textSub,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      PetUiAdapter.petName(product, context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: AppColors.textMain,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(duration: AppMotion.medium, delay: 100.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                duration: AppMotion.medium,
                                delay: 100.ms,
                                curve: AppMotion.emphasis,
                              ),

                          const SizedBox(height: AppSpacing.sm),

                          // ─── Distance ───
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.textSub,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '${AppLocalizations.of(context)?.productDistance ?? 'Distance:'} ${PetUiAdapter.distance(product)}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSub),
                              ),
                            ],
                          ).animate().fadeIn(
                            duration: AppMotion.medium,
                            delay: 150.ms,
                          ),

                          const SizedBox(height: AppSpacing.xl),

                          // ─── Info Chips (Sex, Age, Breed) ───
                          Row(
                                children: [
                                  _InfoChip(
                                    value: PetUiAdapter.sex(product),
                                    label:
                                        AppLocalizations.of(
                                          context,
                                        )?.productSex ??
                                        'Sex',
                                    bgColor: AppColors.lavenderChip,
                                    textColor: AppColors.lavenderText,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  _InfoChip(
                                    value: PetUiAdapter.age(product),
                                    label:
                                        AppLocalizations.of(
                                          context,
                                        )?.productAge ??
                                        'Age',
                                    bgColor: AppColors.mintChip,
                                    textColor: AppColors.mintChipText,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  _InfoChip(
                                    value: PetUiAdapter.species(product),
                                    label:
                                        AppLocalizations.of(
                                          context,
                                        )?.productBreed ??
                                        'Breed',
                                    bgColor: AppColors.sageChip,
                                    textColor: AppColors.sageChipText,
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(duration: AppMotion.medium, delay: 200.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                duration: AppMotion.medium,
                                delay: 200.ms,
                                curve: AppMotion.emphasis,
                              ),

                          const SizedBox(height: AppSpacing.xl),

                          // ─── About Section ───
                          Text(
                            AppLocalizations.of(context)?.productAbout(
                                  PetUiAdapter.petName(product, context),
                                ) ??
                                'About ${PetUiAdapter.petName(product, context)}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.textMain,
                                  fontWeight: FontWeight.w700,
                                ),
                          ).animate().fadeIn(
                            duration: AppMotion.medium,
                            delay: 250.ms,
                          ),

                          const SizedBox(height: AppSpacing.sm),

                          Text(
                            PetUiAdapter.about(product, context),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.textSub,
                                  height: 1.7,
                                ),
                          ).animate().fadeIn(
                            duration: AppMotion.medium,
                            delay: 300.ms,
                          ),

                          // ─── Related Pets ───
                          if (state.relatedProducts.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              AppLocalizations.of(
                                    context,
                                  )?.productSimilarPets ??
                                  'Similar Pets',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.textMain,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ).animate().fadeIn(
                              duration: AppMotion.medium,
                              delay: 350.ms,
                            ),
                            const SizedBox(height: AppSpacing.base),
                            SizedBox(
                              height: 280,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final related = state.relatedProducts[index];
                                  return SizedBox(
                                    width: 180,
                                    child: AppProductCard(
                                      product: related,
                                      heroTag: 'detail-related-${related.id}',
                                      onTap: () => Get.offNamed(
                                        '/product/${related.id}',
                                      ),
                                      onAddToCart: () => Get.offNamed(
                                        '/product/${related.id}',
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: AppSpacing.base),
                                itemCount: state.relatedProducts.length.clamp(
                                  0,
                                  10,
                                ),
                              ),
                            ).animate().fadeIn(
                              duration: AppMotion.medium,
                              delay: 400.ms,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // ─── Bottom Action Bar ───
          bottomNavigationBar: _buildBottomBar(context, controller),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductController controller) {
    final product = controller.state.product;
    if (product == null) return const SizedBox.shrink();

    final petSex = PetUiAdapter.sex(product);
    final isOutOfStock = product.isOutOfStock;
    final ctaLabel = isOutOfStock
        ? (AppLocalizations.of(context)?.outOfStock ?? 'Out of Stock')
        : petSex == 'Female'
            ? (AppLocalizations.of(context)?.productIWantHer ?? 'I Want Her')
            : (AppLocalizations.of(context)?.productIWantHim ?? 'I Want Him');

    return StickyActionBar(
      child: Row(
        children: [
          // I Want Her/Him CTA
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isOutOfStock || controller.state.isAddingToCart
                    ? null
                    : () async {
                        final added = await controller.addToCart();
                        if (!context.mounted) return;
                        if (added) {
                          AppSnackbar.show(
                            context,
                            message: AppLocalizations.of(
                              context,
                            )!.productAddedToCart,
                          );
                        } else {
                          final message = controller.state.error ??
                              'Failed to add to cart';
                          AppSnackbar.show(
                            context,
                            message: message,
                            type: SnackbarType.error,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOutOfStock
                      ? AppColors.textSecondary.withValues(alpha: 0.35)
                      : AppColors.zoovanaBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppColors.textSecondary.withValues(alpha: 0.35),
                  disabledForegroundColor: Colors.white.withValues(alpha: 0.9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.pets, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      controller.state.isAddingToCart
                          ? (AppLocalizations.of(context)?.productAdding ??
                                'Adding...')
                          : ctaLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
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

// ─── Info Chip Widget ───

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.value,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  final String value;
  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Column(
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
