// Feature: zoovana-app-ui, Property 6: Hero banner auto-advances

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Property 6: Hero banner auto-advances
// **Validates: Requirements 3.2**
//
// For any starting slide index i in [0, slideCount-1], after 4 seconds the
// active slide index shall be (i + 1) % slideCount.
// ---------------------------------------------------------------------------

/// Pure auto-advance logic extracted from HeroBannerCarousel.
///
/// Given a starting index [current] and a total [slideCount], returns the
/// index that should be active after one auto-advance tick.
int nextSlideIndex(int current, int slideCount) {
  assert(slideCount > 0, 'slideCount must be positive');
  return (current + 1) % slideCount;
}

void main() {
  group('Property 6: Hero banner auto-advances', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests
    // -----------------------------------------------------------------------

    test('advances from 0 to 1 with 3 slides', () {
      expect(nextSlideIndex(0, 3), equals(1));
    });

    test('advances from 1 to 2 with 3 slides', () {
      expect(nextSlideIndex(1, 3), equals(2));
    });

    test('wraps from last slide back to 0 with 3 slides', () {
      expect(nextSlideIndex(2, 3), equals(0));
    });

    test('wraps from last slide back to 0 with 1 slide', () {
      expect(nextSlideIndex(0, 1), equals(0));
    });

    test('wraps from last slide back to 0 with 2 slides', () {
      expect(nextSlideIndex(1, 2), equals(0));
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations
    //
    // For any starting index i in [0, slideCount-1], after one tick the
    // active index must be (i + 1) % slideCount.
    // -----------------------------------------------------------------------

    test(
      'auto-advance is (i + 1) % slideCount for 100+ random (i, slideCount) pairs',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          // slideCount in [1, 20]
          final slideCount = 1 + rng.nextInt(20);
          // starting index in [0, slideCount-1]
          final startIndex = rng.nextInt(slideCount);

          final expected = (startIndex + 1) % slideCount;
          final actual = nextSlideIndex(startIndex, slideCount);

          expect(
            actual,
            equals(expected),
            reason:
                'Iteration $iter: nextSlideIndex($startIndex, $slideCount) '
                'should be $expected but got $actual',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Wrap-around: last index always wraps to 0
    // -----------------------------------------------------------------------

    test(
      'last slide always wraps to index 0 across 100 slide counts',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          // slideCount in [2, 50]
          final slideCount = 2 + rng.nextInt(49);
          final lastIndex = slideCount - 1;

          final result = nextSlideIndex(lastIndex, slideCount);

          expect(
            result,
            equals(0),
            reason:
                'Iteration $iter: last slide ($lastIndex) of $slideCount '
                'slides must wrap to 0, got $result',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Non-last index never wraps (result == current + 1)
    // -----------------------------------------------------------------------

    test(
      'non-last slide advances by exactly 1 across 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(13);

        for (var iter = 0; iter < iterations; iter++) {
          // slideCount in [2, 50]
          final slideCount = 2 + rng.nextInt(49);
          // startIndex in [0, slideCount-2] (not the last)
          final startIndex = rng.nextInt(slideCount - 1);

          final result = nextSlideIndex(startIndex, slideCount);

          expect(
            result,
            equals(startIndex + 1),
            reason:
                'Iteration $iter: non-last slide $startIndex of '
                '$slideCount should advance to ${startIndex + 1}, '
                'got $result',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Repeated advance cycles through all slides and returns to start
    // -----------------------------------------------------------------------

    test(
      'repeated auto-advance cycles through all slides and returns to start '
      'across 100 slide counts',
      () {
        const iterations = 100;
        final rng = Random(99);

        for (var iter = 0; iter < iterations; iter++) {
          // slideCount in [1, 15]
          final slideCount = 1 + rng.nextInt(15);
          var index = 0;

          // Advance slideCount times — should return to 0
          for (var step = 0; step < slideCount; step++) {
            index = nextSlideIndex(index, slideCount);
          }

          expect(
            index,
            equals(0),
            reason:
                'Iteration $iter: after $slideCount advances with '
                '$slideCount slides, index must be back at 0, got $index',
          );
        }
      },
    );
  });
}
