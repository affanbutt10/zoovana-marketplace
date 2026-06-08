import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/theme/app_radius.dart';
import '../../../../app/core/theme/app_spacing.dart';
import '../../../../app/data/models/category.dart';

/// Horizontal scrollable belt of category tiles.
///
/// Each tile shows the category image (with fallback to a local asset)
/// and navigates to `/categories/{slug}` on tap.
class CategoryBelt extends StatelessWidget {
  final List<Category> categories;

  const CategoryBelt({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _CategoryTile(
            category: categories[index],
            fallbackIndex: index,
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final int fallbackIndex;

  const _CategoryTile({required this.category, required this.fallbackIndex});

  String get _fallbackAsset {
    final n = (fallbackIndex % 6) + 1;
    return 'assests/category_img0$n.png';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            onTap: () => Get.toNamed('/category/${category.slug}'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: _buildImage(),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = category.imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Image.asset(
      _fallbackAsset,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 56,
        height: 56,
        color: AppColors.skeletonBase,
        child: const Icon(Icons.pets, size: 28),
      ),
    );
  }
}
