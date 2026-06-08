import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

/// Premium AppBar with blur-on-scroll effect.
///
/// Transparent when at the top, frosted glass when scrolled.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
    this.bottom,
    this.transparent = false,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: transparent
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.88),
                  const Color(0xFFEFF6FF).withValues(alpha: 0.82),
                ],
              ),
        color: transparent ? Colors.transparent : null,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderSubtle.withValues(alpha: 0.35),
          ),
        ),
        boxShadow: transparent
            ? AppShadows.elevation0
            : [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: transparent
              ? ImageFilter.blur()
              : ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AppBar(
            toolbarHeight: 62,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: leading,
            titleSpacing: leading != null ? 0 : AppSpacing.base,
            title: title,
            actions: actions,
            bottom: bottom,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(62 + (bottom?.preferredSize.height ?? 0));
}
