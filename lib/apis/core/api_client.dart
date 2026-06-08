
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_endpoints.dart';
import '../interceptors/token_interceptor.dart';
import '../interceptors/retry_interceptor.dart';
import '../errors/error_handler.dart';

/// Singleton API client used throughout the app.
///
/// Owns three [Dio] instances scoped to each backend service:
/// - [authDio]   — authentication service (no token injection)
/// - [marketDio] — catalogue, cart, orders, receipts (token + error interceptors)
/// - [mainDio]   — profile / mp-clients (token + error interceptors)
///
/// Call [configure] once at app startup to wire the [onAuthFailure] callback
/// that clears tokens and redirects to `/login`.
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late final Dio authDio;
  late final Dio marketDio;
  late final Dio mainDio;
  late final Dio petcareDio;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  OnAuthFailure? _onAuthFailure;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    authDio = _buildDio(ApiEndpoints.authBaseUrl);
    marketDio = _buildDio(
      ApiEndpoints.marketBaseUrl,
      attachAuthInterceptor: true,
    );
    mainDio = _buildDio(
      ApiEndpoints.mainBaseUrl,
      attachAuthInterceptor: true,
    );
    petcareDio = _buildDio(
      ApiEndpoints.petcareBaseUrl,
      attachAuthInterceptor: true,
    );
  }

  /// Wire the auth-failure callback once at app startup.
  ///
  /// The callback should clear auth state and redirect to `/login`.
  void configure({required OnAuthFailure onAuthFailure}) {
    _onAuthFailure = onAuthFailure;
    _replaceAuthInterceptor(marketDio);
    _replaceAuthInterceptor(mainDio);
    _replaceAuthInterceptor(petcareDio);
  }

  Dio _buildDio(String baseUrl, {bool attachAuthInterceptor = false}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (attachAuthInterceptor) {
      dio.interceptors.add(_buildTokenInterceptor(() => dio));
    }

    dio.interceptors.addAll([
      ErrorInterceptor(),
      RetryInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }

  TokenInterceptor _buildTokenInterceptor(Dio Function() getDio) {
    return TokenInterceptor(
      secureStorage,
      getDio: getDio,
      onAuthFailure: _onAuthFailure,
      refreshEndpoint:
          '${ApiEndpoints.authBaseUrl}${ApiEndpoints.refreshPath}',
    );
  }

  void _replaceAuthInterceptor(Dio dio) {
    dio.interceptors.removeWhere(
      (interceptor) => interceptor is TokenInterceptor,
    );
    dio.interceptors.insert(0, _buildTokenInterceptor(() => dio));
  }
}
