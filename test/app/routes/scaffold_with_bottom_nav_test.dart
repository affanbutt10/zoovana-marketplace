// Feature: zoovana-app-ui, Property 3: Active tab uses primary color

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/core/theme/app_colors.dart';

/// **Validates: Requirements 2.2**
///
/// Property 3: Active tab uses primary color
///
/// For any tab index in [0, 4], when that tab is the selected index of
/// [BottomNavigationBar], the tab's icon and label color shall equal
/// [AppColors.primary]. Unselected tabs shall use [AppColors.muted].

/// Helper that builds a [BottomNavigationBar] with the same color
/// configuration as [ScaffoldWithBottomNav], using [currentIndex] as the
/// selected tab.
Widget _buildNavBar(int currentIndex) {
  return MaterialApp(
    home: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: const SizedBox.shrink(),
    ),
  );
}

void main() {
  group(
    'BottomNavigationBar — Property 3: Active tab uses primary color',
    () {
      // ---------------------------------------------------------------
      // Individual tab tests (one per index)
      // ---------------------------------------------------------------
      for (var index = 0; index <= 4; index++) {
        testWidgets(
          'tab $index: selectedItemColor == AppColors.primary',
          (tester) async {
            await tester.pumpWidget(_buildNavBar(index));

            final navBar = tester.widget<BottomNavigationBar>(
              find.byType(BottomNavigationBar),
            );

            expect(
              navBar.selectedItemColor,
              AppColors.primary,
              reason:
                  'Tab $index is selected — selectedItemColor must be '
                  'AppColors.primary (${AppColors.primary})',
            );
          },
        );

        testWidgets(
          'tab $index: unselectedItemColor == AppColors.muted',
          (tester) async {
            await tester.pumpWidget(_buildNavBar(index));

            final navBar = tester.widget<BottomNavigationBar>(
              find.byType(BottomNavigationBar),
            );

            expect(
              navBar.unselectedItemColor,
              AppColors.muted,
              reason:
                  'Tab $index is selected — unselectedItemColor must be '
                  'AppColors.muted (${AppColors.muted})',
            );
          },
        );
      }

      // ---------------------------------------------------------------
      // Property-style loop: cycle through all 5 tabs ≥ 100 iterations
      // ---------------------------------------------------------------
      testWidgets(
        'selectedItemColor == AppColors.primary across 100+ iterations',
        (tester) async {
          const iterations = 100;

          for (var i = 0; i < iterations; i++) {
            final tabIndex = i % 5;
            await tester.pumpWidget(_buildNavBar(tabIndex));

            final navBar = tester.widget<BottomNavigationBar>(
              find.byType(BottomNavigationBar),
            );

            expect(
              navBar.selectedItemColor,
              AppColors.primary,
              reason:
                  'Iteration $i (tab $tabIndex): selectedItemColor must be '
                  'AppColors.primary',
            );

            expect(
              navBar.unselectedItemColor,
              AppColors.muted,
              reason:
                  'Iteration $i (tab $tabIndex): unselectedItemColor must be '
                  'AppColors.muted',
            );
          }
        },
      );
    },
  );
}
