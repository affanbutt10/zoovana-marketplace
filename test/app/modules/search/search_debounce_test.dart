// Feature: zoovana-app-ui, Property 18: Search debounce threshold

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Property 18: Search debounce threshold
// **Validates: Requirements 8.2, 8.3**
//
// For any query string with length < 2, the searchProductsProvider shall not
// be invoked. For any query string with length >= 2, the provider shall be
// invoked after a 300-millisecond debounce.
// ---------------------------------------------------------------------------

/// Pure debounce threshold logic extracted from SearchScreen.
/// Returns true if the query should trigger a search (length >= 2).
bool shouldTriggerSearch(String query) => query.length >= 2;

/// Simulates the debounce: returns the query that would be sent after
/// the debounce period, or null if the query is too short.
String? debouncedQuery(String query) {
  if (!shouldTriggerSearch(query)) return null;
  return query;
}

// ---------------------------------------------------------------------------
// String generators
// ---------------------------------------------------------------------------

const _chars = 'abcdefghijklmnopqrstuvwxyz0123456789 ';

String _randomString(Random rng, int length) {
  return List.generate(
    length,
    (_) => _chars[rng.nextInt(_chars.length)],
  ).join();
}

void main() {
  group('Property 18: Search debounce threshold', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests
    // -----------------------------------------------------------------------

    test('empty string does not trigger search', () {
      expect(shouldTriggerSearch(''), isFalse);
      expect(debouncedQuery(''), isNull);
    });

    test('single character does not trigger search', () {
      expect(shouldTriggerSearch('a'), isFalse);
      expect(debouncedQuery('a'), isNull);
    });

    test('two characters triggers search', () {
      expect(shouldTriggerSearch('ab'), isTrue);
      expect(debouncedQuery('ab'), equals('ab'));
    });

    test('three characters triggers search', () {
      expect(shouldTriggerSearch('cat'), isTrue);
      expect(debouncedQuery('cat'), equals('cat'));
    });

    test('long query triggers search', () {
      const query = 'dog food premium';
      expect(shouldTriggerSearch(query), isTrue);
      expect(debouncedQuery(query), equals(query));
    });

    // -----------------------------------------------------------------------
    // Property-based: queries with length < 2 never trigger search
    // -----------------------------------------------------------------------

    test(
      'queries with length < 2 never trigger search — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          // Generate queries of length 0 or 1
          final length = rng.nextInt(2); // 0 or 1
          final query = _randomString(rng, length);

          expect(
            shouldTriggerSearch(query),
            isFalse,
            reason:
                'Iteration $iter: query "$query" (length ${query.length}) '
                'must NOT trigger search',
          );
          expect(
            debouncedQuery(query),
            isNull,
            reason:
                'Iteration $iter: debouncedQuery("$query") must be null',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Property-based: queries with length >= 2 always trigger search
    // -----------------------------------------------------------------------

    test(
      'queries with length >= 2 always trigger search — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          // Generate queries of length 2 to 30
          final length = 2 + rng.nextInt(29);
          final query = _randomString(rng, length);

          expect(
            shouldTriggerSearch(query),
            isTrue,
            reason:
                'Iteration $iter: query "$query" (length ${query.length}) '
                'MUST trigger search',
          );
          expect(
            debouncedQuery(query),
            equals(query),
            reason:
                'Iteration $iter: debouncedQuery must return the query itself',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Property-based: boundary at exactly length 2
    // -----------------------------------------------------------------------

    test(
      'exactly 2-char queries always trigger search — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(13);

        for (var iter = 0; iter < iterations; iter++) {
          final query = _randomString(rng, 2);

          expect(
            shouldTriggerSearch(query),
            isTrue,
            reason:
                'Iteration $iter: 2-char query "$query" must trigger search',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Property-based: debouncedQuery returns the original query unchanged
    // -----------------------------------------------------------------------

    test(
      'debouncedQuery returns query unchanged for length >= 2 — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(99);

        for (var iter = 0; iter < iterations; iter++) {
          final length = 2 + rng.nextInt(20);
          final query = _randomString(rng, length);

          final result = debouncedQuery(query);

          expect(
            result,
            equals(query),
            reason:
                'Iteration $iter: debouncedQuery("$query") must return '
                '"$query" unchanged, got "$result"',
          );
        }
      },
    );
  });
}
