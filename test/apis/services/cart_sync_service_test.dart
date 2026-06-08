// Feature: zoovana-app-ui, Property 31: Cart sync deduplication keeps higher quantity
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/data/models/cart.dart';
import 'package:zoovana/apis/services/cart_sync_service.dart';

/// **Validates: Requirements 17.4**
///
/// Property 31: Cart sync deduplication keeps higher quantity
/// For any guest cart G and auth cart A that share one or more product_id values,
/// the merged cart produced by CartSyncService.merge(G, A) shall contain each
/// shared product with quantity == max(G.quantity, A.quantity).

void main() {
  group('Property 31: Cart sync deduplication keeps higher quantity', () {
    final random = Random(42);

    // Generator: random alphanumeric product ID
    String randomProductId(int seed) {
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      final r = Random(seed);
      final length = 6 + r.nextInt(10);
      return List.generate(length, (_) => chars[r.nextInt(chars.length)]).join();
    }

    // Generator: random positive quantity (1–50)
    int randomQuantity() => 1 + random.nextInt(50);

    GuestCartItem makeGuestItem(String productId, int quantity) {
      return GuestCartItem(
        productId: productId,
        catalogId: productId,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
    }

    CartItem makeAuthItem(String productId, int quantity) {
      return CartItem(
        id: 'auth-$productId',
        productId: productId,
        productName: 'Product $productId',
        productNameAr: '',
        price: 10.0,
        quantity: quantity,
        imageUrl: '',
        stock: 100,
      );
    }

    test(
        'shared products get max(guestQty, authQty) across 100 iterations',
        () {
      for (int i = 0; i < 100; i++) {
        // Generate 1–5 shared product IDs
        final sharedCount = 1 + random.nextInt(5);
        final sharedIds =
            List.generate(sharedCount, (j) => randomProductId(i * 10 + j));

        // Generate quantities for each shared product
        final guestQtys = {for (final id in sharedIds) id: randomQuantity()};
        final authQtys = {for (final id in sharedIds) id: randomQuantity()};

        // Build guest and auth carts with shared products
        final guestCart =
            sharedIds.map((id) => makeGuestItem(id, guestQtys[id]!)).toList();
        final authCart =
            sharedIds.map((id) => makeAuthItem(id, authQtys[id]!)).toList();

        final merged = CartSyncService.merge(guestCart, authCart);

        // Verify each shared product has max quantity
        for (final id in sharedIds) {
          final mergedItem =
              merged.firstWhere((item) => item.productId == id);
          final expectedQty = max(guestQtys[id]!, authQtys[id]!);
          expect(
            mergedItem.quantity,
            equals(expectedQty),
            reason:
                'Iteration $i: product $id — expected max(${guestQtys[id]}, ${authQtys[id]}) = $expectedQty, got ${mergedItem.quantity}',
          );
        }
      }
    });

    test('guest-only products are preserved in merged result', () {
      for (int i = 0; i < 100; i++) {
        final guestOnlyId = randomProductId(i + 1000);
        final guestQty = randomQuantity();

        final guestCart = [makeGuestItem(guestOnlyId, guestQty)];
        final authCart = <CartItem>[];

        final merged = CartSyncService.merge(guestCart, authCart);

        expect(merged.length, equals(1),
            reason: 'Iteration $i: merged should have 1 item');
        expect(merged.first.productId, equals(guestOnlyId),
            reason: 'Iteration $i: product_id should be preserved');
        expect(merged.first.quantity, equals(guestQty),
            reason: 'Iteration $i: quantity should be preserved');
      }
    });

    test('auth-only products are added to merged result', () {
      for (int i = 0; i < 100; i++) {
        final authOnlyId = randomProductId(i + 2000);
        final authQty = randomQuantity();

        final guestCart = <GuestCartItem>[];
        final authCart = [makeAuthItem(authOnlyId, authQty)];

        final merged = CartSyncService.merge(guestCart, authCart);

        expect(merged.length, equals(1),
            reason: 'Iteration $i: merged should have 1 item');
        expect(merged.first.productId, equals(authOnlyId),
            reason: 'Iteration $i: product_id should be preserved');
        expect(merged.first.quantity, equals(authQty),
            reason: 'Iteration $i: quantity should be preserved');
      }
    });

    test('no duplicate product_ids in merged result across 100 iterations', () {
      for (int i = 0; i < 100; i++) {
        final sharedCount = 1 + random.nextInt(4);
        final guestOnlyCount = random.nextInt(3);
        final authOnlyCount = random.nextInt(3);

        final sharedIds =
            List.generate(sharedCount, (j) => randomProductId(i * 20 + j));
        final guestOnlyIds = List.generate(
            guestOnlyCount, (j) => randomProductId(i * 20 + 10 + j));
        final authOnlyIds = List.generate(
            authOnlyCount, (j) => randomProductId(i * 20 + 15 + j));

        final guestCart = [
          ...sharedIds.map((id) => makeGuestItem(id, randomQuantity())),
          ...guestOnlyIds.map((id) => makeGuestItem(id, randomQuantity())),
        ];
        final authCart = [
          ...sharedIds.map((id) => makeAuthItem(id, randomQuantity())),
          ...authOnlyIds.map((id) => makeAuthItem(id, randomQuantity())),
        ];

        final merged = CartSyncService.merge(guestCart, authCart);
        final productIds = merged.map((item) => item.productId).toList();
        final uniqueIds = productIds.toSet();

        expect(
          productIds.length,
          equals(uniqueIds.length),
          reason:
              'Iteration $i: merged result must not contain duplicate product_ids',
        );
      }
    });
  });
}
