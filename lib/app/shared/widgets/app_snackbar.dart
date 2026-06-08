import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

enum SnackbarType { success, error, info, warning }

/// Beautiful toast-style notifications.
class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final (icon, bgColor, fgColor) = switch (type) {
      SnackbarType.success => (
          Icons.check_circle_rounded,
          AppColors.success,
          Colors.white,
        ),
      SnackbarType.error => (
          Icons.error_rounded,
          AppColors.danger,
          Colors.white,
        ),
      SnackbarType.info => (
          Icons.info_rounded,
          AppColors.navy,
          Colors.white,
        ),
      SnackbarType.warning => (
          Icons.warning_rounded,
          AppColors.warning,
          Colors.white,
        ),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: fgColor, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: fgColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            0,
            AppSpacing.base,
            AppSpacing.xxxl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          duration: duration,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
  }
}
