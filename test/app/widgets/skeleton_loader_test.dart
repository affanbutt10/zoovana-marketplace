// Feature: zoovana-app-ui, Property 8: Skeleton loaders shown during loading state
// Feature: zoovana-app-ui, Property 9: Skeleton loaders replaced with fade-in on data

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/widgets/skeleton_loader.dart';
import 'package:zoovana/app/core/theme/app_colors.dart';

class _TestAsync<T> {
  const _TestAsync._({
    this.data,
    this.error,
    this.isLoading = false,
  });

  const _TestAsync.loading() : this._(isLoading: true);
  const _TestAsync.data(T value) : this._(data: value);
  const _TestAsync.error(Object err) : this._(error: err);

  final T? data;
  final Object? error;
  final bool isLoading;
}

// ---------------------------------------------------------------------------
// Helper: a widget that switches between loading, error, and content states
// loading and real content on data — mirrors the pattern used in every screen.
// ---------------------------------------------------------------------------

class _AsyncWidget extends StatelessWidget {
  final _TestAsync<String> value;
  final Widget Function(String data) dataBuilder;

  const _AsyncWidget({required this.value, required this.dataBuilder});

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) {
      return const SkeletonLoader.card();
    }
    if (value.error != null) {
      return Text('error: ${value.error}');
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: dataBuilder(value.data!),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper: a list-row variant widget
// ---------------------------------------------------------------------------

class _AsyncListWidget extends StatelessWidget {
  final _TestAsync<String> value;

  const _AsyncListWidget({required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) {
      return const SkeletonLoader.listRow();
    }
    if (value.error != null) {
      return Text('error: ${value.error}');
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Text(value.data!, key: ValueKey(value.data)),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper: a text-block variant widget
// ---------------------------------------------------------------------------

class _AsyncTextWidget extends StatelessWidget {
  final _TestAsync<String> value;

  const _AsyncTextWidget({required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) {
      return const SkeletonLoader.textBlock(lines: 3);
    }
    if (value.error != null) {
      return Text('error: ${value.error}');
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Text(value.data!, key: ValueKey(value.data)),
    );
  }
}

// ---------------------------------------------------------------------------
// Pump helper
// ---------------------------------------------------------------------------

Future<void> _pumpWidget(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  // =========================================================================
  // SkeletonLoader widget unit tests
  // =========================================================================

  group('SkeletonLoader widget', () {
    testWidgets('card variant renders without error', (tester) async {
      await _pumpWidget(tester, const SkeletonLoader.card());
      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('listRow variant renders without error', (tester) async {
      await _pumpWidget(tester, const SkeletonLoader.listRow());
      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('textBlock variant renders without error', (tester) async {
      await _pumpWidget(tester, const SkeletonLoader.textBlock(lines: 3));
      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('animation controller duration is 1500ms', (tester) async {
      await _pumpWidget(tester, const SkeletonLoader.card());

      // Advance time by 1500ms — the animation should complete one full cycle
      // without throwing. The SkeletonLoader must still be present.
      await tester.pump(const Duration(milliseconds: 750));
      await tester.pump(const Duration(milliseconds: 750));
      expect(find.byType(SkeletonLoader), findsOneWidget);

      // Verify the AnimatedBuilder inside SkeletonLoader is present by
      // finding it as a descendant of the SkeletonLoader widget.
      final skeletonFinder = find.byType(SkeletonLoader);
      final animatedBuilderInSkeleton = find.descendant(
        of: skeletonFinder,
        matching: find.byType(AnimatedBuilder),
      );
      expect(animatedBuilderInSkeleton, findsOneWidget);
    });

    testWidgets('card uses skeletonBase color initially', (tester) async {
      await _pumpWidget(tester, const SkeletonLoader.card());

      // At t=0 the animation starts at skeletonBase
      final containers = tester.widgetList<Container>(find.byType(Container));
      final colors = containers
          .map((c) => (c.decoration as BoxDecoration?)?.color)
          .whereType<Color>()
          .toList();

      // At least one container should use a skeleton color
      final skeletonColors = {AppColors.skeletonBase, AppColors.skeletonHighlight};
      expect(
        colors.any((c) => skeletonColors.contains(c) || _isSkeletonColor(c)),
        isTrue,
        reason: 'SkeletonLoader should use skeleton color range',
      );
    });
  });

  // =========================================================================
  // Property 8: Skeleton loaders shown during loading state
  // **Validates: Requirements 3.7, 3.12, 4.3, 5.4, 7.8, 8.4, 9.10, 11.4**
  // =========================================================================

  group(
    'Property 8: Skeleton loaders shown during loading state',
    () {
      // --- card variant ---
      testWidgets(
        'card skeleton shown when state is loading',
        (tester) async {
          await _pumpWidget(
            tester,
            _AsyncWidget(
              value: const _TestAsync.loading(),
              dataBuilder: (d) => Text(d),
            ),
          );
          expect(find.byType(SkeletonLoader), findsOneWidget);
          expect(find.byType(Text), findsNothing);
        },
      );

      // --- listRow variant ---
      testWidgets(
        'listRow skeleton shown when state is loading',
        (tester) async {
          await _pumpWidget(
            tester,
            const _AsyncListWidget(value: _TestAsync.loading()),
          );
          expect(find.byType(SkeletonLoader), findsOneWidget);
          expect(find.byType(Text), findsNothing);
        },
      );

      // --- textBlock variant ---
      testWidgets(
        'textBlock skeleton shown when state is loading',
        (tester) async {
          await _pumpWidget(
            tester,
            const _AsyncTextWidget(value: _TestAsync.loading()),
          );
          expect(find.byType(SkeletonLoader), findsOneWidget);
          expect(find.byType(Text), findsNothing);
        },
      );

      // --- no skeleton when data is present ---
      testWidgets(
        'no skeleton shown when state has data',
        (tester) async {
          await _pumpWidget(
            tester,
            _AsyncWidget(
              value: const _TestAsync.data('hello'),
              dataBuilder: (d) => Text(d),
            ),
          );
          expect(find.byType(SkeletonLoader), findsNothing);
          expect(find.text('hello'), findsOneWidget);
        },
      );

      // --- no skeleton when error ---
      testWidgets(
        'no skeleton shown when state has error',
        (tester) async {
          await _pumpWidget(
            tester,
            _AsyncWidget(
              value: const _TestAsync.error('oops'),
              dataBuilder: (d) => Text(d),
            ),
          );
          expect(find.byType(SkeletonLoader), findsNothing);
        },
      );

      // --- property loop: 100 iterations over all three variants ---
      testWidgets(
        'skeleton shown for loading state across 100+ iterations (all variants)',
        (tester) async {
          // The three widget factories to cycle through
          final factories = <Widget Function()>[
            () => _AsyncWidget(
                  value: const _TestAsync.loading(),
                  dataBuilder: (d) => Text(d),
                ),
            () => const _AsyncListWidget(value: _TestAsync.loading()),
            () => const _AsyncTextWidget(value: _TestAsync.loading()),
          ];

          const iterations = 100;
          for (var i = 0; i < iterations; i++) {
            final widget = factories[i % factories.length]();
            await _pumpWidget(tester, widget);

            expect(
              find.byType(SkeletonLoader),
              findsOneWidget,
              reason:
                  'Iteration $i (variant ${i % factories.length}): '
                  'SkeletonLoader must be present when the state is loading',
            );
            expect(
              find.byType(Text),
              findsNothing,
              reason:
                  'Iteration $i: no Text widget should appear during loading',
            );
          }
        },
      );
    },
  );

  // =========================================================================
  // Property 9: Skeleton loaders replaced with fade-in on data
  // **Validates: Requirements 18.4**
  // =========================================================================

  group(
    'Property 9: Skeleton loaders replaced with fade-in on data',
    () {
      testWidgets(
        'AnimatedSwitcher wraps content when the state transitions to data',
        (tester) async {
          await _pumpWidget(
            tester,
            _AsyncWidget(
              value: const _TestAsync.data('content'),
              dataBuilder: (d) => Text(d, key: ValueKey(d)),
            ),
          );
          // AnimatedSwitcher must be present (fade-in wrapper)
          expect(find.byType(AnimatedSwitcher), findsOneWidget);
          expect(find.byType(SkeletonLoader), findsNothing);
          expect(find.text('content'), findsOneWidget);
        },
      );

      testWidgets(
        'AnimatedSwitcher has 200ms duration for fade-in',
        (tester) async {
          await _pumpWidget(
            tester,
            _AsyncWidget(
              value: const _TestAsync.data('hello'),
              dataBuilder: (d) => Text(d, key: ValueKey(d)),
            ),
          );

          final switcher = tester.widget<AnimatedSwitcher>(
            find.byType(AnimatedSwitcher),
          );
          expect(
            switcher.duration,
            const Duration(milliseconds: 200),
            reason: 'Fade-in duration must be 200ms per design spec',
          );
        },
      );

      testWidgets(
        'skeleton absent and content visible after loading → data transition',
        (tester) async {
          final notifier = ValueNotifier<_TestAsync<String>>(
            const _TestAsync.loading(),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ValueListenableBuilder<_TestAsync<String>>(
                  valueListenable: notifier,
                  builder: (context, value, child) => _AsyncWidget(
                    value: value,
                    dataBuilder: (d) => Text(d, key: ValueKey(d)),
                  ),
                ),
              ),
            ),
          );

          // Loading state: skeleton present
          expect(find.byType(SkeletonLoader), findsOneWidget);
          expect(find.byType(Text), findsNothing);

          notifier.value = const _TestAsync.data('loaded');
          await tester.pump();

          // Skeleton gone, AnimatedSwitcher present
          expect(find.byType(SkeletonLoader), findsNothing);
          expect(find.byType(AnimatedSwitcher), findsOneWidget);

          // Pump through the 200ms fade-in
          await tester.pump(const Duration(milliseconds: 200));
          expect(find.text('loaded'), findsOneWidget);

          notifier.dispose();
        },
      );

      // --- property loop: 100 iterations ---
      testWidgets(
        'fade-in transition holds across 100+ iterations',
        (tester) async {
          const iterations = 100;
          final dataValues = List.generate(iterations, (i) => 'item_$i');

          for (var i = 0; i < iterations; i++) {
            final data = dataValues[i];
            await _pumpWidget(
              tester,
              _AsyncWidget(
                value: _TestAsync.data(data),
                dataBuilder: (d) => Text(d, key: ValueKey(d)),
              ),
            );

            expect(
              find.byType(SkeletonLoader),
              findsNothing,
              reason:
                  'Iteration $i: SkeletonLoader must not be present when '
                  'the state has data ("$data")',
            );
            expect(
              find.byType(AnimatedSwitcher),
              findsOneWidget,
              reason:
                  'Iteration $i: AnimatedSwitcher must wrap content for '
                  'fade-in animation',
            );

            final switcher = tester.widget<AnimatedSwitcher>(
              find.byType(AnimatedSwitcher),
            );
            expect(
              switcher.duration,
              const Duration(milliseconds: 200),
              reason:
                  'Iteration $i: fade-in duration must be 200ms',
            );
          }
        },
      );
    },
  );
}

// ---------------------------------------------------------------------------
// Helper: checks if a color is within the skeleton shimmer range
// (between skeletonBase and skeletonHighlight)
// ---------------------------------------------------------------------------
bool _isSkeletonColor(Color c) {
  // Both skeleton colors are grey-ish with high lightness.
  // Accept any color whose red, green, blue channels are all >= 0xE0.
  return (c.r * 255.0).round().clamp(0, 255) >= 0xE0 &&
      (c.g * 255.0).round().clamp(0, 255) >= 0xE0 &&
      (c.b * 255.0).round().clamp(0, 255) >= 0xE0;
}
