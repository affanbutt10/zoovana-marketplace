/// Saudi phone number validator and normalizer.
///
/// Valid format: `05XXXXXXXX` (10 digits, starts with 05, followed by 8 digits).
/// Normalized format: `+9665XXXXXXXX`.
abstract final class PhoneValidator {
  static final _saudiPhoneRegex = RegExp(r'^05[0-9]{8}$');

  /// Returns null if [phone] is a valid Saudi mobile number (`05XXXXXXXX`),
  /// or an error string describing the problem.
  static String? validate(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }
    if (!_saudiPhoneRegex.hasMatch(phone)) {
      return 'Enter a valid Saudi phone number (e.g. 05XXXXXXXX)';
    }
    return null;
  }

  /// Converts `05XXXXXXXX` → `+9665XXXXXXXX`.
  ///
  /// Assumes [phone] has already been validated. If the phone does not match
  /// the expected format, it is returned unchanged.
  static String normalize(String phone) {
    if (_saudiPhoneRegex.hasMatch(phone)) {
      // Replace leading '05' with '+9665'
      return '+966${phone.substring(1)}';
    }
    return phone;
  }
}
