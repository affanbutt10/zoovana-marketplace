/// Static API key constants.
///
/// ⚠️  These values are compiled into the binary.
/// For production builds, migrate them to a secure environment config using
/// `--dart-define` at build time so they are not shipped in plain text:
///
/// ```sh
/// flutter run --dart-define=GOOGLE_MAPS_KEY=your_key_here
/// ```
///
/// Then read them here with [String.fromEnvironment]:
/// ```dart
/// static const String googleMapsKey =
///     String.fromEnvironment('GOOGLE_MAPS_KEY');
/// ```
abstract final class ApiKeys {
  // Add API keys below. Example:
  // static const String googleMapsKey =
  //     String.fromEnvironment('GOOGLE_MAPS_KEY', defaultValue: '');
  //
  // static const String stripePublishableKey =
  //     String.fromEnvironment('STRIPE_KEY', defaultValue: '');
}
