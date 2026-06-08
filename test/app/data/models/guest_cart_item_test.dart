// Feature: zoovana-app-ui, Property 29: Guest cart JSON schema
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/data/models/cart.dart';

/// **Validates: Requirements 17.2**
///
/// Property 29: Guest cart JSON schema
/// For any item added to the guest cart, the JSON object shall contain
/// the fields `product_id` (String), `quantity` (int), and `added_at` (ISO 8601 String).

void main() {
  group('Property 29: Guest cart JSON schema', () {
    final random = Random(42);

    // Generator: random alphanumeric product ID
    String randomProductId() {
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      final length = 8 + random.nextInt(16);
      return List.generate(length, (_) => chars[random.nextInt(chars.length)])
          .join();
    }

    // Generator: random positive quantity (1–100)
    int randomQuantity() => 1 + random.nextInt(100);

    // Generator: random DateTime within the last year
    DateTime randomDateTime() {
      final now = DateTime.now();
      final daysBack = random.nextInt(365);
      final secondsBack = random.nextInt(86400);
      return now
          .subtract(Duration(days: daysBack, seconds: secondsBack))
          .toUtc();
    }

    test('toJson produces correct field types across 100 iterations', () {
      for (int i = 0; i < 100; i++) {
        final productId = randomProductId();
        final quantity = randomQuantity();
        final addedAt = randomDateTime();

        final item = GuestCartItem(
          productId: productId,
          catalogId: productId,
          quantity: quantity,
          addedAt: addedAt,
        );

        final json = item.toJson();

        // product_id must be a String matching the input
        expect(json['product_id'], isA<String>(),
            reason: 'product_id must be a String (iteration $i)');
        expect(json['product_id'], equals(productId),
            reason: 'product_id must equal input (iteration $i)');

        // quantity must be an int matching the input
        expect(json['quantity'], isA<int>(),
            reason: 'quantity must be an int (iteration $i)');
        expect(json['quantity'], equals(quantity),
            reason: 'quantity must equal input (iteration $i)');

        // added_at must be a String in ISO 8601 format
        expect(json['added_at'], isA<String>(),
            reason: 'added_at must be a String (iteration $i)');
        final parsedDate = DateTime.tryParse(json['added_at'] as String);
        expect(parsedDate, isNotNull,
            reason: 'added_at must be a valid ISO 8601 string (iteration $i)');
        expect(parsedDate!.toUtc().millisecondsSinceEpoch,
            equals(addedAt.toUtc().millisecondsSinceEpoch),
            reason: 'added_at round-trip must preserve timestamp (iteration $i)');
      }
    });

    test('toJson contains exactly the required keys', () {
      for (int i = 0; i < 100; i++) {
        final item = GuestCartItem(
          productId: randomProductId(),
          catalogId: randomProductId(),
          quantity: randomQuantity(),
          addedAt: randomDateTime(),
        );

        final json = item.toJson();

        expect(json.containsKey('product_id'), isTrue,
            reason: 'JSON must contain product_id (iteration $i)');
        expect(json.containsKey('quantity'), isTrue,
            reason: 'JSON must contain quantity (iteration $i)');
        expect(json.containsKey('added_at'), isTrue,
            reason: 'JSON must contain added_at (iteration $i)');
      }
    });

    test('fromJson round-trip preserves all fields across 100 iterations', () {
      for (int i = 0; i < 100; i++) {
        final productId = randomProductId();
        final quantity = randomQuantity();
        final addedAt = randomDateTime();

        final original = GuestCartItem(
          productId: productId,
          catalogId: productId,
          quantity: quantity,
          addedAt: addedAt,
        );

        final restored = GuestCartItem.fromJson(original.toJson());

        expect(restored.productId, equals(productId),
            reason: 'productId round-trip failed (iteration $i)');
        expect(restored.quantity, equals(quantity),
            reason: 'quantity round-trip failed (iteration $i)');
        expect(restored.addedAt.toUtc().millisecondsSinceEpoch,
            equals(addedAt.toUtc().millisecondsSinceEpoch),
            reason: 'addedAt round-trip failed (iteration $i)');
      }
    });
  });
}
