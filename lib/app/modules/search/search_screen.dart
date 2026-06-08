import 'package:flutter/material.dart';
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
import '../../../widgets/shared/premium_page_header.dart';
import '../../../widgets/shared/premium_surface_card.dart';
import 'bindings/search_binding.dart';
import 'controllers/search_controller.dart' as search_module;
import '../../../l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SearchBinding.ensureInitialized();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<search_module.SearchController>(
      builder: (controller) {
        final query = controller.currentQuery.trim();
        final hasQuery = query.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.surfaceBase,
          body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Premium Header with Search
              SliverToBoxAdapter(
                child: _PremiumSearchHeader(
                  controller: controller,
                  hasQuery: hasQuery,
                ),
              ),

              // Content Area
              SliverToBoxAdapter(
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

  Widget _buildBody(
    BuildContext context,
    search_module.SearchController controller,
  ) {
    final query = controller.currentQuery.trim();
    final hasSearchQuery = query.isNotEmpty;
    final isSearching = hasSearchQuery || controller.isLoading || controller.error != null || controller.results.isNotEmpty;

    if (!isSearching) {
      if (controller.recentSearches.isEmpty) {
        return _PremiumEmptyState(
          icon: Icons.search_rounded,
          title:
              AppLocalizations.of(context)?.searchStartTitle ??
              'Start Searching',
          subtitle:
              AppLocalizations.of(context)?.searchStartSubtitle ??
              'Discover premium products for your beloved pets',
        );
      }
      return _RecentSearchesList(controller: controller);
    }

    if (controller.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        child: AppShimmer.productGrid(),
      );
    }

    if (controller.error != null) {
      return AppStateView.error(
        message: controller.error!,
        actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
        onAction: () => controller.search(query),
      );
    }

    if (controller.results.isEmpty) {
      return _PremiumEmptyState(
        icon: Icons.search_off_rounded,
        title:
            AppLocalizations.of(context)?.searchNoResultsTitle ??
            'No Results Found',
        subtitle:
            AppLocalizations.of(context)?.searchNoResultsSubtitle(query) ??
            'We couldn\'t find anything for "$query"',
        actionLabel:
            AppLocalizations.of(context)?.searchBrowseCategories ??
            'Browse Categories',
        onAction: () => Get.offNamed(AppRoutes.categories),
      );
    }

    return _SearchResultsGrid(controller: controller);
  }
}

// ─── Premium Search Header ───
class _PremiumSearchHeader extends StatelessWidget {
  const _PremiumSearchHeader({
    required this.controller,
    required this.hasQuery,
  });

  final search_module.SearchController controller;
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumPageHeader(
          title: AppLocalizations.of(context)?.searchTitle ?? 'Search',
          subtitle:
              AppLocalizations.of(context)?.searchSubtitle ??
              'Find the perfect products for your pets',
        ),

        // Premium Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: _PremiumSearchField(controller: controller)
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 300.ms),
        ),
      ],
    );
  }
}

// ─── Premium Search Field ───
class _PremiumSearchField extends StatelessWidget {
  const _PremiumSearchField({required this.controller});

  final search_module.SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.queryController,
        focusNode: controller.focusNode,
        onChanged: controller.onQueryChanged,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textMain,
        ),
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(context)?.searchFieldHint ??
              'Search by breed, size, or product name...',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.brand,
              size: 22,
            ),
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.queryController,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: AppLocalizations.of(context)?.close ?? 'Close',
                onPressed: () {
                  controller.queryController.clear();
                  controller.onQueryChanged('');
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                icon: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox.square(
                    dimension: 28,
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
              );
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppColors.brand.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
      ),
    );
  }
}

// ─── Recent Searches List ───
class _RecentSearchesList extends StatelessWidget {
  const _RecentSearchesList({required this.controller});

  final search_module.SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.searchRecentSearches ??
                    'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: controller.clearRecentSearches,
                child: Text(
                  AppLocalizations.of(context)?.searchClearAll ?? 'Clear All',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.brand,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: controller.recentSearches
                .map((recent) {
                  return ActionChip(
                    avatar: const Icon(Icons.history_rounded, size: 18),
                    label: Text(recent),
                    onPressed: () => controller.selectRecentSearch(recent),
                  );
                })
                .toList(growable: false),
          ).animate().fadeIn(duration: AppMotion.fast),

          const SizedBox(height: 32),

          // Popular Suggestions
          Text(
            AppLocalizations.of(context)?.searchPopularSearches ??
                'Popular Searches',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

          const SizedBox(height: 16),

          Builder(
            builder: (context) {
              final suggestions = controller.categorySuggestionsForLocale(
                Localizations.localeOf(context).languageCode,
              );

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: suggestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tag = entry.value;

                  return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.xLarge),
                          onTap: () {
                            controller.queryController.text = tag;
                            controller.onQueryChanged(tag);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.borderSubtle.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: (400 + index * 50).ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                        delay: (400 + index * 50).ms,
                      );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─── Search Results Grid ───
class _SearchResultsGrid extends StatelessWidget {
  const _SearchResultsGrid({required this.controller});

  final search_module.SearchController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchFilterBar(
            controller: controller,
          ).animate().fadeIn(duration: AppMotion.fast),

          const SizedBox(height: AppSpacing.base),

          // Results Header
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 8),
            child: PremiumSurfaceCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.brand.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.brand,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.searchResultsFound(
                                controller.results.length,
                              ) ??
                              '${controller.results.length} Products Found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textMain,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.currentQuery.isEmpty
                              ? 'Showing all products'
                              : AppLocalizations.of(context)?.searchShowingResultsFor(
                                    controller.currentQuery,
                                  ) ??
                                  'Showing results for "${controller.currentQuery}"',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),

          // Results Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.72,
            ),
            itemCount: controller.results.length,
            itemBuilder: (context, index) {
              final product = controller.results[index];
              return AppProductCard(
                    product: product,
                    heroTag: 'search-${product.id}',
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Get.toNamed(AppRoutes.productById(product.id));
                    },
                    onAddToCart: () async {
                      await controller.addToCart(product);
                      if (context.mounted) {
                        AppSnackbar.show(
                          context,
                          message: AppLocalizations.of(
                            context,
                          )!.productAddedToCart,
                        );
                      }
                    },
                  )
                  .animate()
                  .fadeIn(
                    duration: AppMotion.medium,
                    delay: (index < 6 ? 60 * index : 0).ms,
                  )
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: AppMotion.medium,
                    delay: (index < 6 ? 60 * index : 0).ms,
                    curve: AppMotion.emphasis,
                  );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  const _SearchFilterBar({required this.controller});

  final search_module.SearchController controller;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => _showFilterSheet(context, controller),
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: Text(_sortLabel(l10n, controller.sortOption)),
          ),
          const SizedBox(width: AppSpacing.sm),
          ...controller.categories.map((category) {
            final label = languageCode == 'ar' && category.nameAr.isNotEmpty
                ? category.nameAr
                : category.name;
            final isSelected = controller.selectedCategorySlug == category.slug;
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
              child: FilterChip(
                selected: isSelected,
                label: Text(label),
                onSelected: (_) => controller.selectCategory(
                  isSelected ? null : category.slug,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  static String _sortLabel(
    AppLocalizations l10n,
    search_module.SearchSortOption option,
  ) {
    return switch (option) {
      search_module.SearchSortOption.relevance => l10n.sortRelevance,
      search_module.SearchSortOption.priceLowHigh => l10n.sortPriceLowHigh,
      search_module.SearchSortOption.priceHighLow => l10n.sortPriceHighLow,
      search_module.SearchSortOption.newest => l10n.sortNewest,
      search_module.SearchSortOption.topRated => l10n.sortTopRated,
    };
  }

  static void _showFilterSheet(
    BuildContext context,
    search_module.SearchController controller,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final minPrice = controller.minResultPrice;
    final maxPrice = controller.maxResultPrice;
    var range = RangeValues(
      controller.selectedMinPrice ?? minPrice,
      controller.selectedMaxPrice ?? maxPrice,
    );

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.searchSortAndFilter,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    ...search_module.SearchSortOption.values.map((option) {
                      final isSelected = controller.sortOption == option;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          isSelected
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: isSelected
                              ? AppColors.brand
                              : AppColors.textTertiary,
                        ),
                        title: Text(_sortLabel(l10n, option)),
                        onTap: () {
                          controller.setSort(option);
                          Navigator.of(context).pop();
                        },
                      );
                    }),
                    if (maxPrice > minPrice) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.searchPriceRange,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      RangeSlider(
                        min: minPrice,
                        max: maxPrice,
                        values: range,
                        labels: RangeLabels(
                          range.start.toStringAsFixed(0),
                          range.end.toStringAsFixed(0),
                        ),
                        onChanged: (value) {
                          setModalState(() => range = value);
                          controller.setPriceRange(value.start, value.end);
                        },
                      ),
                    ],
                    if (controller.hasActiveFilters)
                      TextButton.icon(
                        onPressed: () {
                          controller.clearFilters();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.clear_rounded),
                        label: Text(l10n.searchClearAll),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Premium Empty State ───
class _PremiumEmptyState extends StatelessWidget {
  const _PremiumEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.brand.withValues(alpha: 0.1),
                      AppColors.brand.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: AppColors.brand),
              )
              .animate()
              .scale(
                duration: AppMotion.heroTransition,
                curve: AppMotion.emphasis,
              )
              .fadeIn(),

          const SizedBox(height: 28),

          Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: AppColors.textMain,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.1, end: 0, delay: 200.ms),

          const SizedBox(height: 12),

          Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontSize: 15,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 300.ms),

          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 32),
            Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms)
                .slideY(begin: 0.1, end: 0, delay: 400.ms),
          ],
        ],
      ),
    );
  }
}
