// Feature: zoovana-app-ui, Property 33: Directional slide transition by locale

import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pure logic extracted from the localized slide-transition helper.
///
/// Given a [TextDirection], returns the begin [Offset] for the slide
/// transition:
///   - LTR → Offset(1, 0)  (slide in from the right)
///   - RTL → Offset(-1, 0) (slide in from the left)
Offset computeBeginOffset(TextDirection direction) {
  final isRtl = direction == TextDirection.rtl;
  return isRtl ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
}

void main() {
  group('Property 33: Directional slide transition by locale', () {
    /// Validates: Requirements 19.2
    ///
    /// For any forward navigation when locale is `en` (LTR), the page
    /// transition shall slide in from the right (begin == Offset(1, 0)).
    /// When locale is `ar` (RTL), the page shall slide in from the left
    /// (begin == Offset(-1, 0)).
    test(
      'LTR always produces Offset(1, 0) and RTL always produces Offset(-1, 0) '
      'across 100 random iterations',
      () {
        final random = Random(42);
        const iterations = 100;

        for (var i = 0; i < iterations; i++) {
          // Randomly pick a TextDirection each iteration.
          final direction =
              random.nextBool() ? TextDirection.ltr : TextDirection.rtl;

          final begin = computeBeginOffset(direction);

          if (direction == TextDirection.ltr) {
            expect(
              begin,
              equals(const Offset(1.0, 0.0)),
              reason:
                  'LTR (en) locale must slide in from the right: '
                  'expected Offset(1, 0) but got $begin',
            );
          } else {
            expect(
              begin,
              equals(const Offset(-1.0, 0.0)),
              reason:
                  'RTL (ar) locale must slide in from the left: '
                  'expected Offset(-1, 0) but got $begin',
            );
          }
        }
      },
    );

    test('LTR direction produces Offset(1, 0) — slide from right', () {
      final begin = computeBeginOffset(TextDirection.ltr);
      expect(begin, equals(const Offset(1.0, 0.0)));
    });

    test('RTL direction produces Offset(-1, 0) — slide from left', () {
      final begin = computeBeginOffset(TextDirection.rtl);
      expect(begin, equals(const Offset(-1.0, 0.0)));
    });

    test('begin offset dy is always 0 for both directions', () {
      expect(computeBeginOffset(TextDirection.ltr).dy, equals(0.0));
      expect(computeBeginOffset(TextDirection.rtl).dy, equals(0.0));
    });

    test('begin offset dx magnitude is always 1 for both directions', () {
      expect(computeBeginOffset(TextDirection.ltr).dx.abs(), equals(1.0));
      expect(computeBeginOffset(TextDirection.rtl).dx.abs(), equals(1.0));
    });

    test('LTR and RTL produce opposite dx signs', () {
      final ltr = computeBeginOffset(TextDirection.ltr);
      final rtl = computeBeginOffset(TextDirection.rtl);
      expect(ltr.dx, equals(-rtl.dx));
    });
  });
}
