import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../apis/services/google_auth_client.dart';
import '../../../apis/services/auth_service.dart';
import '../../../core/api/response_parser.dart';

class AuthRepository {
  AuthRepository({
    required this.service,
    required this.storage,
    required this.googleAuthClient,
  });

  final AuthService service;
  final FlutterSecureStorage storage;
  final GoogleAuthClient googleAuthClient;

  Future<bool> isAuthenticated() async {
    final token = await storage.read(key: 'access_token');
    debugPrint(
      '[AuthRepository] isAuthenticated — token present: ${token != null && token.isNotEmpty}',
    );
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    debugPrint('[AuthRepository] login — calling service');
    // Real response: {success, message, data: {client_id, email, full_name,
    //   access_token, refresh_token, token_type, expires_in}}
    final data = await service.login(email, password);
    debugPrint('[AuthRepository] login — response keys: ${data.keys.toList()}');
    await _persistTokens(data);
    return data;
  }

  Future<Map<String, dynamic>?> loginWithGoogle() async {
    debugPrint('[AuthRepository] loginWithGoogle — starting Google auth');
    final idToken = await googleAuthClient.getGoogleIdToken();
    final data = await service.socialLoginWithGoogle(idToken);
    debugPrint(
      '[AuthRepository] loginWithGoogle — response keys: ${data.keys.toList()}',
    );
    await _persistTokens(data);
    await storage.write(key: 'auth_provider', value: 'google');
    return data;
  }

  Future<Map<String, dynamic>> refreshSession() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    debugPrint(
      '[AuthRepository] refreshSession — refreshToken present: ${refreshToken != null}',
    );
    if (refreshToken == null || refreshToken.isEmpty) {
      return <String, dynamic>{};
    }
    final data = await service.refresh(refreshToken);
    debugPrint(
      '[AuthRepository] refreshSession — response keys: ${data.keys.toList()}',
    );
    await _persistTokens(data);
    return data;
  }

  Future<Map<String, dynamic>> getSession() {
    debugPrint('[AuthRepository] getSession — calling service');
    return service.getSession();
  }

  /// Registers a new client.
  ///
  /// The real API response does NOT include tokens — it only returns
  /// `{client_id, email, full_name, message}` and requires email verification.
  /// Tokens are NOT persisted here; the caller should redirect to login.
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name, {
    String? phone,
  }) async {
    debugPrint('[AuthRepository] register — calling service');
    // Real response: {success, message, data: {client_id, email, full_name, message}}
    // No tokens — do not call _persistTokens.
    final data = await service.register(email, password, name, phone: phone);
    debugPrint(
      '[AuthRepository] register — response keys: ${data.keys.toList()}',
    );
    return data;
  }

  Future<void> forgotPassword(String email) {
    debugPrint('[AuthRepository] forgotPassword — calling service for: $email');
    return service
        .forgotPassword(email)
        .catchError((_) => Future<void>.value());
  }

  Future<void> logout() async {
    debugPrint('[AuthRepository] logout — calling service');
    try {
      await service.logout();
      debugPrint('[AuthRepository] logout — service call succeeded');
    } catch (e) {
      debugPrint('[AuthRepository] logout — service call failed (ignored): $e');
    }
    await storage.deleteAll();
    try {
      await googleAuthClient.signOutGoogle();
    } catch (e) {
      debugPrint('[AuthRepository] logout — Google sign-out failed: $e');
    }
    debugPrint('[AuthRepository] logout — secure storage cleared');
  }

  Future<void> _persistTokens(Map<String, dynamic> data) async {
    final payload = ResponseParser.flatten(data);
    final accessToken = _readString(payload, const [
      'access_token',
      'accessToken',
      'token',
    ]);
    final refreshToken = _readString(payload, const [
      'refresh_token',
      'refreshToken',
    ]);
    debugPrint(
      '[AuthRepository] _persistTokens — accessToken found: ${accessToken != null} | refreshToken found: ${refreshToken != null}',
    );
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  String? _readString(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = payload[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
