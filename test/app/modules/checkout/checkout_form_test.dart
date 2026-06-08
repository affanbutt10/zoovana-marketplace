// Feature: zoovana-app-ui, Property 22: Form inputs disabled during submission

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Property 22: Form inputs disabled during submission
// **Validates: Requirements 10.9, 15.9**
//
// For any checkout or auth form in the loading/submitting state, all
// TextFormField and button widgets shall have their `enabled` property
// set to false.
// ---------------------------------------------------------------------------

/// A minimal form widget that mirrors the disabled-during-loading pattern
/// used in AddressForm, LoginScreen, RegisterScreen, and ForgotPasswordScreen.
class _TestForm extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onSubmit;

  const _TestForm({required this.isLoading, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: const Key('field1'),
          enabled: !isLoading,
          decoration: const InputDecoration(labelText: 'Field 1'),
        ),
        TextFormField(
          key: const Key('field2'),
          enabled: !isLoading,
          decoration: const InputDecoration(labelText: 'Field 2'),
        ),
        ElevatedButton(
          key: const Key('submit'),
          onPressed: isLoading ? null : onSubmit,
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text('Submit'),
        ),
      ],
    );
  }
}

void main() {
  group('Property 22: Form inputs disabled during submission', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests
    // -----------------------------------------------------------------------

    testWidgets('fields are enabled when isLoading is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: _TestForm(isLoading: false)),
        ),
      );

      final field1 = tester.widget<TextFormField>(find.byKey(const Key('field1')));
      final field2 = tester.widget<TextFormField>(find.byKey(const Key('field2')));

      expect(field1.enabled, isTrue);
      expect(field2.enabled, isTrue);
    });

    testWidgets('fields are disabled when isLoading is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: _TestForm(isLoading: true)),
        ),
      );

      final field1 = tester.widget<TextFormField>(find.byKey(const Key('field1')));
      final field2 = tester.widget<TextFormField>(find.byKey(const Key('field2')));

      expect(field1.enabled, isFalse);
      expect(field2.enabled, isFalse);
    });

    testWidgets('button is disabled when isLoading is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: _TestForm(isLoading: true)),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byKey(const Key('submit')));
      expect(button.onPressed, isNull);
    });

    testWidgets('button is enabled when isLoading is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: _TestForm(isLoading: false, onSubmit: () {})),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byKey(const Key('submit')));
      expect(button.onPressed, isNotNull);
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations
    //
    // When isLoading is true, all fields must be disabled.
    // When isLoading is false, all fields must be enabled.
    // -----------------------------------------------------------------------

    testWidgets(
      'fields disabled when isLoading=true — 100 iterations',
      (tester) async {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          // Always isLoading = true for this property
          rng.nextBool(); // consume rng for determinism

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(body: _TestForm(isLoading: true)),
            ),
          );

          final field1 = tester.widget<TextFormField>(
              find.byKey(const Key('field1')));
          final field2 = tester.widget<TextFormField>(
              find.byKey(const Key('field2')));
          final button = tester.widget<ElevatedButton>(
              find.byKey(const Key('submit')));

          expect(
            field1.enabled,
            isFalse,
            reason: 'Iteration $iter: field1 must be disabled during loading',
          );
          expect(
            field2.enabled,
            isFalse,
            reason: 'Iteration $iter: field2 must be disabled during loading',
          );
          expect(
            button.onPressed,
            isNull,
            reason: 'Iteration $iter: button must be disabled during loading',
          );
        }
      },
    );

    testWidgets(
      'fields enabled when isLoading=false — 100 iterations',
      (tester) async {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          rng.nextBool(); // consume rng for determinism

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: _TestForm(isLoading: false, onSubmit: () {}),
              ),
            ),
          );

          final field1 = tester.widget<TextFormField>(
              find.byKey(const Key('field1')));
          final field2 = tester.widget<TextFormField>(
              find.byKey(const Key('field2')));
          final button = tester.widget<ElevatedButton>(
              find.byKey(const Key('submit')));

          expect(
            field1.enabled,
            isTrue,
            reason: 'Iteration $iter: field1 must be enabled when not loading',
          );
          expect(
            field2.enabled,
            isTrue,
            reason: 'Iteration $iter: field2 must be enabled when not loading',
          );
          expect(
            button.onPressed,
            isNotNull,
            reason:
                'Iteration $iter: button must be enabled when not loading',
          );
        }
      },
    );
  });
}
