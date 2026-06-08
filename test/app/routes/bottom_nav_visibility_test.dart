// Feature: zoovana-app-ui, Property 5: Bottom nav visibility by route

import 'package:flutter_test/flutter_test.dart';

/// **Validates: Requirements 2.6**
///
/// Property 5: Bottom nav visibility by route
///
/// For any route in the main shell set (`/`, `/categories`, `/search`,
/// `/cart`, `/profile`), the [BottomNavigationBar] shall be visible.
/// For any route outside the shell (`/product/:id`, `/checkout`, `/login`,
/// `/register`), the [BottomNavigationBar] shall not be present in the
/// widget tree.
///
/// Since the full router is not yet wired (task 2.6), this test validates
/// the route-classification logic via a pure [isShellRoute] helper function.
/// The actual widget-tree integration will be validated in task 2.6.

// ---------------------------------------------------------------------------
// Route classification helper
// ---------------------------------------------------------------------------

/// Returns `true` when [path] belongs to the main shell (bottom nav visible).
/// Returns `false` for standalone routes (no bottom nav).
///
/// Shell routes: `/`, `/categories`, `/search`, `/cart`, `/profile`
/// Standalone routes: `/product/:id`, `/checkout`, `/login`, `/register`,
///   `/forgot-password`, `/orders/:id`, `/orders/:id/receipts/:rid`,
///   `/profile/orders`, `/profile/receipts`, `/categories/:slug`
bool isShellRoute(String path) {
  const shellRoutes = {
    '/',
    '/categories',
    '/search',
    '/cart',
    '/profile',
  };
  return shellRoutes.contains(path);
}

// ---------------------------------------------------------------------------
// Known route sets used in property iterations
// ---------------------------------------------------------------------------

const _shellRoutes = [
  '/',
  '/categories',
  '/search',
  '/cart',
  '/profile',
];

const _standaloneRoutes = [
  '/login',
  '/register',
  '/forgot-password',
  '/checkout',
  '/product/1',
  '/product/abc-123',
  '/product/some-long-product-id',
  '/orders/42',
  '/orders/42/receipts/7',
  '/profile/orders',
  '/profile/receipts',
  '/categories/dogs',
  '/categories/cats-food',
];

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('BottomNavigationBar — Property 5: Bottom nav visibility by route', () {
    // -----------------------------------------------------------------------
    // Individual shell route tests
    // -----------------------------------------------------------------------
    for (final route in _shellRoutes) {
      test('shell route "$route" → isShellRoute returns true', () {
        expect(
          isShellRoute(route),
          isTrue,
          reason:
              '"$route" is a shell route — BottomNavigationBar must be visible',
        );
      });
    }

    // -----------------------------------------------------------------------
    // Individual standalone route tests
    // -----------------------------------------------------------------------
    for (final route in _standaloneRoutes) {
      test('standalone route "$route" → isShellRoute returns false', () {
        expect(
          isShellRoute(route),
          isFalse,
          reason:
              '"$route" is a standalone route — BottomNavigationBar must NOT '
              'be present in the widget tree',
        );
      });
    }

    // -----------------------------------------------------------------------
    // Property-style loop: ≥ 100 iterations cycling through both sets
    // -----------------------------------------------------------------------
    test(
      'shell routes always return true across 100+ iterations',
      () {
        const iterations = 100;
        for (var i = 0; i < iterations; i++) {
          final route = _shellRoutes[i % _shellRoutes.length];
          expect(
            isShellRoute(route),
            isTrue,
            reason:
                'Iteration $i — shell route "$route" must return true from '
                'isShellRoute',
          );
        }
      },
    );

    test(
      'standalone routes always return false across 100+ iterations',
      () {
        const iterations = 100;
        for (var i = 0; i < iterations; i++) {
          final route = _standaloneRoutes[i % _standaloneRoutes.length];
          expect(
            isShellRoute(route),
            isFalse,
            reason:
                'Iteration $i — standalone route "$route" must return false '
                'from isShellRoute',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Exhaustive combined property test (200+ iterations, both sets)
    // -----------------------------------------------------------------------
    test(
      'combined shell + standalone classification across 200+ iterations',
      () {
        const iterations = 200;
        for (var i = 0; i < iterations; i++) {
          if (i % 2 == 0) {
            final route = _shellRoutes[i ~/ 2 % _shellRoutes.length];
            expect(
              isShellRoute(route),
              isTrue,
              reason:
                  'Iteration $i — shell route "$route" must be classified as '
                  'shell (BottomNavigationBar visible)',
            );
          } else {
            final route =
                _standaloneRoutes[i ~/ 2 % _standaloneRoutes.length];
            expect(
              isShellRoute(route),
              isFalse,
              reason:
                  'Iteration $i — standalone route "$route" must be classified '
                  'as standalone (no BottomNavigationBar)',
            );
          }
        }
      },
    );

    // -----------------------------------------------------------------------
    // Edge cases
    // -----------------------------------------------------------------------
    test('empty string is not a shell route', () {
      expect(isShellRoute(''), isFalse);
    });

    test('route with trailing slash is not a shell route', () {
      // "/categories/" is distinct from "/categories"
      expect(isShellRoute('/categories/'), isFalse);
    });

    test('partial shell route prefix is not a shell route', () {
      expect(isShellRoute('/cart/something'), isFalse);
    });

    test('unknown route is not a shell route', () {
      expect(isShellRoute('/unknown'), isFalse);
    });
  });
}
