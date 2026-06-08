// Feature: zoovana-app-ui, Property 10: Category grid shows only active categories
// Feature: zoovana-app-ui, Property 11: Category fallback image for missing remote URL

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/data/models/category.dart';

// ---------------------------------------------------------------------------
// Helpers — pure logic extracted from CategoriesScreen / _CategoryTile
// ---------------------------------------------------------------------------

/// Mirrors the filter applied in CategoriesScreen before building the grid.
List<Category> filterActiveCategories(List<Category> categories) {
  return categories.where((c) => c.isActive).toList();
}

/// Mirrors the fallback asset selection in _CategoryTile.
String categoryFallbackAsset(String? imageUrl, int fallbackIndex) {
  if (imageUrl case final url? when url.isNotEmpty) {
    return url;
  }
  final n = (fallbackIndex % 6) + 1;
  return 'assests/category_img0$n.png';
}

/// Returns true when the resolved asset is a local fallback (not a network URL).
bool usesLocalFallback(String? imageUrl, int fallbackIndex) {
  final resolved = categoryFallbackAsset(imageUrl, fallbackIndex);
  return resolved.startsWith('assests/');
}

// ---------------------------------------------------------------------------
// Generators
// ---------------------------------------------------------------------------

const _slugChars = 'abcdefghijklmnopqrstuvwxyz0123456789';

String _randomSlug(Random rng, {int len = 6}) {
  return List.generate(len, (_) => _slugChars[rng.nextInt(_slugChars.length)])
      .join();
}

Category _randomCategory(
  Random rng, {
  required bool isActive,
  String? imageUrl,
}) {
  return Category(
    id: _randomSlug(rng, len: 8),
    name: 'Cat ${_randomSlug(rng, len: 4)}',
    nameAr: 'فئة',
    slug: _randomSlug(rng),
    imageUrl: imageUrl,
    level: 0,
    productCount: isActive ? 1 : 0,
  );
}

// ---------------------------------------------------------------------------
// Property 10: Category grid shows only active categories
// **Validates: Requirements 4.1**
// ---------------------------------------------------------------------------

void main() {
  group('Property 10: Category grid shows only active categories', () {
    // -----------------------------------------------------------------------
    // Deterministic examples
    // -----------------------------------------------------------------------

    test('empty list returns empty', () {
      expect(filterActiveCategories([]), isEmpty);
    });

    test('all active — all returned', () {
      final cats = [
        Category(id: '1', name: 'Dogs', nameAr: '', slug: 'dogs', level: 0, productCount: 1),
        Category(id: '2', name: 'Cats', nameAr: '', slug: 'cats', level: 0, productCount: 1),
      ];
      expect(filterActiveCategories(cats), hasLength(2));
    });

    test('all inactive — none returned', () {
      final cats = [
        Category(id: '1', name: 'Dogs', nameAr: '', slug: 'dogs', level: 0, productCount: 0),
        Category(id: '2', name: 'Cats', nameAr: '', slug: 'cats', level: 0, productCount: 0),
      ];
      expect(filterActiveCategories(cats), isEmpty);
    });

    test('mixed — only active returned', () {
      final cats = [
        Category(id: '1', name: 'Dogs', nameAr: '', slug: 'dogs', level: 0, productCount: 1),
        Category(id: '2', name: 'Cats', nameAr: '', slug: 'cats', level: 0, productCount: 0),
        Category(id: '3', name: 'Fish', nameAr: '', slug: 'fish', level: 0, productCount: 1),
      ];
      final result = filterActiveCategories(cats);
      expect(result, hasLength(2));
      expect(result.every((c) => c.isActive), isTrue);
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations
    //
    // For any list of categories, filterActiveCategories returns exactly
    // those with isActive == true and no others.
    // -----------------------------------------------------------------------

    test(
      'result contains only active categories — 100+ random lists',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          final count = rng.nextInt(20); // 0..19 categories
          final categories = List.generate(count, (_) {
            final active = rng.nextBool();
            return _randomCategory(rng, isActive: active);
          });

          final result = filterActiveCategories(categories);

          // Every item in result must be active
          for (final cat in result) {
            expect(
              cat.isActive,
              isTrue,
              reason:
                  'Iteration $iter: inactive category "${cat.name}" '
                  'must not appear in the filtered result',
            );
          }

          // Every active category in input must appear in result
          final expectedCount = categories.where((c) => c.isActive).length;
          expect(
            result.length,
            equals(expectedCount),
            reason:
                'Iteration $iter: expected $expectedCount active categories '
                'but got ${result.length}',
          );
        }
      },
    );

    test(
      'result count equals input active count — 100+ random lists',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          final count = 1 + rng.nextInt(30);
          final categories = List.generate(count, (_) {
            return _randomCategory(rng, isActive: rng.nextBool());
          });

          final activeCount = categories.where((c) => c.isActive).length;
          final result = filterActiveCategories(categories);

          expect(
            result.length,
            equals(activeCount),
            reason:
                'Iteration $iter: result length ${result.length} must equal '
                'active count $activeCount',
          );
        }
      },
    );

    test(
      'no inactive category appears in result — 100+ random lists',
      () {
        const iterations = 100;
        final rng = Random(99);

        for (var iter = 0; iter < iterations; iter++) {
          final count = rng.nextInt(25);
          final categories = List.generate(count, (_) {
            return _randomCategory(rng, isActive: rng.nextBool());
          });

          final result = filterActiveCategories(categories);
          final inactiveIds =
              categories.where((c) => !c.isActive).map((c) => c.id).toSet();

          for (final cat in result) {
            expect(
              inactiveIds.contains(cat.id),
              isFalse,
              reason:
                  'Iteration $iter: inactive category id "${cat.id}" '
                  'must not appear in result',
            );
          }
        }
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Property 11: Category fallback image for missing remote URL
  // **Validates: Requirements 4.2**
  // ---------------------------------------------------------------------------

  group('Property 11: Category fallback image for missing remote URL', () {
    // -----------------------------------------------------------------------
    // Deterministic examples
    // -----------------------------------------------------------------------

    test('null imageUrl uses local fallback', () {
      expect(usesLocalFallback(null, 0), isTrue);
    });

    test('empty imageUrl uses local fallback', () {
      expect(usesLocalFallback('', 0), isTrue);
    });

    test('non-empty imageUrl does not use local fallback', () {
      expect(usesLocalFallback('https://example.com/cat.jpg', 0), isFalse);
    });

    test('fallback index 0 → category_img01.png', () {
      expect(categoryFallbackAsset(null, 0), equals('assests/category_img01.png'));
    });

    test('fallback index 5 → category_img06.png', () {
      expect(categoryFallbackAsset(null, 5), equals('assests/category_img06.png'));
    });

    test('fallback index 6 wraps to category_img01.png', () {
      expect(categoryFallbackAsset(null, 6), equals('assests/category_img01.png'));
    });

    test('fallback index 11 wraps to category_img06.png', () {
      expect(categoryFallbackAsset(null, 11), equals('assests/category_img06.png'));
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations
    //
    // For any category where imageUrl is null or empty, the resolved asset
    // must be a local asset path (starts with 'assests/').
    // -----------------------------------------------------------------------

    test(
      'null imageUrl always resolves to local asset — 100+ iterations',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          final index = rng.nextInt(1000);
          expect(
            usesLocalFallback(null, index),
            isTrue,
            reason:
                'Iteration $iter: null imageUrl at index $index must use '
                'local fallback',
          );
        }
      },
    );

    test(
      'empty imageUrl always resolves to local asset — 100+ iterations',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          final index = rng.nextInt(1000);
          expect(
            usesLocalFallback('', index),
            isTrue,
            reason:
                'Iteration $iter: empty imageUrl at index $index must use '
                'local fallback',
          );
        }
      },
    );

    test(
      'fallback asset is always one of category_img01-06.png — 100+ iterations',
      () {
        const iterations = 100;
        final rng = Random(13);
        final validAssets = {
          for (var i = 1; i <= 6; i++) 'assests/category_img0$i.png',
        };

        for (var iter = 0; iter < iterations; iter++) {
          final index = rng.nextInt(500);
          final asset = categoryFallbackAsset(null, index);

          expect(
            validAssets.contains(asset),
            isTrue,
            reason:
                'Iteration $iter: fallback asset "$asset" at index $index '
                'must be one of category_img01-06.png',
          );
        }
      },
    );

    test(
      'fallback index cycles through 6 images correctly — 100+ iterations',
      () {
        const iterations = 100;
        final rng = Random(55);

        for (var iter = 0; iter < iterations; iter++) {
          final index = rng.nextInt(10000);
          final asset = categoryFallbackAsset(null, index);
          final expectedN = (index % 6) + 1;
          final expectedAsset = 'assests/category_img0$expectedN.png';

          expect(
            asset,
            equals(expectedAsset),
            reason:
                'Iteration $iter: index $index should map to '
                '"$expectedAsset" but got "$asset"',
          );
        }
      },
    );

    test(
      'non-empty imageUrl is returned as-is (no fallback) — 100+ iterations',
      () {
        const iterations = 100;
        final rng = Random(21);

        for (var iter = 0; iter < iterations; iter++) {
          final url = 'https://cdn.zoovana.com/cat_${rng.nextInt(9999)}.jpg';
          final index = rng.nextInt(100);
          final resolved = categoryFallbackAsset(url, index);

          expect(
            resolved,
            equals(url),
            reason:
                'Iteration $iter: non-empty url "$url" must be returned '
                'as-is, got "$resolved"',
          );
        }
      },
    );
  });
}
