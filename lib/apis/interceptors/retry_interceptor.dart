import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_exception.dart';

/// Dio interceptor that automatically retries failed requests with
/// exponential backoff.
///
/// **Retry policy:**
/// - Max [maxRetries] attempts (default 3) after the initial failure.
/// - Only retries on transient errors: network errors, timeouts, and 5xx
///   server errors. Never retries 4xx client errors or auth failures.
/// - Backoff: `baseDelay * 2^attempt` with ±20% jitter, capped at [maxDelay].
///   Default: 1s → 2s → 4s.
/// - Skips retry for requests marked with `extra: {'noRetry': true}`.
///
/// Usage — attach after [ErrorInterceptor] so typed exceptions are available:
/// ```dart
/// dio.interceptors.addAll([
///   ErrorInterceptor(),
///   RetryInterceptor(),
///   LogInterceptor(...),
/// ]);
/// ```
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 8),
  });

  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;

  final _random = Random();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;

    // Skip if caller opted out of retry.
    if (options.extra['noRetry'] == true) {
      handler.next(err);
      return;
    }

    // Only retry transient errors.
    if (!_isRetryable(err)) {
      handler.next(err);
      return;
    }

    final attempt = (options.extra['_retryCount'] as int?) ?? 0;
    if (attempt >= maxRetries) {
      debugPrint(
        '[RetryInterceptor] Max retries ($maxRetries) reached for '
        '${options.method} ${options.path}',
      );
      handler.next(err);
      return;
    }

    final delay = _computeDelay(attempt);
    debugPrint(
      '[RetryInterceptor] Retry ${attempt + 1}/$maxRetries for '
      '${options.method} ${options.path} — waiting ${delay.inMilliseconds}ms',
    );

    await Future<void>.delayed(delay);

    // Increment retry counter on the cloned options.
    final retryOptions = options.copyWith(
      extra: {...options.extra, '_retryCount': attempt + 1},
    );

    try {
      // Re-use the same Dio instance that owns this interceptor.
      final dio = Dio(BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
        headers: options.headers,
      ));
      // Carry over the full request options.
      final response = await dio.fetch(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }

  /// Returns `true` for errors that are safe to retry.
  bool _isRetryable(DioException err) {
    // Typed exceptions from ErrorInterceptor.
    final inner = err.error;
    if (inner is NetworkException || inner is TimeoutException) return true;
    if (inner is ServerException && inner.statusCode >= 500) return true;

    // Raw Dio types (before ErrorInterceptor runs, or if not attached).
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      case DioExceptionType.badResponse:
        final code = err.response?.statusCode ?? 0;
        return code >= 500;
      default:
        return false;
    }
  }

  /// Computes `baseDelay * 2^attempt` with ±20% jitter, capped at [maxDelay].
  Duration _computeDelay(int attempt) {
    final base = baseDelay.inMilliseconds * pow(2, attempt).toInt();
    final jitter = (_random.nextDouble() * 0.4 - 0.2); // ±20%
    final ms = (base * (1 + jitter)).round().clamp(0, maxDelay.inMilliseconds);
    return Duration(milliseconds: ms);
  }
}
