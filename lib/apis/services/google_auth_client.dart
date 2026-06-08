import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthCancelledException implements Exception {
  const GoogleAuthCancelledException([this.message]);

  final String? message;
}

class GoogleAuthClient {
  GoogleAuthClient({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  static const String googleClientId =
      '573527714664-5dlvbi42q8kronqvtf2mm7kc90dbjt5p.apps.googleusercontent.com';
  static const String androidClientId =
      '573527714664-3tgh6v5qj16klredpifl6ektc31v6m4o.apps.googleusercontent.com';
  static const String iosClientId =
      '573527714664-2gt010np53f3s58ijib2miuvsjtvb79v.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await _googleSignIn.initialize(
      clientId: _platformClientId,
      serverClientId: googleClientId,
    );
    _initialized = true;
  }

  String? get _platformClientId {
    if (kIsWeb) return googleClientId;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return iosClientId;
      case TargetPlatform.android:
        return null;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return googleClientId;
    }
  }

  Future<String> getGoogleIdToken() async {
    await initialize();
    if (!_googleSignIn.supportsAuthenticate()) {
      throw UnsupportedError(
        'Google Sign-In interactive authentication is not supported on this platform.',
      );
    }

    try {
      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw StateError('Google did not return an idToken.');
      }
      return idToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw GoogleAuthCancelledException(
          error.description ?? 'Google Sign-In was cancelled or misconfigured.',
        );
      }
      rethrow;
    }
  }

  Future<void> signOutGoogle() async {
    await initialize();
    await _googleSignIn.signOut();
  }
}
