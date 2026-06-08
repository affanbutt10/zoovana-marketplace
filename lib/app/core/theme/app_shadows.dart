import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Premium multi-layer soft shadows.
///
/// Each elevation uses two box-shadows (ambient + key light) for
/// a natural, diffused appearance — unlike Material's single harsh shadow.
abstract final class AppShadows {
  static const List<BoxShadow> elevation0 = [];

  /// Subtle lift — cards at rest.
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// Moderate lift — hovered cards, active elements.
  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x06000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  /// Strong lift — modals, FABs, bottom sheets.
  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x10000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];

  /// Dramatic lift — overlays, dialogs.
  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  /// Colored brand shadow — for primary CTAs.
  static List<BoxShadow> brandGlow = [
    BoxShadow(
      color: AppColors.brand.withValues(alpha: 0.25),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static BoxBorder subtleBorder = Border.all(color: AppColors.borderSubtle);
}
