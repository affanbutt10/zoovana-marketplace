import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppPageBackground extends StatelessWidget {
  const AppPageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFABC8FD), Color(0xFFDDE8FF), Color(0xFFF8FBFF)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _GlowOrb(
            alignment: Alignment.topRight,
            size: 180,
            color: AppColors.brandSoft,
          ),
          const _GlowOrb(
            alignment: Alignment.centerLeft,
            size: 220,
            color: AppColors.accentSoft,
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.alignment,
    required this.size,
    required this.color,
  });

  final Alignment alignment;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Transform.translate(
          offset: Offset(alignment.x * 36, alignment.y * 48),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.45),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
