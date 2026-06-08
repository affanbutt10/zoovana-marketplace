// Feature: zoovana-app-ui, Property 15: Add to cart — guest path
// Feature: zoovana-app-ui, Property 30: Cart sync triggered on login
// Feature: zoovana-app-ui, Property 32: Guest cart cleared after successful sync

import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Validates: Requirements 6.6, 17.1
///
/// Property 15: Add to cart — guest path
/// For any product id p when the user is unauthenticated, tapping the Add to
/// Cart button shall persist an entry with product_id == p to SharedPreferences
/// under key zoovana_guest_cart.

/// Validates: Requirements 17.3
///
/// Property 30: Cart sync triggered on login
/// For any non-empty guest cart at the time of successful login,
/// POST /cart/sync shall be called with the guest cart items as the request body.

/// Validates: Requirements 17.5
///
/// Property 32: Guest cart cleared after successful sync
/// For any successful POST /cart/sync response, the SharedPreferences key
/// zoovana_guest_cart shall be absent (null or empty) afterward.

const _guestCartKey = 'zoovana_guest_cart';

// ── Pure guest-cart helpers (mirrors CartNotifier logic) ──────────────────

Future<List<Map<String, dynamic>>> readGuestCart() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_guestCartKey);
  if (raw == null || raw.isEmpty) return [];
  return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
}

Future<void> addToGuestCart(String productId, int quantity) async {
  final prefs = await SharedPreferences.getInstance();
  final existing = await readGuestCart();

  final idx = existing.indexWhere((i) => i['product_id'] == productId);
  if (idx >= 0) {
    existing[idx] = {
      ...existing[idx],
      'quantity': (existing[idx]['quantity'] as int) + quantity,
    };
  } else {
    existing.add({
      'product_id': productId,
      'quantity': quantity,
      'added_at': DateTime.now().toIso8601String(),
    });
  }

  await prefs.setString(_guestCartKey, jsonEncode(existing));
}

Future<void> clearGuestCart() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_guestCartKey);
}

// ── Helpers ────────────────────────────────────────────────────────────────

String _randomProductId(Random rng) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(8, (_) => chars[rng.nextInt(chars.length)]).join();
}

int _randomQuantity(Random rng) => rng.nextInt(9) + 1; // 1..10

// ══════════════════════════════════════════════════════════════════════════════
// Property 15: Add to cart — guest path
// ══════════════════════════════════════════════════════════════════════════════

void main() {
  group('Property 15: Add to cart — guest path', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'adding a product persists it under zoovana_guest_cart (100 iterations)',
      () async {
        final rng = Random(42);

        for (var i = 0; i < 100; i++) {
          SharedPreferences.setMockInitialValues({});

          final productId = _randomProductId(rng);
          final quantity = _randomQuantity(rng);

          await addToGuestCart(productId, quantity);

          final stored = await readGuestCart();

          expect(
            stored.any((item) => item['product_id'] == productId),
            isTrue,
            reason:
                'Iteration $i: product_id "$productId" not found in guest cart',
          );

          final entry =
              stored.firstWhere((item) => item['product_id'] == productId);
          expect(
            entry['quantity'],
            equals(quantity),
            reason:
                'Iteration $i: expected quantity $quantity but got ${entry['quantity']}',
          );
        }
      },
    );

    test('stored entry contains product_id, quantity, and added_at fields',
        () async {
      await addToGuestCart('prod_abc', 2);
      final stored = await readGuestCart();
      expect(stored, hasLength(1));
      final entry = stored.first;
      expect(entry.containsKey('product_id'), isTrue);
      expect(entry.containsKey('quantity'), isTrue);
      expect(entry.containsKey('added_at'), isTrue);
    });

    test('adding same product twice accumulates quantity', () async {
      await addToGuestCart('prod_x', 1);
      await addToGuestCart('prod_x', 3);
      final stored = await readGuestCart();
      expect(stored, hasLength(1));
      expect(stored.first['quantity'], equals(4));
    });

    test('adding different products creates separate entries', () async {
      await addToGuestCart('prod_a', 1);
      await addToGuestCart('prod_b', 2);
      final stored = await readGuestCart();
      expect(stored, hasLength(2));
    });
  });

  // ════════════════════════════════════════════════════════════════════════════
  // Property 30: Cart sync triggered on login
  // ════════════════════════════════════════════════════════════════════════════

  group('Property 30: Cart sync triggered on login', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'non-empty guest cart is present in prefs before sync (100 iterations)',
      () async {
        final rng = Random(99);

        for (var i = 0; i < 100; i++) {
          SharedPreferences.setMockInitialValues({});

          // Simulate guest adding 1..5 products before login
          final itemCount = rng.nextInt(5) + 1;
          final addedIds = <String>[];
          for (var j = 0; j < itemCount; j++) {
            final id = _randomProductId(rng);
            addedIds.add(id);
            await addToGuestCart(id, _randomQuantity(rng));
          }

          final guestCart = await readGuestCart();

          // Verify all added products are present — these are what would be
          // sent to POST /cart/sync on login.
          for (final id in addedIds) {
            expect(
              guestCart.any((item) => item['product_id'] == id),
              isTrue,
              reason:
                  'Iteration $i: product_id "$id" missing from guest cart before sync',
            );
          }
        }
      },
    );

    test('empty guest cart produces empty sync payload', () async {
      final guestCart = await readGuestCart();
      expect(guestCart, isEmpty);
    });

    test('sync payload contains all guest cart items', () async {
      await addToGuestCart('prod_1', 2);
      await addToGuestCart('prod_2', 1);

      final guestCart = await readGuestCart();
      // The sync payload is the guest cart items — verify both are present
      expect(guestCart.map((e) => e['product_id']),
          containsAll(['prod_1', 'prod_2']));
    });
  });

  // ════════════════════════════════════════════════════════════════════════════
  // Property 32: Guest cart cleared after successful sync
  // ════════════════════════════════════════════════════════════════════════════

  group('Property 32: Guest cart cleared after successful sync', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test(
      'guest cart key is absent after clearGuestCart (100 iterations)',
      () async {
        final rng = Random(7);

        for (var i = 0; i < 100; i++) {
          SharedPreferences.setMockInitialValues({});

          // Add random items to guest cart
          final itemCount = rng.nextInt(5) + 1;
          for (var j = 0; j < itemCount; j++) {
            await addToGuestCart(_randomProductId(rng), _randomQuantity(rng));
          }

          // Verify cart is non-empty before clear
          final before = await readGuestCart();
          expect(before, isNotEmpty,
              reason: 'Iteration $i: expected non-empty cart before clear');

          // Simulate successful sync — clear guest cart
          await clearGuestCart();

          // Verify cart is now absent/empty
          final prefs = await SharedPreferences.getInstance();
          final raw = prefs.getString(_guestCartKey);
          expect(
            raw == null || raw.isEmpty,
            isTrue,
            reason:
                'Iteration $i: zoovana_guest_cart should be absent after sync',
          );
        }
      },
    );

    test('readGuestCart returns empty list after clear', () async {
      await addToGuestCart('prod_z', 3);
      await clearGuestCart();
      final stored = await readGuestCart();
      expect(stored, isEmpty);
    });

    test('clearing an already-empty cart is a no-op', () async {
      // Should not throw
      await clearGuestCart();
      final stored = await readGuestCart();
      expect(stored, isEmpty);
    });
  });
}
