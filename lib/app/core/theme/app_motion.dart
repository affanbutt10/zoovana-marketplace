import 'package:flutter/material.dart';

/// Animation duration and curve constants.
///
/// Used in AnimatedContainer, AnimatedOpacity, custom transitions, etc.
abstract final class AppMotion {
  // ─── Durations ───
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 400);
  static const Duration heroTransition = Duration(milliseconds: 600);
  static const Duration shimmerCycle = Duration(milliseconds: 1500);
  static const Duration stagger = Duration(milliseconds: 80);

  // ─── Curves ───
  static const Curve emphasis = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve decelerate = Curves.decelerate;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve smooth = Curves.easeInOut;
  static const Curve overshoot = Curves.easeOutBack;
}
