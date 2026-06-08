// Feature: zoovana-app-ui, Property 16: Quantity stepper minimum invariant

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/widgets/quantity_stepper.dart';

// ---------------------------------------------------------------------------
// Helper: pumps a stateful wrapper around QuantityStepper so we can observe
// value changes triggered by the widget's onChanged callback.
// ---------------------------------------------------------------------------

class _StepperHarness extends StatefulWidget {
  final int initialValue;
  final int min;
  final int? max;

  const _StepperHarness({
    super.key,
    required this.initialValue,
    this.min = 1,
    this.max,
  });

  @override
  State<_StepperHarness> createState() => _StepperHarnessState();
}

class _StepperHarnessState extends State<_StepperHarness> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return QuantityStepper(
      value: value,
      min: widget.min,
      max: widget.max,
      onChanged: (v) => setState(() => value = v),
    );
  }
}

Future<void> _pumpStepper(
  WidgetTester tester, {
  required int initialValue,
  int min = 1,
  int? max,
}) async {
  // Use a UniqueKey so that each call creates a fresh widget tree,
  // ensuring _StepperHarnessState.initState() is called with the new value.
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: _StepperHarness(
          key: UniqueKey(),
          initialValue: initialValue,
          min: min,
          max: max,
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Finders
// ---------------------------------------------------------------------------

Finder get _decrementButton => find.widgetWithIcon(IconButton, Icons.remove);
Finder get _incrementButton => find.widgetWithIcon(IconButton, Icons.add);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // =========================================================================
  // Unit tests — specific examples
  // =========================================================================

  group('QuantityStepper unit tests', () {
    testWidgets('renders decrement and increment buttons', (tester) async {
      await _pumpStepper(tester, initialValue: 1);
      expect(_decrementButton, findsOneWidget);
      expect(_incrementButton, findsOneWidget);
    });

    testWidgets('displays initial value as text', (tester) async {
      await _pumpStepper(tester, initialValue: 3);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('decrement button is disabled when value == min (1)',
        (tester) async {
      await _pumpStepper(tester, initialValue: 1);
      final btn = tester.widget<IconButton>(_decrementButton);
      expect(btn.onPressed, isNull,
          reason: 'Decrement must be disabled at minimum value');
    });

    testWidgets('decrement button is enabled when value > min', (tester) async {
      await _pumpStepper(tester, initialValue: 2);
      final btn = tester.widget<IconButton>(_decrementButton);
      expect(btn.onPressed, isNotNull,
          reason: 'Decrement must be enabled when value > min');
    });

    testWidgets('tapping decrement when value > 1 decrements by 1',
        (tester) async {
      await _pumpStepper(tester, initialValue: 3);
      await tester.tap(_decrementButton);
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('tapping increment increases value by 1', (tester) async {
      await _pumpStepper(tester, initialValue: 2);
      await tester.tap(_incrementButton);
      await tester.pump();
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('tapping decrement at min=1 leaves value at 1', (tester) async {
      await _pumpStepper(tester, initialValue: 1);
      // Button is disabled — tap should have no effect
      await tester.tap(_decrementButton, warnIfMissed: false);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('increment button disabled when value == max', (tester) async {
      await _pumpStepper(tester, initialValue: 5, max: 5);
      final btn = tester.widget<IconButton>(_incrementButton);
      expect(btn.onPressed, isNull,
          reason: 'Increment must be disabled at maximum value');
    });

    testWidgets('custom min is respected — decrement disabled at custom min',
        (tester) async {
      await _pumpStepper(tester, initialValue: 3, min: 3);
      final btn = tester.widget<IconButton>(_decrementButton);
      expect(btn.onPressed, isNull,
          reason: 'Decrement must be disabled at custom minimum');
    });
  });

  // =========================================================================
  // Property 16: Quantity stepper minimum invariant
  // **Validates: Requirements 7.3**
  //
  // For any QuantityStepper with current value q, tapping the decrement button
  // when q == 1 shall leave the value at 1 (no decrement below minimum).
  // =========================================================================

  group(
    'Property 16: Quantity stepper minimum invariant',
    () {
      // --- Core invariant: decrement disabled at min across 100 iterations ---
      testWidgets(
        'decrement button is disabled when value == 1 across 100 iterations',
        (tester) async {
          const iterations = 100;
          // We vary the max to ensure the property holds regardless of max
          final rng = Random(42);

          for (var i = 0; i < iterations; i++) {
            // max is either null or a random value >= 2
            final max = rng.nextBool() ? null : 2 + rng.nextInt(98);

            await _pumpStepper(tester, initialValue: 1, max: max);

            final btn = tester.widget<IconButton>(_decrementButton);
            expect(
              btn.onPressed,
              isNull,
              reason:
                  'Iteration $i (max=$max): decrement must be disabled '
                  'when value == 1 (minimum)',
            );

            // Also verify the displayed value is still 1
            expect(
              find.text('1'),
              findsOneWidget,
              reason:
                  'Iteration $i: displayed value must remain 1 at minimum',
            );
          }
        },
      );

      // --- Decrement from value > 1 always decrements correctly ---
      testWidgets(
        'tapping decrement when value > 1 decrements by exactly 1 '
        'across 100 iterations',
        (tester) async {
          const iterations = 100;
          final rng = Random(7);

          for (var i = 0; i < iterations; i++) {
            // q in [2, 100]
            final q = 2 + rng.nextInt(99);

            await _pumpStepper(tester, initialValue: q);

            // Verify button is enabled
            final btnBefore = tester.widget<IconButton>(_decrementButton);
            expect(
              btnBefore.onPressed,
              isNotNull,
              reason:
                  'Iteration $i (q=$q): decrement must be enabled when '
                  'value > 1',
            );

            await tester.tap(_decrementButton);
            await tester.pump();

            expect(
              find.text('${q - 1}'),
              findsOneWidget,
              reason:
                  'Iteration $i (q=$q): value must be ${q - 1} after '
                  'one decrement',
            );
          }
        },
      );

      // --- Increment always increases value by 1 ---
      testWidgets(
        'tapping increment increases value by exactly 1 '
        'across 100 iterations',
        (tester) async {
          const iterations = 100;
          final rng = Random(13);

          for (var i = 0; i < iterations; i++) {
            // q in [1, 99] so there is always room to increment (no max set)
            final q = 1 + rng.nextInt(99);

            await _pumpStepper(tester, initialValue: q);

            final btnBefore = tester.widget<IconButton>(_incrementButton);
            expect(
              btnBefore.onPressed,
              isNotNull,
              reason:
                  'Iteration $i (q=$q): increment must be enabled when '
                  'no max is set',
            );

            await tester.tap(_incrementButton);
            await tester.pump();

            expect(
              find.text('${q + 1}'),
              findsOneWidget,
              reason:
                  'Iteration $i (q=$q): value must be ${q + 1} after '
                  'one increment',
            );
          }
        },
      );

      // --- Value never goes below 1 after repeated decrements ---
      testWidgets(
        'value never drops below 1 after repeated decrement attempts',
        (tester) async {
          const iterations = 100;
          final rng = Random(99);

          for (var i = 0; i < iterations; i++) {
            // Start at a random value in [1, 10]
            final start = 1 + rng.nextInt(10);
            await _pumpStepper(tester, initialValue: start);

            // Tap decrement (start + 2) times — more than enough to hit min
            for (var tap = 0; tap < start + 2; tap++) {
              final btn = tester.widget<IconButton>(_decrementButton);
              if (btn.onPressed != null) {
                await tester.tap(_decrementButton);
                await tester.pump();
              }
            }

            // Value must be exactly 1 (the minimum)
            expect(
              find.text('1'),
              findsOneWidget,
              reason:
                  'Iteration $i (start=$start): value must be 1 after '
                  'exhaustive decrements — never below minimum',
            );

            // Decrement button must be disabled at min
            final btnFinal = tester.widget<IconButton>(_decrementButton);
            expect(
              btnFinal.onPressed,
              isNull,
              reason:
                  'Iteration $i: decrement must be disabled at minimum '
                  'value of 1',
            );
          }
        },
      );
    },
  );
}
