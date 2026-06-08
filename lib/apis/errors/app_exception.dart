/// Typed application exceptions produced by the API layer.
///
/// All [DioException] errors are mapped to one of these subclasses by
/// [ErrorInterceptor] so callers can handle them with exhaustive pattern
/// matching instead of inspecting raw Dio internals.
///
/// ```dart
/// try {
///   await repository.loadSomething();
/// } on NetworkException {
///   // show offline banner
/// } on AuthException {
///   // session expired — already handled by TokenInterceptor
/// } on ServerException catch (e) {
///   // e.statusCode is available
/// } on TimeoutException {
///   // show retry prompt
/// }
/// ```
library;

/// Base class for all application-level API exceptions.
abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when there is no network connectivity or the connection was refused.
///
/// Corresponds to [DioExceptionType.connectionError] and
/// [DioExceptionType.connectionTimeout].
class NetworkException extends AppException {
  const NetworkException([super.message = 'No network connectivity']);
}

/// Thrown when the server returns a 4xx or 5xx HTTP response.
class ServerException extends AppException {
  const ServerException(this.statusCode, [String message = 'Server error'])
      : super(message);

  final int statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown when a 401 response is received after a failed token refresh.
///
/// Signals that the user must re-authenticate.
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed']);
}

/// Thrown when a request or response times out.
///
/// Corresponds to [DioExceptionType.sendTimeout] and
/// [DioExceptionType.receiveTimeout].
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out']);
}
