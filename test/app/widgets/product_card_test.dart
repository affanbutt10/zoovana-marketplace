// Feature: zoovana-app-ui, Property 12: Product card compare-at price display
// Feature: zoovana-app-ui, Property 14: Add to cart — authenticated path

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zoovana/app/data/models/product.dart';
import 'package:zoovana/app/widgets/product_card.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Product _makeProduct({
  String id = 'p1',
  double price = 10.0,
  double? compareAtPrice,
  int stock = 5,
  bool isFeatured = false,
  DateTime? createdAt,
}) {
  return Product(
    id: id,
    name: 'Test Product',
    nameAr: 'منتج تجريبي',
    description: 'desc',
    descriptionAr: 'وصف',
    price: price,
    compareAtPrice: compareAtPrice,
    imageUrl: '',
    imageUrls: [],
    categoryId: 'cat1',
    categorySlug: 'cat-slug',
    stock: stock,
    isInStock: stock > 0,
    isActive: true,
    isFeatured: isFeatured,
    createdAt: createdAt ?? DateTime(2020),
  );
}

// ---------------------------------------------------------------------------
// Pump helper
// ---------------------------------------------------------------------------

Future<void> _pumpCard(
  WidgetTester tester,
  Product product, {
  bool authenticated = false,
  Future<void> Function(String productId, int quantity)? onAddToCart,
  Future<void> Function(String productId, int quantity)? onAddToGuestCart,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ProductCard(
          product: product,
          isAuthenticated: authenticated,
          onAddToCartAuthenticated: onAddToCart,
          onAddToGuestCart: onAddToGuestCart,
        ),
      ),
    ),
  );
  await tester.pump();
}

// ===========================================================================
// Tests
// ===========================================================================

void main() {
  // Suppress image codec errors (SVG assets not available in test environment)
  setUp(() {
    FlutterError.onError = (details) {
      if (details.exception.toString().contains('Invalid image data') ||
          details.exception.toString().contains('image codec')) {
        return; // ignore image loading errors in tests
      }
      FlutterError.presentError(details);
    };
  });

  tearDown(() {
    FlutterError.onError = FlutterError.presentError;
  });

  // =========================================================================
  // Property 12: Product card compare-at price display
  // **Validates: Requirements 6.2**
  //
  // For any product where compareAtPrice != null, the ProductCard shall display
  // compareAtPrice with TextDecoration.lineThrough.
  // =========================================================================

  group('Property 12: Product card compare-at price display', () {
    testWidgets(
      'compare-at price shown with lineThrough when non-null — 100 iterations',
      (tester) async {
        const iterations = 100;
        final rng = Random(42);

        for (var i = 0; i < iterations; i++) {
          final price = 10.0 + rng.nextDouble() * 90;
          final compareAt = price + 1.0 + rng.nextDouble() * 50;

          final product = _makeProduct(
            id: 'p$i',
            price: price,
            compareAtPrice: compareAt,
          );

          await _pumpCard(tester, product);

          final compareAtText = 'SAR ${compareAt.toStringAsFixed(2)}';

          // The compare-at price text must be present
          expect(
            find.text(compareAtText),
            findsOneWidget,
            reason:
                'Iteration $i: compare-at price "$compareAtText" must be '
                'displayed',
          );

          // The Text widget must have lineThrough decoration
          final textWidgets =
              tester.widgetList<Text>(find.text(compareAtText)).toList();
          expect(
            textWidgets,
            isNotEmpty,
            reason: 'Iteration $i: Text widget for compare-at must exist',
          );
          for (final tw in textWidgets) {
            expect(
              tw.style?.decoration,
              TextDecoration.lineThrough,
              reason:
                  'Iteration $i: compare-at price must have '
                  'TextDecoration.lineThrough',
            );
          }
        }
      },
    );

    testWidgets(
      'no lineThrough text when compareAtPrice is null — 100 iterations',
      (tester) async {
        const iterations = 100;
        final rng = Random(7);

        for (var i = 0; i < iterations; i++) {
          final price = 10.0 + rng.nextDouble() * 90;
          final product = _makeProduct(
            id: 'p$i',
            price: price,
            compareAtPrice: null,
          );

          await _pumpCard(tester, product);

          final strikeThroughTexts = tester
              .widgetList<Text>(find.byType(Text))
              .where(
                  (tw) => tw.style?.decoration == TextDecoration.lineThrough)
              .toList();

          expect(
            strikeThroughTexts,
            isEmpty,
            reason:
                'Iteration $i: no lineThrough text should appear when '
                'compareAtPrice is null',
          );
        }
      },
    );
  });

  // =========================================================================
  // Property 14: Add to cart — authenticated path
  // **Validates: Requirements 6.5**
  //
  // For any product id p and authenticated session, tapping the Add to Cart
  // button on ProductCard shall invoke the authenticated cart action with p.
  // =========================================================================

  group('Property 14: Add to cart — authenticated path', () {
    testWidgets(
      'tapping Add to Cart when authenticated calls addToCart — 100 iterations',
      (tester) async {
        const iterations = 100;
        final rng = Random(13);

        for (var i = 0; i < iterations; i++) {
          final productId = 'product-${rng.nextInt(100000)}';
          final product = _makeProduct(
            id: productId,
            stock: 1 + rng.nextInt(99),
          );

          final addedIds = <String>[];
          await _pumpCard(
            tester,
            product,
            authenticated: true,
            onAddToCart: (productId, quantity) async {
              addedIds.add(productId);
            },
          );
          await tester.pump();

          final addBtn = find.byIcon(Icons.add_shopping_cart);
          expect(addBtn, findsOneWidget,
              reason: 'Iteration $i: Add to Cart button must be present');

          await tester.tap(addBtn);
          await tester.pump();

          expect(
            addedIds,
            contains(productId),
            reason:
                'Iteration $i: addToCart must be called with product id '
                '"$productId" when authenticated',
          );
        }
      },
    );

    testWidgets(
      'Add to Cart button is disabled when stock == 0 — 100 iterations',
      (tester) async {
        const iterations = 100;
        final rng = Random(99);

        for (var i = 0; i < iterations; i++) {
          final product = _makeProduct(
            id: 'oos-$i',
            stock: 0,
            compareAtPrice: rng.nextBool() ? 20.0 : null,
            isFeatured: rng.nextBool(),
          );

          await _pumpCard(tester, product, authenticated: true);

          final btn = tester.widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.add_shopping_cart),
          );
          expect(
            btn.onPressed,
            isNull,
            reason:
                'Iteration $i: Add to Cart must be disabled when stock == 0',
          );
        }
      },
    );
  });
}
