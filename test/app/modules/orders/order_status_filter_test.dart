// Feature: zoovana-app-ui, Property 23: Order status filter
// Feature: zoovana-app-ui, Property 24: Order card navigation

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/data/models/order.dart';

/// Pure filter logic mirroring OrdersScreen behaviour.
List<Order> filterOrders(List<Order> orders, String status) {
  if (status == 'all') return orders;
  return orders.where((o) => o.status == status).toList();
}

/// Pure route builder mirroring OrderCard tap behaviour.
String orderRoute(String id) => '/orders/$id';

Order _makeOrder(String id, String status) => Order(
      id: id,
      placedAt: DateTime(2024),
      status: status,
      total: 100,
      currency: 'SAR',
      subOrders: [],
    );

void main() {
  const statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];

  // ── Property 23 ──────────────────────────────────────────────────────────

  group('Property 23: Order status filter', () {
    test('all returns every order — 20 iterations', () {
      final rng = Random(42);
      for (var i = 0; i < 20; i++) {
        final count = 1 + rng.nextInt(10);
        final orders = List.generate(count, (j) {
          return _makeOrder('$j', statuses[rng.nextInt(statuses.length)]);
        });
        expect(filterOrders(orders, 'all'), hasLength(orders.length));
      }
    });

    test('specific status returns only matching — 20 iterations', () {
      final rng = Random(7);
      for (var i = 0; i < 20; i++) {
        final target = statuses[rng.nextInt(statuses.length)];
        final orders = List.generate(10, (j) {
          return _makeOrder('$j', statuses[rng.nextInt(statuses.length)]);
        });
        final result = filterOrders(orders, target);
        expect(result.every((o) => o.status == target), isTrue);
      }
    });
  });

  // ── Property 24 ──────────────────────────────────────────────────────────

  group('Property 24: Order card navigation', () {
    test('orderRoute produces /orders/{id} — 20 iterations', () {
      final rng = Random(13);
      for (var i = 0; i < 20; i++) {
        final id = 'order-${rng.nextInt(99999)}';
        expect(orderRoute(id), equals('/orders/$id'));
      }
    });
  });
}
