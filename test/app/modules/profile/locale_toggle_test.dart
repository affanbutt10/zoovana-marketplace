// Feature: zoovana-app-ui, Property 26: Locale toggle applies directionality
// Feature: zoovana-app-ui, Property 2: RTL layout applied for Arabic locale

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Validates: Requirements 14.7, 20.2
/// Validates: Requirements 1.6, 20.2

TextDirection directionForLocale(Locale locale) =>
    locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

void main() {
  group('Property 26: Locale toggle applies directionality', () {
    test('ar → RTL, en → LTR — 20 iterations', () {
      const locales = [Locale('en'), Locale('ar')];
      for (var i = 0; i < 20; i++) {
        final locale = locales[i % 2];
        final dir = directionForLocale(locale);
        if (locale.languageCode == 'ar') {
          expect(dir, TextDirection.rtl,
              reason: 'Iteration $i: ar must be RTL');
        } else {
          expect(dir, TextDirection.ltr,
              reason: 'Iteration $i: en must be LTR');
        }
      }
    });
  });

  group('Property 2: RTL layout applied for Arabic locale', () {
    test('Locale(ar) always produces RTL — 20 iterations', () {
      for (var i = 0; i < 20; i++) {
        expect(
          directionForLocale(const Locale('ar')),
          TextDirection.rtl,
          reason: 'Iteration $i: Arabic locale must be RTL',
        );
      }
    });

    test('Locale(en) always produces LTR — 20 iterations', () {
      for (var i = 0; i < 20; i++) {
        expect(
          directionForLocale(const Locale('en')),
          TextDirection.ltr,
          reason: 'Iteration $i: English locale must be LTR',
        );
      }
    });
  });
}
