import '../../data/models/product.dart';
import '../../data/models/category.dart';
import 'package:flutter/material.dart';

/// Maps existing [Product] and [Category] fields to pet adoption UI display values.
///
/// Locale-aware: uses Arabic fields when the current locale is Arabic.
class PetUiAdapter {
  PetUiAdapter._();

  // ─── Locale helper ───

  static bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  // ─── Product → Pet Mapping ───

  /// Returns the localized product name.
  static String petName(Product p, [BuildContext? context]) {
    if (context != null && _isArabic(context) && p.nameAr.isNotEmpty) {
      return p.nameAr;
    }
    return p.name;
  }

  /// Returns the localized product name (non-context version uses EN).
  static String productName(Product p, BuildContext context) {
    if (_isArabic(context) && p.nameAr.isNotEmpty) return p.nameAr;
    return p.name;
  }

  static String breed(Product p) {
    final slug = p.categorySlug;
    if (slug.isEmpty) return 'Mixed Breed';
    return slug
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  static String distance(Product p) {
    final hash = p.id.hashCode.abs();
    final km = ((hash % 30) + 1) / 10.0;
    return '${km.toStringAsFixed(1)} km';
  }

  static List<String> tags(Product p) {
    final hash = p.id.hashCode.abs();
    final tagSets = [
      ['Quiet', 'Snuggly', 'Indoor'],
      ['Playful', 'Energetic', 'Outdoor'],
      ['Friendly', 'Trained', 'Social'],
      ['Calm', 'Gentle', 'Loyal'],
      ['Active', 'Curious', 'Smart'],
    ];
    return tagSets[hash % tagSets.length];
  }

  static String about(Product p, [BuildContext? context]) {
    if (context != null && _isArabic(context) && p.descriptionAr.isNotEmpty) {
      return p.descriptionAr;
    }
    if (p.description.isNotEmpty) return p.description;
    return '${p.name} is a wonderful companion looking for a loving home. '
        'This adorable pet is well-trained, friendly with kids, and dreams of '
        'a family who loves adventures.';
  }

  static String priceLabel(Product p) => 'SAR ${p.price.toStringAsFixed(0)}';

  static String sex(Product p) {
    return p.id.hashCode.isEven ? 'Male' : 'Female';
  }

  static String age(Product p) {
    final hash = p.id.hashCode.abs();
    final years = (hash % 8) + 1;
    return '$years ${years == 1 ? 'year' : 'years'}';
  }

  static String species(Product p) {
    final slug = p.categorySlug.toLowerCase();
    if (slug.contains('dog') || slug.contains('canine')) return 'Dog';
    if (slug.contains('cat') || slug.contains('kitten') || slug.contains('feline')) return 'Cat';
    if (slug.contains('bird') || slug.contains('parrot') || slug.contains('avian')) return 'Bird';
    if (slug.contains('fish') || slug.contains('aqua')) return 'Fish';
    if (slug.contains('rabbit') || slug.contains('bunny')) return 'Rabbit';
    final hash = p.id.hashCode.abs();
    final types = ['Dog', 'Cat', 'Bird', 'Rabbit'];
    return types[hash % types.length];
  }

  static String subtitle(Product p) {
    return '${breed(p)} · ${age(p)} · ${sex(p)}';
  }

  // ─── Category → Pet Category Mapping ───

  static IconData categoryIcon(Category c) {
    final name = c.name.toLowerCase();
    if (name.contains('dog') || name.contains('canine')) return Icons.pets;
    if (name.contains('cat') || name.contains('kitten') || name.contains('feline')) return Icons.pets;
    if (name.contains('bird') || name.contains('parrot') || name.contains('avian')) return Icons.flutter_dash;
    if (name.contains('fish') || name.contains('aqua')) return Icons.water;
    if (name.contains('rabbit') || name.contains('bunny')) return Icons.cruelty_free;
    return Icons.pets;
  }

  /// Returns the localized category name, truncated for display.
  static String categoryLabel(Category c, [BuildContext? context]) {
    final name = (context != null && _isArabic(context) && c.nameAr.isNotEmpty)
        ? c.nameAr
        : c.name;
    if (name.length > 10) return '${name.substring(0, 10)}…';
    return name;
  }

  /// Returns the full localized category name (no truncation).
  static String categoryName(Category c, [BuildContext? context]) {
    if (context != null && _isArabic(context) && c.nameAr.isNotEmpty) {
      return c.nameAr;
    }
    return c.name;
  }
}
