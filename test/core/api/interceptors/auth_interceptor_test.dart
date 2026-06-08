// Feature: zoovana-app-ui, Property 27: Auth interceptor attaches Bearer token
// Feature: zoovana-app-ui, Property 28: Token refresh on 401

import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/core/api/exceptions.dart';
import 'package:zoovana/core/api/interceptors/auth.dart';

// ---------------------------------------------------------------------------
// Minimal mock for FlutterSecureStorage
// ---------------------------------------------------------------------------

class MockSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _store[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _store.remove(key);

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _store.clear();

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      Map.unmodifiable(_store);

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _store.containsKey(key);

  // Unused members required by the interface — delegate to noSuchMethod.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  AndroidOptions get aOptions => const AndroidOptions();
  @override
  IOSOptions get iOptions => const IOSOptions();
  @override
  LinuxOptions get lOptions => const LinuxOptions();
  @override
  MacOsOptions get mOptions => const MacOsOptions();
  @override
  WebOptions get webOptions => const WebOptions();
  @override
  WindowsOptions get wOptions => const WindowsOptions();
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Generates a random alphanumeric token of [length] characters.
String _randomToken(Random rng, {int length = 32}) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-';
  return List.generate(length, (_) => chars[rng.nextInt(chars.length)]).join();
}

/// Runs [TokenInterceptor.onRequest] and returns the mutated [RequestOptions].
///
/// Because [Interceptor.onRequest] is synchronous (void), we use a
/// [Completer] to capture the result from the handler callback.
Future<RequestOptions> _runOnRequest(
  TokenInterceptor interceptor,
  RequestOptions options,
) {
  final completer = Completer<RequestOptions>();
  final handler = _CapturingRequestHandler(
    onNext: completer.complete,
    onReject: (e) => completer.completeError(e),
  );
  interceptor.onRequest(options, handler);
  return completer.future;
}

/// Runs [TokenInterceptor.onError] and returns the captured [DioException].
Future<_ErrorResult> _runOnError(
  TokenInterceptor interceptor,
  DioException err,
) {
  final completer = Completer<_ErrorResult>();
  final handler = _CapturingErrorHandler(
    onNext: (e) => completer.complete(_ErrorResult(passed: e)),
    onReject: (e) => completer.complete(_ErrorResult(rejected: e)),
    onResolve: (r) => completer.complete(_ErrorResult(resolved: r)),
  );
  interceptor.onError(err, handler);
  return completer.future;
}

class _ErrorResult {
  _ErrorResult({this.passed, this.rejected, this.resolved});
  final DioException? passed;
  final DioException? rejected;
  final Response? resolved;
}

class _CapturingRequestHandler extends RequestInterceptorHandler {
  _CapturingRequestHandler({
    required this.onNext,
    required this.onReject,
  });

  final void Function(RequestOptions) onNext;
  final void Function(DioException) onReject;

  @override
  void next(RequestOptions requestOptions) => onNext(requestOptions);

  @override
  void reject(DioException err, [bool callFollowingErrorInterceptor = false]) =>
      onReject(err);
}

class _CapturingErrorHandler extends ErrorInterceptorHandler {
  _CapturingErrorHandler({
    required this.onNext,
    required this.onReject,
    required this.onResolve,
  });

  final void Function(DioException) onNext;
  final void Function(DioException) onReject;
  final void Function(Response) onResolve;

  @override
  void next(DioException err) => onNext(err);

  @override
  void reject(DioException err, [bool callFollowingErrorInterceptor = false]) =>
      onReject(err);

  @override
  void resolve(Response response,
          [bool callFollowingResponseInterceptor = false]) =>
      onResolve(response);
}

// ---------------------------------------------------------------------------
// Property 27: Auth interceptor attaches Bearer token
// ---------------------------------------------------------------------------

/// Validates: Requirements 16.4
///
/// For any outgoing Dio request when `access_token` is present in
/// FlutterSecureStorage, the request `headers['Authorization']` shall equal
/// `'Bearer {access_token}'`.
void main() {
  group('Property 27: Auth interceptor attaches Bearer token', () {
    test(
      'Authorization header is set to Bearer <token> for 100 random tokens',
      () async {
        final rng = Random(42); // fixed seed for reproducibility

        for (var i = 0; i < 100; i++) {
          final token = _randomToken(rng, length: 20 + rng.nextInt(44));
          final storage = MockSecureStorage();
          await storage.write(key: 'access_token', value: token);

          final interceptor = TokenInterceptor(
            storage,
            getDio: Dio.new,
          );

          final options = RequestOptions(path: '/products');
          final result = await _runOnRequest(interceptor, options);

          expect(
            result.headers['Authorization'],
            equals('Bearer $token'),
            reason:
                'Iteration $i: expected "Bearer $token" but got '
                '"${result.headers['Authorization']}"',
          );
        }
      },
    );

    test('no Authorization header when access_token is absent', () async {
      final storage = MockSecureStorage(); // empty — no token stored
      final interceptor = TokenInterceptor(storage, getDio: Dio.new);

      final options = RequestOptions(path: '/products');
      final result = await _runOnRequest(interceptor, options);

      expect(
        result.headers.containsKey('Authorization'),
        isFalse,
        reason: 'Authorization header should not be set when no token exists',
      );
    });

    test(
      'Authorization header uses the exact token value (no trimming/encoding)',
      () async {
        const specialTokens = [
          'abc.def_ghi-jkl',
          'UPPER_lower_123',
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.payload.signature',
        ];

        for (final token in specialTokens) {
          final storage = MockSecureStorage();
          await storage.write(key: 'access_token', value: token);

          final interceptor = TokenInterceptor(storage, getDio: Dio.new);
          final options = RequestOptions(path: '/test');
          final result = await _runOnRequest(interceptor, options);

          expect(result.headers['Authorization'], equals('Bearer $token'));
        }
      },
    );
  });

  // -------------------------------------------------------------------------
  // Property 28: Token refresh on 401
  // -------------------------------------------------------------------------

  /// Validates: Requirements 16.2, 16.3
  ///
  /// For any API response with HTTP status 401, the AuthInterceptor shall
  /// attempt exactly one token refresh before either retrying the original
  /// request (on success) or clearing tokens and redirecting to /login
  /// (on failure).
  group('Property 28: Token refresh on 401', () {
    test('on refresh failure: deleteAll is called and AuthException propagated',
        () async {
      final storage = MockSecureStorage();
      await storage.write(key: 'access_token', value: 'old-access');
      await storage.write(key: 'refresh_token', value: 'old-refresh');

      bool authFailureCalled = false;

      final interceptor = TokenInterceptor(
        storage,
        getDio: Dio.new,
        onAuthFailure: () async {
          authFailureCalled = true;
        },
        // Point to a non-existent endpoint so the refresh POST fails.
        refreshEndpoint: 'https://0.0.0.0:1/auth/refresh',
      );

      final requestOptions = RequestOptions(path: '/orders');
      final dioErr = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      final result = await _runOnError(interceptor, dioErr);

      // Tokens must be cleared.
      expect(
        await storage.read(key: 'access_token'),
        isNull,
        reason: 'access_token should be deleted after refresh failure',
      );
      expect(
        await storage.read(key: 'refresh_token'),
        isNull,
        reason: 'refresh_token should be deleted after refresh failure',
      );

      // onAuthFailure callback must have been invoked.
      expect(authFailureCalled, isTrue);

      // An AuthException must be propagated.
      expect(result.rejected, isNotNull);
      expect(result.rejected!.error, isA<AuthException>());
    });

    test('non-401 errors are passed through without refresh attempt', () async {
      final storage = MockSecureStorage();
      await storage.write(key: 'access_token', value: 'token');
      await storage.write(key: 'refresh_token', value: 'refresh');

      bool authFailureCalled = false;
      final interceptor = TokenInterceptor(
        storage,
        getDio: Dio.new,
        onAuthFailure: () async {
          authFailureCalled = true;
        },
      );

      final requestOptions = RequestOptions(path: '/products');
      final dioErr = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );

      final result = await _runOnError(interceptor, dioErr);

      expect(result.passed, isNotNull, reason: '500 error should be passed through');
      expect(authFailureCalled, isFalse);
      // Tokens must remain intact.
      expect(await storage.read(key: 'access_token'), equals('token'));
    });

    test('401 without refresh token clears storage and propagates AuthException',
        () async {
      final storage = MockSecureStorage();
      await storage.write(key: 'access_token', value: 'old-access');
      // No refresh_token stored.

      bool authFailureCalled = false;
      final interceptor = TokenInterceptor(
        storage,
        getDio: Dio.new,
        onAuthFailure: () async {
          authFailureCalled = true;
        },
      );

      final requestOptions = RequestOptions(path: '/cart');
      final dioErr = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      final result = await _runOnError(interceptor, dioErr);

      expect(result.rejected?.error, isA<AuthException>());
      expect(authFailureCalled, isTrue);
      expect(await storage.read(key: 'access_token'), isNull);
    });

    test(
      'refresh failure clears tokens for 100 random token pairs',
      () async {
        final rng = Random(99);

        for (var i = 0; i < 100; i++) {
          final accessToken = _randomToken(rng);
          final refreshToken = _randomToken(rng);

          final storage = MockSecureStorage();
          await storage.write(key: 'access_token', value: accessToken);
          await storage.write(key: 'refresh_token', value: refreshToken);

          final interceptor = TokenInterceptor(
            storage,
            getDio: Dio.new,
            onAuthFailure: () async {},
            refreshEndpoint: 'https://0.0.0.0:1/auth/refresh',
          );

          final requestOptions = RequestOptions(path: '/test');
          final dioErr = DioException(
            requestOptions: requestOptions,
            response: Response(
              requestOptions: requestOptions,
              statusCode: 401,
            ),
            type: DioExceptionType.badResponse,
          );

          final result = await _runOnError(interceptor, dioErr);

          expect(
            await storage.read(key: 'access_token'),
            isNull,
            reason: 'Iteration $i: access_token should be cleared',
          );
          expect(
            await storage.read(key: 'refresh_token'),
            isNull,
            reason: 'Iteration $i: refresh_token should be cleared',
          );
          expect(
            result.rejected?.error,
            isA<AuthException>(),
            reason: 'Iteration $i: AuthException should be propagated',
          );
        }
      },
    );
  });
}
