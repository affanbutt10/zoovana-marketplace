import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/category.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../widgets/cached_image.dart';
import '../../../widgets/shared/premium_page_header.dart';
import '../../../widgets/shared/premium_surface_card.dart';
import 'bindings/categories_binding.dart';
import 'controllers/categories_controller.dart';
import '../../../l10n/app_localizations.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    CategoriesBinding.ensureInitialized();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: GetBuilder<CategoriesController>(
        builder: (controller) {
          if (controller.isLoading) {
            return _buildLoadingState();
          }

          if (controller.error != null) {
            return AppStateView.error(
              message: controller.error!,
              actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
              onAction: controller.loadCategories,
            );
          }

          if (controller.categories.isEmpty) {
            return AppStateView.empty(
              message:
                  AppLocalizations.of(context)?.categoriesEmptyMoment ??
                  'No categories available at the moment.',
            );
          }

          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Premium Hero Header
              SliverToBoxAdapter(
                child: PremiumPageHeader(
                  title:
                      AppLocalizations.of(context)?.categoriesShopBy ??
                      'Shop by Category',
                  subtitle:
                      AppLocalizations.of(context)?.categoriesSubtitle ??
                      'Curated collections for your beloved companions',
                ),
              ),

              // Category Grid with Premium Cards
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.xxxl,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                      ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _PremiumCategoryCard(
                      category: controller.categories[index],
                      fallbackIndex: index,
                      index: index,
                    );
                  }, childCount: controller.categories.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumPageHeader(
              title:
                  AppLocalizations.of(context)?.categoriesShopBy ??
                  'Shop by Category',
              subtitle:
                  AppLocalizations.of(context)?.categoriesSubtitle ??
                  'Curated collections for your beloved companions',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: AppShimmer.productGrid(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Premium Category Card ───
class _PremiumCategoryCard extends StatefulWidget {
  const _PremiumCategoryCard({
    required this.category,
    required this.fallbackIndex,
    required this.index,
  });

  final Category category;
  final int fallbackIndex;
  final int index;

  @override
  State<_PremiumCategoryCard> createState() => _PremiumCategoryCardState();
}

class _PremiumCategoryCardState extends State<_PremiumCategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: AppMotion.fast);
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _ctrl, curve: AppMotion.emphasis));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _fallbackAsset =>
      'assets/category_img0${(widget.fallbackIndex % 6) + 1}.png';

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final label = isArabic && widget.category.nameAr.isNotEmpty
        ? widget.category.nameAr
        : widget.category.name;

    final cardRadius = BorderRadius.circular(AppRadius.xxLarge);

    return Semantics(
          button: true,
          label: label,
          child: AnimatedBuilder(
            animation: _scaleAnim,
            builder: (context, child) {
              return Transform.scale(scale: _scaleAnim.value, child: child);
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: cardRadius,
                onTapDown: (_) {
                  _ctrl.forward();
                },
                onTapUp: (_) {
                  _ctrl.reverse();
                },
                onTapCancel: () {
                  _ctrl.reverse();
                },
                onTap: () {
                  HapticFeedback.selectionClick();
                  Get.toNamed(AppRoutes.categoryById(widget.category.slug));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: PremiumSurfaceCard(
                        padding: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: cardRadius,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedImage(
                                url: widget.category.imageUrl,
                                fallbackAsset: _fallbackAsset,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.4),
                                      ],
                                    ),
                                  ),
                                  child: const SizedBox(height: 80),
                                ),
                              ),
                              PositionedDirectional(
                                top: AppSpacing.md,
                                end: AppSpacing.md,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.xLarge,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      '${(widget.index + 1) * 12}+',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.textMain,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppLocalizations.of(
                                  context,
                                )?.categoriesPremiumSelection ??
                                'Premium selection',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 13,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: AppMotion.medium, delay: (60 * widget.index).ms)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: AppMotion.medium,
          delay: (60 * widget.index).ms,
          curve: AppMotion.emphasis,
        );
  }
}
