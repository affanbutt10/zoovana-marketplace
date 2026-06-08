import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Skeleton shimmer screens for premium loading states.
///
/// Use named constructors for common patterns:
/// `AppShimmer.productGrid()`, `AppShimmer.list()`, `AppShimmer.card()`.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: child,
    );
  }

  /// Product grid skeleton (2 columns).
  static Widget productGrid({int count = 6}) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.base,
            mainAxisSpacing: AppSpacing.base,
            childAspectRatio: 0.58,
          ),
          itemCount: count,
          itemBuilder: (context, index) => _productCardSkeleton(),
        ),
      ),
    );
  }

  /// Horizontal product list skeleton.
  static Widget productList({int count = 4}) {
    return SizedBox(
      height: 290,
      child: AppShimmer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          itemCount: count,
          separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.base),
          itemBuilder: (context, index) => SizedBox(
            width: 200,
            child: _productCardSkeleton(),
          ),
        ),
      ),
    );
  }

  /// Single card skeleton.
  static Widget card({double? height}) {
    return AppShimmer(
      child: Container(
        height: height ?? 120,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        ),
      ),
    );
  }

  /// Category strip skeleton.
  static Widget categoryStrip({int count = 5}) {
    return SizedBox(
      height: 108,
      child: AppShimmer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          itemCount: count,
          separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.base),
          itemBuilder: (context, index) => Container(
            width: 92,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
          ),
        ),
      ),
    );
  }

  /// Line item list skeleton (for cart, orders).
  static Widget list({int count = 4}) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: List.generate(
            count,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.base),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          height: 14,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xs),
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
      ),
    );
  }

  /// Hero banner skeleton.
  static Widget heroBanner() {
    return AppShimmer(
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(AppSpacing.screenPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        ),
      ),
    );
  }

  static Widget _productCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xxLarge),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 20,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
