// Feature: zoovana-app-ui, Property 20: Saudi phone normalization
// Feature: zoovana-app-ui, Property 21: Saudi phone validation rejection

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/core/validators/phone_validator.dart';

// ---------------------------------------------------------------------------
// Property 20: Saudi phone normalization
// **Validates: Requirements 10.3**
//
// For any string of the form `05XXXXXXXX` (where X is a digit, 8 digits
// after `05`), the phone normalization function shall produce `+9665XXXXXXXX`.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Property 21: Saudi phone validation rejection
// **Validates: Requirements 10.4**
//
// For any string that does not match the pattern `^05[0-9]{8}$`, the phone
// validation function shall return an error (non-null error string).
// ---------------------------------------------------------------------------

String _randomDigits(Random rng, int count) {
  return List.generate(count, (_) => rng.nextInt(10).toString()).join();
}

/// Generates a valid Saudi phone: 05 + 8 random digits.
String _validPhone(Random rng) => '05${_randomDigits(rng, 8)}';

/// Generates an invalid phone (various patterns that don't match 05XXXXXXXX).
String _invalidPhone(Random rng) {
  final type = rng.nextInt(6);
  switch (type) {
    case 0:
      // Wrong prefix (not 05)
      final prefix = rng.nextBool() ? '06' : '04';
      return '$prefix${_randomDigits(rng, 8)}';
    case 1:
      // Too short (< 10 chars)
      final len = 1 + rng.nextInt(9);
      return '05${_randomDigits(rng, len - 2 < 0 ? 0 : len - 2)}';
    case 2:
      // Too long (> 10 chars)
      return '05${_randomDigits(rng, 9 + rng.nextInt(5))}';
    case 3:
      // Contains letters
      return '05abc${_randomDigits(rng, 5)}';
    case 4:
      // Empty string
      return '';
    case 5:
      // Starts with +966 (already normalized, not the raw format)
      return '+9665${_randomDigits(rng, 8)}';
    default:
      return 'invalid';
  }
}

void main() {
  // =========================================================================
  // Property 20: Saudi phone normalization
  // =========================================================================

  group('Property 20: Saudi phone normalization', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests
    // -----------------------------------------------------------------------

    test('0512345678 normalizes to +966512345678', () {
      expect(PhoneValidator.normalize('0512345678'), equals('+966512345678'));
    });

    test('0598765432 normalizes to +966598765432', () {
      expect(PhoneValidator.normalize('0598765432'), equals('+966598765432'));
    });

    test('0500000000 normalizes to +966500000000', () {
      expect(PhoneValidator.normalize('0500000000'), equals('+966500000000'));
    });

    test('0599999999 normalizes to +966599999999', () {
      expect(PhoneValidator.normalize('0599999999'), equals('+966599999999'));
    });

    test('normalized number starts with +9665', () {
      expect(PhoneValidator.normalize('0512345678').startsWith('+9665'), isTrue);
    });

    test('normalized number has 13 characters', () {
      expect(PhoneValidator.normalize('0512345678').length, equals(13));
    });

    // -----------------------------------------------------------------------
    // Property-based: 100+ iterations
    // -----------------------------------------------------------------------

    test(
      '05XXXXXXXX always normalizes to +9665XXXXXXXX — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          final digits = _randomDigits(rng, 8);
          final phone = '05$digits';
          final normalized = PhoneValidator.normalize(phone);
          final expected = '+9665$digits';

          expect(
            normalized,
            equals(expected),
            reason:
                'Iteration $iter: normalize("$phone") must be "$expected" '
                'but got "$normalized"',
          );
        }
      },
    );

    test(
      'normalized number always starts with +9665 — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          final phone = _validPhone(rng);
          final normalized = PhoneValidator.normalize(phone);

          expect(
            normalized.startsWith('+9665'),
            isTrue,
            reason:
                'Iteration $iter: normalize("$phone") = "$normalized" '
                'must start with "+9665"',
          );
        }
      },
    );

    test(
      'normalized number always has 13 characters — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(13);

        for (var iter = 0; iter < iterations; iter++) {
          final phone = _validPhone(rng);
          final normalized = PhoneValidator.normalize(phone);

          expect(
            normalized.length,
            equals(13),
            reason:
                'Iteration $iter: normalize("$phone") = "$normalized" '
                'must have 13 chars but has ${normalized.length}',
          );
        }
      },
    );

    test(
      'last 8 digits are preserved after normalization — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(99);

        for (var iter = 0; iter < iterations; iter++) {
          final digits = _randomDigits(rng, 8);
          final phone = '05$digits';
          final normalized = PhoneValidator.normalize(phone);

          expect(
            normalized.endsWith(digits),
            isTrue,
            reason:
                'Iteration $iter: normalize("$phone") = "$normalized" '
                'must end with "$digits"',
          );
        }
      },
    );
  });

  // =========================================================================
  // Property 21: Saudi phone validation rejection
  // =========================================================================

  group('Property 21: Saudi phone validation rejection', () {
    // -----------------------------------------------------------------------
    // Deterministic unit tests
    // -----------------------------------------------------------------------

    test('valid phone 0512345678 returns null', () {
      expect(PhoneValidator.validate('0512345678'), isNull);
    });

    test('valid phone 0598765432 returns null', () {
      expect(PhoneValidator.validate('0598765432'), isNull);
    });

    test('empty string returns error', () {
      expect(PhoneValidator.validate(''), isNotNull);
    });

    test('null returns error', () {
      expect(PhoneValidator.validate(null), isNotNull);
    });

    test('wrong prefix 06 returns error', () {
      expect(PhoneValidator.validate('0612345678'), isNotNull);
    });

    test('too short returns error', () {
      expect(PhoneValidator.validate('051234567'), isNotNull);
    });

    test('too long returns error', () {
      expect(PhoneValidator.validate('05123456789'), isNotNull);
    });

    test('contains letters returns error', () {
      expect(PhoneValidator.validate('05abcdefgh'), isNotNull);
    });

    test('already normalized +966 format returns error', () {
      expect(PhoneValidator.validate('+966512345678'), isNotNull);
    });

    // -----------------------------------------------------------------------
    // Property-based: valid phones return null — 100 iterations
    // -----------------------------------------------------------------------

    test(
      'valid 05XXXXXXXX phones always return null — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(42);

        for (var iter = 0; iter < iterations; iter++) {
          final phone = _validPhone(rng);
          final result = PhoneValidator.validate(phone);

          expect(
            result,
            isNull,
            reason:
                'Iteration $iter: validate("$phone") must return null '
                'but got "$result"',
          );
        }
      },
    );

    // -----------------------------------------------------------------------
    // Property-based: invalid phones return non-null error — 100 iterations
    // -----------------------------------------------------------------------

    test(
      'invalid phones always return non-null error string — 100 iterations',
      () {
        const iterations = 100;
        final rng = Random(7);

        for (var iter = 0; iter < iterations; iter++) {
          final phone = _invalidPhone(rng);
          final result = PhoneValidator.validate(phone);

          expect(
            result,
            isNotNull,
            reason:
                'Iteration $iter: validate("$phone") must return an error '
                'string but got null',
          );
          expect(
            result,
            isA<String>(),
            reason:
                'Iteration $iter: error must be a String',
          );
          expect(
            result!.isNotEmpty,
            isTrue,
            reason:
                'Iteration $iter: error string must not be empty',
          );
        }
      },
    );
  });
}
