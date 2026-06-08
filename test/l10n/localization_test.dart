// Feature: zoovana-app-ui, Property 34: Localization key completeness
//
// Validates: Requirements 20.3
//
// Property: For any localization key defined in the AppLocalizations ARB files,
// both the `en` and `ar` translations shall be non-empty strings.
//
// Since we can't easily import generated AppLocalizations in tests, we parse
// the ARB files directly as JSON and verify all keys have non-empty values in
// both files. Runs one iteration per key (100+ keys total).

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _loadArb(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('ARB file not found: $path');
  }
  final content = file.readAsStringSync();
  return jsonDecode(content) as Map<String, dynamic>;
}

/// Returns only the translation keys (excludes metadata keys starting with @@).
List<String> _translationKeys(Map<String, dynamic> arb) {
  return arb.keys.where((k) => !k.startsWith('@')).toList();
}

void main() {
  // Load both ARB files once for all tests.
  late Map<String, dynamic> enArb;
  late Map<String, dynamic> arArb;

  setUpAll(() {
    enArb = _loadArb('lib/l10n/app_en.arb');
    arArb = _loadArb('lib/l10n/app_ar.arb');
  });

  group('Property 34: Localization key completeness', () {
    test('both ARB files are valid JSON and non-empty', () {
      expect(enArb, isNotEmpty);
      expect(arArb, isNotEmpty);
    });

    test('en and ar ARB files have the same set of translation keys', () {
      final enKeys = _translationKeys(enArb).toSet();
      final arKeys = _translationKeys(arArb).toSet();

      final missingInAr = enKeys.difference(arKeys);
      final missingInEn = arKeys.difference(enKeys);

      expect(
        missingInAr,
        isEmpty,
        reason: 'Keys present in en but missing in ar: $missingInAr',
      );
      expect(
        missingInEn,
        isEmpty,
        reason: 'Keys present in ar but missing in en: $missingInEn',
      );
    });

    test('every en translation is a non-empty string (one iteration per key)',
        () {
      final keys = _translationKeys(enArb);

      // Verify we have at least 100 keys (one iteration per key).
      expect(
        keys.length,
        greaterThanOrEqualTo(100),
        reason:
            'Expected at least 100 translation keys, found ${keys.length}',
      );

      for (final key in keys) {
        final value = enArb[key];
        expect(
          value,
          isA<String>(),
          reason: 'en key "$key" should be a String, got ${value.runtimeType}',
        );
        expect(
          (value as String).trim(),
          isNotEmpty,
          reason: 'en key "$key" must not be an empty string',
        );
      }
    });

    test('every ar translation is a non-empty string (one iteration per key)',
        () {
      final keys = _translationKeys(arArb);

      expect(
        keys.length,
        greaterThanOrEqualTo(100),
        reason:
            'Expected at least 100 translation keys, found ${keys.length}',
      );

      for (final key in keys) {
        final value = arArb[key];
        expect(
          value,
          isA<String>(),
          reason: 'ar key "$key" should be a String, got ${value.runtimeType}',
        );
        expect(
          (value as String).trim(),
          isNotEmpty,
          reason: 'ar key "$key" must not be an empty string',
        );
      }
    });

    test(
        'for every key in en ARB, the ar ARB has a non-empty translation '
        '(property-style: one assertion per key)', () {
      final enKeys = _translationKeys(enArb);

      for (final key in enKeys) {
        expect(
          arArb.containsKey(key),
          isTrue,
          reason: 'ar ARB is missing key "$key"',
        );
        final arValue = arArb[key];
        expect(
          arValue,
          isA<String>(),
          reason: 'ar key "$key" should be a String',
        );
        expect(
          (arValue as String).trim(),
          isNotEmpty,
          reason: 'ar key "$key" must not be an empty string',
        );
      }
    });
  });
}
