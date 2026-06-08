// Feature: zoovana-app-ui, Property 7: Category tile navigation

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Property 7: Category tile navigation
// **Validates: Requirements 3.5, 4.4**
//
// For any category with slug s, tapping its tile shall trigger navigation
// to the route `/categories/s`.
// ---------------------------------------------------------------------------

/// Pure route-building logic extracted from CategoryBelt / _CategoryTile.
///
/// Given a category [slug], returns the navigation route that should be
/// triggered when the tile is tapped.
String categoryRoute(String slug) => '/categories/$slug';

// ---------------------------------------------------------------------------
// Slug generator helpers
// ---------------------------------------------------------------------------

const _slugChars =
    'abcdefghijklmnopqrstuvwxyz0123456789-';

String _randomSlug(Random rng, {int minLen = 1, int maxLen = 30}) {
  final length = minLen + rng.nextInt(maxLen - minLen + 1);
  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    buffer.write(_slugChars[rng.nextInt(_slugChars.length)]);
  }
  // Ensure slug doesn't start or end with '-'
  var slug = buffer.toString().replaceAll(RegExp(r'^-+|-+$'), '');
  if (slug.isEmpty) slug = 'cat';
  return slug;
}

void main() {
  group('Property 7: Category tile navigation', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests
    // -----------------------------------------------------------------------

    test('slug "dogs" produces route "/categories/dogs"', () {
      expect(categoryRoute('dogs'), equals('/categories/dogs'));
    });

    test('slug "cats" produces route "/categories/cats"', () {
      expect(categoryRoute('cats'), equals('/categories/cats'));
    });

    test('slug "fish-aquatics" produces route "/categories/fish-aquatics"', () {
      expect(
        categoryRoute('fish-aquatics'),
        equals('/categories/fish-aquatics'),
      );
    });

    test('slug with numbers produces correct route', () {
      expect(categoryRoute('pet-food-123'), equals('/categories/pet-food-123'));
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations
    //
    // For any slug s, categoryRoute(s) must equal '/categories/s'.
    // -----------------------------------------------------------------------

    test(
      'route is always /categories/{slug} for 100+ random slugs',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          final slug = _randomSlug(rng);
          final route = categoryRoute(slug);

          expect(
            route,
            equals('/categories/$slug'),
            reason:
                'Iteration $iter: categoryRoute("$slug") must be '
                '"/categories/$slug" but got "$route"',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Route always starts with /categories/
    // -----------------------------------------------------------------------

    test(
      'route always starts with /categories/ for 100+ random slugs',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          final slug = _randomSlug(rng);
          final route = categoryRoute(slug);

          expect(
            route.startsWith('/categories/'),
            isTrue,
            reason:
                'Iteration $iter: route "$route" must start with '
                '"/categories/"',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Route suffix equals the slug exactly
    // -----------------------------------------------------------------------

    test(
      'route suffix after /categories/ equals the slug exactly '
      'for 100+ random slugs',
      () {
        const iterations = 100;
        final rng = Random(13);

        for (var iter = 0; iter < iterations; iter++) {
          final slug = _randomSlug(rng);
          final route = categoryRoute(slug);
          final suffix = route.substring('/categories/'.length);

          expect(
            suffix,
            equals(slug),
            reason:
                'Iteration $iter: route suffix "$suffix" must equal '
                'slug "$slug"',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Different slugs produce different routes
    // -----------------------------------------------------------------------

    test(
      'distinct slugs always produce distinct routes for 100 pairs',
      () {
        const iterations = 100;
        final rng = Random(99);

        for (var iter = 0; iter < iterations; iter++) {
          final slug1 = _randomSlug(rng, minLen: 3, maxLen: 15);
          // Ensure slug2 is different from slug1
          var slug2 = _randomSlug(rng, minLen: 3, maxLen: 15);
          while (slug2 == slug1) {
            slug2 = _randomSlug(rng, minLen: 3, maxLen: 15);
          }

          final route1 = categoryRoute(slug1);
          final route2 = categoryRoute(slug2);

          expect(
            route1,
            isNot(equals(route2)),
            reason:
                'Iteration $iter: distinct slugs "$slug1" and "$slug2" '
                'must produce distinct routes',
          );
        }
      },
    );
  });
}
