// Feature: zoovana-app-ui, Property 13: Product badge priority

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:zoovana/app/data/models/product.dart';
import 'package:zoovana/app/widgets/product_badge.dart';

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Product _makeProduct({
  String id = 'p1',
  int stock = 5,
  double? compareAtPrice,
  bool isFeatured = false,
  DateTime? createdAt,
}) {
  return Product(
    id: id,
    name: 'Test',
    nameAr: 'اختبار',
    description: 'desc',
    descriptionAr: 'وصف',
    price: 10.0,
    compareAtPrice: compareAtPrice,
    imageUrl: '',
    imageUrls: [],
    categoryId: 'cat1',
    categorySlug: 'slug',
    stock: stock,
    isInStock: stock > 0,
    isActive: true,
    isFeatured: isFeatured,
    createdAt: createdAt ?? DateTime(2020),
  );
}

// ---------------------------------------------------------------------------
// Property 13: Product badge priority
// **Validates: Requirements 6.3**
//
// For any product, the ProductCard shall display exactly one badge following
// the priority:
//   Out of Stock (stock == 0)
//   > Sale (compareAtPrice != null)
//   > Featured (isFeatured == true)
//   > New (createdAt within 7 days)
// If none apply, no badge is shown.
// ---------------------------------------------------------------------------

void main() {
  group('Property 13: Product badge priority', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests for each badge type
    // -----------------------------------------------------------------------

    test('stock == 0 → outOfStock regardless of other flags', () {
      final product = _makeProduct(
        stock: 0,
        compareAtPrice: 20.0,
        isFeatured: true,
        createdAt: DateTime.now(),
      );
      expect(ProductBadge.resolve(product), BadgeType.outOfStock);
    });

    test('stock > 0, compareAtPrice != null → sale', () {
      final product = _makeProduct(
        stock: 5,
        compareAtPrice: 20.0,
        isFeatured: true,
        createdAt: DateTime.now(),
      );
      expect(ProductBadge.resolve(product), BadgeType.sale);
    });

    test('stock > 0, no sale, isFeatured → featured', () {
      final product = _makeProduct(
        stock: 5,
        compareAtPrice: null,
        isFeatured: true,
        createdAt: DateTime.now(),
      );
      expect(ProductBadge.resolve(product), BadgeType.featured);
    });

    test('stock > 0, no sale, not featured, createdAt within 7 days → new', () {
      final product = _makeProduct(
        stock: 5,
        compareAtPrice: null,
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      );
      expect(ProductBadge.resolve(product), BadgeType.newProduct);
    });

    test('createdAt exactly 7 days ago → new', () {
      final product = _makeProduct(
        stock: 5,
        compareAtPrice: null,
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      );
      expect(ProductBadge.resolve(product), BadgeType.newProduct);
    });

    test('createdAt 8 days ago → none', () {
      final product = _makeProduct(
        stock: 5,
        compareAtPrice: null,
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      expect(ProductBadge.resolve(product), BadgeType.none);
    });

    test('no conditions met → none', () {
      final product = _makeProduct(
        stock: 5,
        compareAtPrice: null,
        isFeatured: false,
        createdAt: DateTime(2020),
      );
      expect(ProductBadge.resolve(product), BadgeType.none);
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations with random product combinations
    // -----------------------------------------------------------------------

    test(
      'badge priority is correct across 100+ random product combinations',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var i = 0; i < iterations; i++) {
          // Randomly set each flag independently
          final stock = rng.nextBool() ? 0 : 1 + rng.nextInt(99);
          final compareAtPrice = rng.nextBool() ? 20.0 + rng.nextDouble() * 80 : null;
          final isFeatured = rng.nextBool();
          // createdAt: random between 0 and 14 days ago
          final daysAgo = rng.nextInt(15);
          final createdAt =
              DateTime.now().subtract(Duration(days: daysAgo));

          final product = _makeProduct(
            id: 'p$i',
            stock: stock,
            compareAtPrice: compareAtPrice,
            isFeatured: isFeatured,
            createdAt: createdAt,
          );

          final badge = ProductBadge.resolve(product);

          // Verify priority rules
          if (stock == 0) {
            expect(
              badge,
              BadgeType.outOfStock,
              reason:
                  'Iteration $i: stock==0 must yield outOfStock '
                  '(got $badge)',
            );
          } else if (compareAtPrice != null) {
            expect(
              badge,
              BadgeType.sale,
              reason:
                  'Iteration $i: compareAtPrice!=null must yield sale '
                  '(got $badge)',
            );
          } else if (isFeatured) {
            expect(
              badge,
              BadgeType.featured,
              reason:
                  'Iteration $i: isFeatured must yield featured '
                  '(got $badge)',
            );
          } else if (daysAgo <= 7) {
            expect(
              badge,
              BadgeType.newProduct,
              reason:
                  'Iteration $i: createdAt within 7 days must yield '
                  'newProduct (got $badge)',
            );
          } else {
            expect(
              badge,
              BadgeType.none,
              reason:
                  'Iteration $i: no conditions met must yield none '
                  '(got $badge)',
            );
          }
        }
      },
    );

    // -----------------------------------------------------------------------
    // OOS always wins regardless of other flags — 100 iterations
    // -----------------------------------------------------------------------

    test(
      'outOfStock always wins over all other flags — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var i = 0; i < iterations; i++) {
          final product = _makeProduct(
            id: 'oos$i',
            stock: 0,
            compareAtPrice: rng.nextBool() ? 20.0 : null,
            isFeatured: rng.nextBool(),
            createdAt: rng.nextBool()
                ? DateTime.now()
                : DateTime.now().subtract(const Duration(days: 3)),
          );

          expect(
            ProductBadge.resolve(product),
            BadgeType.outOfStock,
            reason:
                'Iteration $i: stock==0 must always yield outOfStock',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Sale wins over featured and new — 100 iterations
    // -----------------------------------------------------------------------

    test(
      'sale wins over featured and new when stock > 0 — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(13);

        for (var i = 0; i < iterations; i++) {
          final product = _makeProduct(
            id: 'sale$i',
            stock: 1 + rng.nextInt(99),
            compareAtPrice: 20.0 + rng.nextDouble() * 80,
            isFeatured: rng.nextBool(),
            createdAt: rng.nextBool()
                ? DateTime.now()
                : DateTime.now().subtract(const Duration(days: 3)),
          );

          expect(
            ProductBadge.resolve(product),
            BadgeType.sale,
            reason:
                'Iteration $i: compareAtPrice!=null must yield sale '
                'when stock > 0',
          );
        }
      },
    );
  });
}
