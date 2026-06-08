import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Full-width Saudi promotional banner.
///
/// Displays [saudi_banner_left.png] and [saudi_banner_right.png] side by side.
class SaudiBanner extends StatelessWidget {
  const SaudiBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Image.asset(
              'assests/saudi_banner_left.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: AppColors.skeletonBase,
              ),
            ),
          ),
          Expanded(
            child: Image.asset(
              'assests/saudi_banner_right.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: AppColors.skeletonBase,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
