import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/api_endpoints.dart';
import '../errors/app_exception.dart';
import '../../l10n/app_localizations_en.dart';

/// Callback invoked when token refresh fails and the user must be signed out.
///
/// Implementations should clear auth state and redirect to `/login`.
typedef OnAuthFailure = Future<void> Function();

/// Attaches the Bearer access token to every outgoing request and handles 401
/// responses by attempting a silent token refresh.
///
/// Flow:
/// 1. [onRequest] — reads `access_token` from secure storage and injects it
///    as `Authorization: Bearer <token>`. Skips routes marked with
///    `extra: {'skipAuth': true}`.
/// 2. [onError] — on a 401, reads `refresh_token` and calls the refresh
///    endpoint. On success, stores the new tokens and retries the original
///    request transparently. On failure, calls [onAuthFailure] and propagates
///    an [AuthException].
///
/// The retry reuses the shared [Dio] instance supplied via [getDio] to ensure
/// the same interceptor chain and base options are applied.
class TokenInterceptor extends Interceptor {
  TokenInterceptor(
    this.secureStorage, {
    required this.getDio,
    this.onAuthFailure,
    this.refreshEndpoint =
        '${ApiEndpoints.authBaseUrl}${ApiEndpoints.refreshPath}',
  });

  final FlutterSecureStorage secureStorage;

  /// Returns the shared [Dio] instance — avoids creating a new one on retry.
  final Dio Function() getDio;

  /// Called when refresh fails so the app can clear state and navigate to
  /// `/login`. May be null in test environments.
  final OnAuthFailure? onAuthFailure;

  final String refreshEndpoint;

  /// Guard against infinite retry loops.
  bool _isRefreshing = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldSkipTokenHandling(options)) {
      debugPrint(
        '[TokenInterceptor] onRequest — skipping auth: '
        '${options.method} ${options.path}',
      );
      handler.next(options);
      return;
    }

    final accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      debugPrint(
        '[TokenInterceptor] onRequest — token attached: '
        '${options.method} ${options.path}',
      );
    } else {
      debugPrint(
        '[TokenInterceptor] onRequest — no token found: '
        '${options.method} ${options.path}',
      );
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
      '[TokenInterceptor] onError — ${err.response?.statusCode} '
      '${err.requestOptions.method} ${err.requestOptions.path}',
    );

    if (_shouldSkipTokenHandling(err.requestOptions) ||
        err.response?.statusCode != 401 ||
        _isRefreshing) {
      handler.next(err);
      return;
    }

    debugPrint('[TokenInterceptor] onError — 401 detected, attempting refresh');
    final refreshToken = await secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) {
      debugPrint('[TokenInterceptor] onError — no refresh token available');
      await _handleAuthFailure(handler, err);
      return;
    }

    _isRefreshing = true;
    try {
      final refreshDio = Dio();
      final response = await refreshDio.post(
        refreshEndpoint,
        data: {'refresh_token': refreshToken},
      );
      debugPrint(
        '[TokenInterceptor] onError — refresh status: ${response.statusCode}',
      );

      final payload = _flatten(_asMap(response.data));
      final newAccessToken = _readString(payload, const [
        'access_token',
        'accessToken',
        'token',
      ]);
      final newRefreshToken = _readString(payload, const [
        'refresh_token',
        'refreshToken',
      ]);

      if (newAccessToken == null) {
        debugPrint(
          '[TokenInterceptor] onError — no access_token in refresh response',
        );
        await _handleAuthFailure(handler, err);
        return;
      }

      await secureStorage.write(key: 'access_token', value: newAccessToken);
      if (newRefreshToken != null) {
        await secureStorage.write(key: 'refresh_token', value: newRefreshToken);
      }

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await getDio().fetch(retryOptions);
      debugPrint(
        '[TokenInterceptor] onError — retry succeeded: '
        '${retryResponse.statusCode}',
      );
      handler.resolve(retryResponse);
    } catch (e) {
      debugPrint('[TokenInterceptor] onError — refresh failed: $e');
      await _handleAuthFailure(handler, err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleAuthFailure(
    ErrorInterceptorHandler handler,
    DioException originalErr,
  ) async {
    debugPrint(
      '[TokenInterceptor] _handleAuthFailure — clearing storage, '
      'triggering logout',
    );
    await secureStorage.deleteAll();
    await onAuthFailure?.call();
    final message = AppLocalizationsEn().errorSessionExpired;
    handler.reject(
      DioException(
        requestOptions: originalErr.requestOptions,
        response: originalErr.response,
        type: originalErr.type,
        error: AuthException(message),
        message: message,
      ),
    );
  }

  bool _shouldSkipTokenHandling(RequestOptions options) {
    if (options.extra['skipAuth'] == true ||
        options.extra['skipAuthRefresh'] == true) {
      return true;
    }
    final path = options.path;
    return path.endsWith('/auth/login') ||
        path.endsWith('/auth/refresh') ||
        path.contains('/api/auth/session');
  }

  // ── Inline helpers (avoids importing ResponseParser here) ─────────────────

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return {};
  }

  Map<String, dynamic> _flatten(Map<String, dynamic> payload) {
    final out = <String, dynamic>{};
    for (final key in const ['data', 'result', 'tokens', 'session']) {
      final nested = payload[key];
      if (nested is Map) out.addAll(_asMap(nested));
    }
    out.addAll(payload);
    return out;
  }

  String? _readString(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = payload[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }
}
