import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Dio interceptor that maps every [DioException] to a typed [AppException].
///
/// Attach this to every [Dio] instance so that service and repository callers
/// never need to inspect raw [DioException] internals — they catch typed
/// exceptions instead.
///
/// Registered automatically by [ApiClient] on all three Dio instances.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _map(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        message: appException.message,
      ),
    );
  }

  AppException _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.connectionTimeout:
        return const NetworkException('Connection timed out');
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final message = _extractMessage(err) ?? 'Server error';
        return ServerException(statusCode, message);
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');
      case DioExceptionType.badCertificate:
        return const NetworkException('Bad SSL certificate');
      case DioExceptionType.unknown:
        return NetworkException(err.message ?? 'Unknown network error');
    }
  }

  String? _extractMessage(DioException err) {
    try {
      final data = err.response?.data;
      if (data is Map) {
        final message = (data['message'] ?? data['error'])?.toString();
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          final first = errors.first.toString();
          if (message == null || message.isEmpty) return first;
        }
        final nested = data['data'];
        if (nested is Map && nested['issues'] is List) {
          final issues = nested['issues'] as List;
          if (issues.isNotEmpty && (message == null || message.isEmpty)) {
            return issues.first.toString();
          }
        }
        return message;
      }
    } catch (_) {}
    return null;
  }
}

/// Utility for converting any caught exception into a user-friendly message.
///
/// Use this in repository catch blocks to produce a consistent error string
/// without leaking internal Dio or Dart exception details to the UI.
///
/// ```dart
/// } catch (e) {
///   return ApiResult.failure(ErrorHandler.message(e));
/// }
/// ```
class ErrorHandler {
  const ErrorHandler._();

  /// Returns a human-readable message for [error].
  ///
  /// Handles [AppException] subclasses, [DioException], and generic [Exception]
  /// objects. Falls back to a generic message for unknown types.
  static String message(Object error) {
    if (error is AppException) return error.message;

    if (error is DioException) {
      final inner = error.error;
      if (inner is AppException) return inner.message;
      return error.message ?? 'An unexpected error occurred';
    }

    if (error is Exception) return error.toString();
    return 'An unexpected error occurred';
  }

  /// Returns `true` if [error] represents a network connectivity problem.
  static bool isNetworkError(Object error) {
    if (error is NetworkException) return true;
    if (error is DioException && error.error is NetworkException) return true;
    return false;
  }

  /// Returns `true` if [error] is an authentication failure.
  static bool isAuthError(Object error) {
    if (error is AuthException) return true;
    if (error is DioException && error.error is AuthException) return true;
    return false;
  }

  /// Returns `true` if [error] is a server-side error (4xx / 5xx).
  static bool isServerError(Object error) {
    if (error is ServerException) return true;
    if (error is DioException && error.error is ServerException) return true;
    return false;
  }
}

/// A lightweight result wrapper for repository return values.
///
/// Repositories can return `ApiResult<T>` instead of throwing, giving callers
/// a clean success/failure branch without try-catch boilerplate:
///
/// ```dart
/// final result = await productRepo.getProducts();
/// result.when(
///   success: (products) => setState(() => _products = products),
///   failure: (msg) => setState(() => _error = msg),
/// );
/// ```
class ApiResult<T> {
  const ApiResult._({this.data, this.errorMessage, required this.success});

  /// Creates a successful result carrying [data].
  const ApiResult.success(T data)
      : this._(data: data, success: true);

  /// Creates a failure result carrying a human-readable [errorMessage].
  const ApiResult.failure(String errorMessage)
      : this._(errorMessage: errorMessage, success: false);

  final T? data;
  final String? errorMessage;
  final bool success;

  bool get isSuccess => success;
  bool get isFailure => !success;

  /// Calls [success] with [data] or [failure] with [errorMessage].
  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    }
    return failure(errorMessage ?? 'Unknown error');
  }

  @override
  String toString() => isSuccess
      ? 'ApiResult.success($data)'
      : 'ApiResult.failure($errorMessage)';
}
