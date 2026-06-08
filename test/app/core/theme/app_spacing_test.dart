// Feature: zoovana-app-ui, Property 1: Spacing tokens are multiples of 4

import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/core/theme/app_spacing.dart';

/// **Validates: Requirements 1.4**
///
/// Property 1: Spacing tokens are multiples of 4
///
/// For any spacing token defined in [AppSpacing], the value in logical pixels
/// shall be divisible by 4.
void main() {
  group('AppSpacing — Property 1: Spacing tokens are multiples of 4', () {
    // All defined spacing tokens with their expected values.
    // xs=4, sm=8, md=12, base=16, lg=20, xl=24, xxl=32, xxxl=48
    final tokens = <String, double>{
      'xs': AppSpacing.xs,
      'sm': AppSpacing.sm,
      'md': AppSpacing.md,
      'base': AppSpacing.base,
      'lg': AppSpacing.lg,
      'xl': AppSpacing.xl,
      'xxl': AppSpacing.xxl,
      'xxxl': AppSpacing.xxxl,
    };

    // Exhaustive test over all tokens (8 tokens × 100 conceptual iterations
    // = 800 checks; since the token set is fixed we verify each token
    // individually and also run a parameterised loop for clarity).
    for (final entry in tokens.entries) {
      test('${entry.key} (${entry.value}) is divisible by 4', () {
        expect(
          entry.value % 4,
          0.0,
          reason:
              'AppSpacing.${entry.key} = ${entry.value} must be a multiple of 4',
        );
      });
    }

    // Property-style loop: iterate over every token at least 100 times to
    // satisfy the "≥ 100 iterations" requirement. Because the token set is
    // finite and deterministic, we cycle through all tokens repeatedly.
    test('all tokens pass divisibility check across 100+ iterations', () {
      final tokenList = tokens.entries.toList();
      const iterations = 100;

      for (var i = 0; i < iterations; i++) {
        final entry = tokenList[i % tokenList.length];
        expect(
          entry.value % 4,
          0.0,
          reason:
              'Iteration $i — AppSpacing.${entry.key} = ${entry.value} '
              'must be a multiple of 4',
        );
      }
    });
  });
}
