import 'package:flutter/material.dart';

/// Border radius constants for the premium soft aesthetic.
///
/// Generous radii (16–28) for a warm, approachable feel.
abstract final class AppRadius {
  static const double xs = 6.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 20.0;
  static const double xxLarge = 24.0;
  static const double xxxLarge = 28.0;
  static const double pill = 100.0;

  // Short aliases
  static const double lg = large;
  static const double xl = xLarge;

  // ─── Pre-built BorderRadius ───
  static final BorderRadius smAll = BorderRadius.circular(small);
  static final BorderRadius mdAll = BorderRadius.circular(medium);
  static final BorderRadius lgAll = BorderRadius.circular(large);
  static final BorderRadius xlAll = BorderRadius.circular(xLarge);
  static final BorderRadius xxlAll = BorderRadius.circular(xxLarge);
  static final BorderRadius pillAll = BorderRadius.circular(pill);
}
