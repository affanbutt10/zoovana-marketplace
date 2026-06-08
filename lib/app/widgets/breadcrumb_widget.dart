import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// A single breadcrumb item with a label and optional tap handler.
class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({required this.label, this.onTap});
}

/// Horizontal breadcrumb trail with decorative paw icon and RTL-aware separators.
///
/// - Uses `breadcrumb_pets.png` as a decorative icon on the left.
/// - Separates items with `right_arrow.svg` mirrored in RTL via
///   `Transform.scale(scaleX: isRtl ? -1 : 1)`.
/// - Last item is non-tappable and styled with bold primary color.
class BreadcrumbWidget extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decorative paw icon
          Image.asset(
            'assests/breadcrumb_pets.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          // Breadcrumb items with separators
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) _buildSeparator(isRtl),
            _buildItem(context, items[i], isLast: i == items.length - 1),
          ],
        ],
      ),
    );
  }

  Widget _buildSeparator(bool isRtl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Transform.scale(
        scaleX: isRtl ? -1 : 1,
        child: SvgPicture.asset(
          'assests/right_arrow.svg',
          width: 12,
          height: 12,
          colorFilter: const ColorFilter.mode(
            AppColors.muted,
            BlendMode.srcIn,
          ),
          placeholderBuilder: (context) => Icon(
            Icons.chevron_right,
            size: 16,
            color: AppColors.muted,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    BreadcrumbItem item, {
    required bool isLast,
  }) {
    final textStyle = isLast
        ? Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            )
        : Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.muted,
            );

    if (isLast || item.onTap == null) {
      return Text(item.label, style: textStyle);
    }

    return GestureDetector(
      onTap: item.onTap,
      child: Text(item.label, style: textStyle),
    );
  }
}
