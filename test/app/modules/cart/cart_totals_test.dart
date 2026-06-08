// Feature: zoovana-app-ui, Property 19: Cart totals completeness

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/data/models/cart.dart';
import 'package:zoovana/app/modules/cart/cart_screen.dart';

// ---------------------------------------------------------------------------
// Property 19: Cart totals completeness
// **Validates: Requirements 9.6**
//
// For any Cart object, the CartTotals widget shall display all four values:
// subtotal, discount, shipping, and grand total.
// ---------------------------------------------------------------------------

Cart _makeCart({
  required double subtotal,
  required double discount,
  required double shipping,
  required double total,
}) {
  return Cart(
    id: 'test-cart',
    status: 'active',
    items: [],
    itemCount: 0,
    subtotal: subtotal,
    discountAmount: discount,
    taxAmount: 0.0,
    total: total,
    currency: 'SAR',
  );
}

void main() {
  group('Property 19: Cart totals completeness', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests
    // -----------------------------------------------------------------------

    testWidgets('CartTotals shows subtotal label', (tester) async {
      final cart = _makeCart(
          subtotal: 100, discount: 10, shipping: 5, total: 95);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
      );
      expect(find.text('Subtotal'), findsOneWidget);
    });

    testWidgets('CartTotals shows discount label', (tester) async {
      final cart = _makeCart(
          subtotal: 100, discount: 10, shipping: 5, total: 95);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
      );
      expect(find.text('Discount'), findsOneWidget);
    });

    testWidgets('CartTotals shows shipping label', (tester) async {
      final cart = _makeCart(
          subtotal: 100, discount: 10, shipping: 5, total: 95);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
      );
      expect(find.text('Shipping'), findsOneWidget);
    });

    testWidgets('CartTotals shows total label', (tester) async {
      final cart = _makeCart(
          subtotal: 100, discount: 10, shipping: 5, total: 95);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
      );
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets('CartTotals shows all four labels at once', (tester) async {
      final cart = _makeCart(
          subtotal: 100, discount: 10, shipping: 5, total: 95);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
      );
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Discount'), findsOneWidget);
      expect(find.text('Shipping'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets('CartTotals shows subtotal value', (tester) async {
      final cart = _makeCart(
          subtotal: 123.45, discount: 0, shipping: 0, total: 123.45);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
      );
      expect(find.textContaining('123.45'), findsWidgets);
    });

    testWidgets('CartTotals shows free shipping when shipping is 0',
        (tester) async {
      final cart = _makeCart(
          subtotal: 100, discount: 0, shipping: 0, total: 100);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
      );
      expect(find.text('Free'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations
    //
    // For any Cart, CartTotals must display all 4 labels.
    // -----------------------------------------------------------------------

    testWidgets(
      'CartTotals always shows all 4 labels for 100 random carts',
      (tester) async {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          final subtotal = rng.nextDouble() * 1000;
          final discount = rng.nextDouble() * subtotal;
          final shipping = rng.nextBool() ? 0.0 : rng.nextDouble() * 50;
          final total = subtotal - discount + shipping;

          final cart = _makeCart(
            subtotal: subtotal,
            discount: discount,
            shipping: shipping,
            total: total,
          );

          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: CartTotals(cart: cart))),
          );

          expect(
            find.text('Subtotal'),
            findsOneWidget,
            reason: 'Iteration $iter: Subtotal label must be present',
          );
          expect(
            find.text('Discount'),
            findsOneWidget,
            reason: 'Iteration $iter: Discount label must be present',
          );
          expect(
            find.text('Shipping'),
            findsOneWidget,
            reason: 'Iteration $iter: Shipping label must be present',
          );
          expect(
            find.text('Total'),
            findsOneWidget,
            reason: 'Iteration $iter: Total label must be present',
          );
        }
      },
    );
  });
}
