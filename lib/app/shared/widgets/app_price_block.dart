import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class AppPriceBlock extends StatelessWidget {
  const AppPriceBlock({
    super.key,
    required this.price,
    this.compareAtPrice,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final double price;
  final double? compareAtPrice;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = compareAtPrice != null && compareAtPrice! > price;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          'SAR ${price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
        ),
        if (hasDiscount) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SAR ${compareAtPrice!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '-${(((compareAtPrice! - price) / compareAtPrice!) * 100).round()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
