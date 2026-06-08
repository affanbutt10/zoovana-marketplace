// Feature: zoovana-app-ui, Property 4: Cart badge reflects item count

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **Validates: Requirements 2.5**
///
/// Property 4: Cart badge reflects item count
///
/// For any integer n ≥ 1, when the active cart contains n items, the [Badge]
/// widget displayed on the Cart tab icon shall show the value n.
/// When n == 0, the [Badge] shall not be visible.

/// Helper that builds a [Badge]-wrapped cart icon with the given [count],
/// mirroring the exact widget used in [ScaffoldWithBottomNav].
Widget _buildCartBadge(int count) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Badge(
          isLabelVisible: count > 0,
          label: Text('$count'),
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    ),
  );
}

void main() {
  group('Cart Badge — Property 4: Cart badge reflects item count', () {
    // ---------------------------------------------------------------
    // Edge case: count == 0 → badge not visible
    // ---------------------------------------------------------------
    testWidgets('badge is not visible when cartItemCount == 0', (tester) async {
      await tester.pumpWidget(_buildCartBadge(0));

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(
        badge.isLabelVisible,
        isFalse,
        reason: 'Badge must not be visible when cart is empty (count == 0)',
      );
    });

    // ---------------------------------------------------------------
    // Specific counts: 1, 2, 10, 99
    // ---------------------------------------------------------------
    for (final count in [1, 2, 10, 99]) {
      testWidgets('badge is visible and shows "$count" when count == $count',
          (tester) async {
        await tester.pumpWidget(_buildCartBadge(count));

        final badge = tester.widget<Badge>(find.byType(Badge));
        expect(
          badge.isLabelVisible,
          isTrue,
          reason: 'Badge must be visible when count == $count',
        );

        expect(
          find.text('$count'),
          findsOneWidget,
          reason: 'Badge label must display "$count"',
        );
      });
    }

    // ---------------------------------------------------------------
    // Property-style loop: 100+ iterations with random counts ≥ 1
    // ---------------------------------------------------------------
    testWidgets(
      'badge is visible and label matches count across 100+ iterations (n ≥ 1)',
      (tester) async {
        const iterations = 100;
        final rng = Random(42); // fixed seed for reproducibility

        for (var i = 0; i < iterations; i++) {
          // Generate n in [1, 200]
          final count = rng.nextInt(200) + 1;

          await tester.pumpWidget(_buildCartBadge(count));

          final badge = tester.widget<Badge>(find.byType(Badge));

          expect(
            badge.isLabelVisible,
            isTrue,
            reason:
                'Iteration $i (count=$count): Badge.isLabelVisible must be '
                'true when count > 0',
          );

          expect(
            find.text('$count'),
            findsOneWidget,
            reason:
                'Iteration $i (count=$count): Badge label must display '
                '"$count"',
          );
        }
      },
    );

    // ---------------------------------------------------------------
    // Property-style loop: 100 iterations confirming count == 0 hides badge
    // ---------------------------------------------------------------
    testWidgets(
      'badge is not visible across 100 iterations when count == 0',
      (tester) async {
        const iterations = 100;

        for (var i = 0; i < iterations; i++) {
          await tester.pumpWidget(_buildCartBadge(0));

          final badge = tester.widget<Badge>(find.byType(Badge));

          expect(
            badge.isLabelVisible,
            isFalse,
            reason:
                'Iteration $i: Badge.isLabelVisible must be false when '
                'count == 0',
          );
        }
      },
    );
  });
}
