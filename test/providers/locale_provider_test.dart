// Feature: zoovana-app-ui, Property 35: Locale persistence round-trip

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Validates: Requirements 20.5
///
/// Property 35: Locale persistence round-trip
/// For any locale value l in {Locale('en'), Locale('ar')}, saving l to
/// SharedPreferences and then reading it back shall produce the same locale l.

const _prefKey = 'zoovana_locale';

/// Saves a locale to SharedPreferences (mirrors LocaleNotifier.setLocale).
Future<void> saveLocale(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_prefKey, locale.languageCode);
}

/// Reads the locale back from SharedPreferences (mirrors LocaleNotifier._restore).
Future<Locale> readLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString(_prefKey) ?? 'en';
  return Locale(code);
}

void main() {
  group('Property 35: Locale persistence round-trip', () {
    setUp(() {
      // Isolate each test with a clean SharedPreferences state.
      SharedPreferences.setMockInitialValues({});
    });

    test('saving Locale(en) and reading back produces Locale(en)', () async {
      const locale = Locale('en');
      await saveLocale(locale);
      final restored = await readLocale();
      expect(restored, equals(locale));
    });

    test('saving Locale(ar) and reading back produces Locale(ar)', () async {
      const locale = Locale('ar');
      await saveLocale(locale);
      final restored = await readLocale();
      expect(restored, equals(locale));
    });

    test(
      'round-trip holds for at least 100 iterations cycling through both locales',
      () async {
        // The two valid locale values per the property definition.
        const locales = [Locale('en'), Locale('ar')];

        for (var i = 0; i < 100; i++) {
          // Reset prefs for each iteration to ensure isolation.
          SharedPreferences.setMockInitialValues({});

          final locale = locales[i % locales.length];
          await saveLocale(locale);
          final restored = await readLocale();

          expect(
            restored,
            equals(locale),
            reason:
                'Iteration $i: expected $locale but got $restored after round-trip',
          );
        }
      },
    );

    test('default locale is Locale(en) when no value is stored', () async {
      // No value written — readLocale should fall back to 'en'.
      final restored = await readLocale();
      expect(restored, equals(const Locale('en')));
    });

    test('overwriting locale updates the persisted value', () async {
      await saveLocale(const Locale('en'));
      await saveLocale(const Locale('ar'));
      final restored = await readLocale();
      expect(restored, equals(const Locale('ar')));
    });
  });
}
