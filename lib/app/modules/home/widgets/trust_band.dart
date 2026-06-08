import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Horizontal strip of 4 trust/feature items.
///
/// Uses `features_icon01-04.svg` (rendered via [Image.asset]) with
/// localized labels.
class TrustBand extends StatelessWidget {
  const TrustBand({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _TrustItem(
        icon: 'assests/features_icon01.svg',
        fallbackIcon: Icons.local_shipping_outlined,
        label: l10n.homeTrustFreeDelivery,
      ),
      _TrustItem(
        icon: 'assests/features_icon02.svg',
        fallbackIcon: Icons.lock_outline,
        label: l10n.homeTrustSecurePayment,
      ),
      _TrustItem(
        icon: 'assests/features_icon03.svg',
        fallbackIcon: Icons.verified_outlined,
        label: l10n.homeTrustQualityGuarantee,
      ),
      _TrustItem(
        icon: 'assests/features_icon04.svg',
        fallbackIcon: Icons.support_agent_outlined,
        label: l10n.homeTrustSupport,
      ),
    ];

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.base,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) => _TrustItemWidget(item: item)).toList(),
      ),
    );
  }
}

class _TrustItem {
  final String icon;
  final IconData fallbackIcon;
  final String label;

  const _TrustItem({
    required this.icon,
    required this.fallbackIcon,
    required this.label,
  });
}

class _TrustItemWidget extends StatelessWidget {
  final _TrustItem item;

  const _TrustItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          item.icon,
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
          placeholderBuilder: (context) =>
              Icon(item.fallbackIcon, size: 32, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          width: 72,
          child: Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
