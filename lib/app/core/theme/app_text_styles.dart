import 'package:flutter/material.dart';

/// Typography scale for Zoovana.
///
/// Display/heading: DM Serif Display — elegant personality for a pet brand.
/// Body: DM Sans — clean, modern readability.
/// Both applied via [GoogleFonts] in [app_theme.dart].
abstract final class AppTextStyles {
  // ─── Display ───
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 34,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );

  // ─── Headline ───
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    height: 1.3,
    fontWeight: FontWeight.w700,
  );

  // ─── Title ───
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  // ─── Body ───
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.55,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  // ─── Label ───
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    height: 1.1,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // ─── Semantic Aliases ───
  static const TextStyle price = TextStyle(
    fontSize: 20,
    height: 1.1,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle priceSmall = TextStyle(
    fontSize: 16,
    height: 1.1,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle meta = TextStyle(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 11,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  // ─── Backward compat aliases ───
  static const TextStyle h1 = displayMedium;
  static const TextStyle h2 = headlineLarge;
  static const TextStyle h3 = headlineMedium;
  static const TextStyle h4 = headlineSmall;
  static const TextStyle h5 = titleLarge;
  static const TextStyle h6 = titleMedium;
  static const TextStyle body = bodyMedium;
  static const TextStyle caption = labelSmall;
  static const TextStyle label = labelMedium;
  static const TextStyle display = displayLarge;
  static const TextStyle headline = headlineMedium;
  static const TextStyle title = titleLarge;
}
