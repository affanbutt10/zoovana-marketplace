import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/api/exceptions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_localizations_en.dart';
import 'app_error.dart';

abstract final class AppErrorMapper {
  /// Whether [error] from add-to-cart / checkout indicates insufficient stock.
  static bool isOutOfStockError(Object error) {
    return _outOfStockHint(error) != null;
  }

  /// User-facing message for stock-related failures.
  static String outOfStockMessage() {
    return _message((l10n) => l10n.outOfStock);
  }

  static AppError map(Object error) {
    final stockHint = _outOfStockHint(error);
    if (stockHint != null) {
      return AppError(
        type: AppErrorType.server,
        message: outOfStockMessage(),
      );
    }
    // ── 1. Already a typed AppException ──────────────────────────────────────
    if (error is AuthException) {
      return AppError(
        type: AppErrorType.auth,
        message: _message((l10n) => l10n.errorSessionExpired),
      );
    }
    if (error is NetworkException) {
      return AppError(
        type: AppErrorType.offline,
        message: _message((l10n) => l10n.errorNoInternet),
        canRetry: true,
      );
    }
    if (error is TimeoutException) {
      return AppError(
        type: AppErrorType.timeout,
        message: _message((l10n) => l10n.errorTimeout),
        canRetry: true,
      );
    }
    if (error is ServerException) {
      return _mapServerException(error);
    }

    // ── 2. DioException — unwrap the typed inner exception ───────────────────
    if (error is DioException) {
      final inner = error.error;
      if (inner is AppException) {
        // Recurse with the unwrapped typed exception.
        return map(inner);
      }
      // DioException without a typed inner — map by type.
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
          return AppError(
            type: AppErrorType.offline,
            message: _message((l10n) => l10n.errorNoInternet),
            canRetry: true,
          );
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return AppError(
            type: AppErrorType.timeout,
            message: _message((l10n) => l10n.errorTimeout),
            canRetry: true,
          );
        case DioExceptionType.badResponse:
          final code = error.response?.statusCode ?? 0;
          final msg = _extractResponseMessage(error);
          return _mapStatusCode(code, msg);
        default:
          return AppError(
            type: AppErrorType.unknown,
            message: _message((l10n) => l10n.errorTryAgain),
            canRetry: true,
          );
      }
    }

    // ── 3. Generic fallback ───────────────────────────────────────────────────
    return AppError(
      type: AppErrorType.unknown,
      message: _message((l10n) => l10n.errorTryAgain),
      canRetry: true,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static AppError _mapServerException(ServerException e) {
    return _mapStatusCode(e.statusCode, e.message);
  }

  static AppError _mapStatusCode(int code, String? rawMessage) {
    if (_messageImpliesOutOfStock(rawMessage)) {
      return AppError(
        type: AppErrorType.server,
        statusCode: code,
        message: outOfStockMessage(),
      );
    }
    switch (code) {
      case 400:
        return AppError(
          type: AppErrorType.server,
          statusCode: code,
          message: rawMessage?.isNotEmpty == true
              ? rawMessage!
              : _message((l10n) => l10n.errorInvalidRequest),
        );
      case 401:
        // On login screens this means wrong credentials.
        // On other screens it means session expired (handled by TokenInterceptor).
        return AppError(
          type: AppErrorType.auth,
          statusCode: code,
          message: _message((l10n) => l10n.errorWrongCredentials),
        );
      case 403:
        return AppError(
          type: AppErrorType.auth,
          statusCode: 403,
          message: _message((l10n) => l10n.errorPermissionDenied),
        );
      case 404:
        return AppError(
          type: AppErrorType.server,
          statusCode: 404,
          message: _message((l10n) => l10n.errorResourceNotFound),
        );
      case 409:
        return AppError(
          type: AppErrorType.server,
          statusCode: code,
          message: _messageImpliesOutOfStock(rawMessage)
              ? outOfStockMessage()
              : (rawMessage?.isNotEmpty == true
                  ? rawMessage!
                  : _message((l10n) => l10n.errorConflict)),
        );
      case 422:
        return AppError(
          type: AppErrorType.server,
          statusCode: code,
          message: rawMessage?.isNotEmpty == true
              ? rawMessage!
              : _message((l10n) => l10n.errorCheckInput),
        );
      case 429:
        return AppError(
          type: AppErrorType.server,
          statusCode: 429,
          message: _message((l10n) => l10n.errorTooManyRequests),
          canRetry: true,
        );
      default:
        if (code >= 500) {
          return AppError(
            type: AppErrorType.server,
            message: _message((l10n) => l10n.errorServerDown),
            canRetry: true,
          );
        }
        return AppError(
          type: AppErrorType.server,
          statusCode: code,
          message: rawMessage?.isNotEmpty == true
              ? rawMessage!
              : _message((l10n) => l10n.errorTryAgain),
        );
    }
  }

  static String _message(String Function(AppLocalizations l10n) select) {
    final context = Get.context;
    final l10n = context == null
        ? AppLocalizationsEn()
        : AppLocalizations.of(context) ?? AppLocalizationsEn();
    return select(l10n);
  }

  static String? _extractResponseMessage(DioException err) {
    return _extractMessageFromBody(err.response?.data);
  }

  static String? _outOfStockHint(Object error) {
    if (error is DioException) {
      final inner = error.error;
      if (inner is ServerException &&
          _messageImpliesOutOfStock(inner.message)) {
        return inner.message;
      }
      final body = error.response?.data;
      if (_bodyImpliesOutOfStock(body)) {
        return _extractMessageFromBody(body);
      }
    }
    if (error is ServerException &&
        _messageImpliesOutOfStock(error.message)) {
      return error.message;
    }
    return null;
  }

  static String? _extractMessageFromBody(dynamic data) {
    try {
      if (data is Map) {
        final top = (data['message'] ?? data['error'] ?? data['detail'])
            ?.toString();
        if (_messageImpliesOutOfStock(top)) return top;

        final errors = data['errors'];
        if (errors is List && _listImpliesOutOfStock(errors)) {
          return top ?? errors.first.toString();
        }

        final nested = data['data'];
        if (nested is Map) {
          final issues = nested['issues'];
          if (issues is List && _listImpliesOutOfStock(issues)) {
            return top ?? issues.first.toString();
          }
        }
        return top;
      }
    } catch (_) {}
    return null;
  }

  static bool _bodyImpliesOutOfStock(dynamic data) {
    if (data is! Map) return false;
    if (_messageImpliesOutOfStock(
      (data['message'] ?? data['error'])?.toString(),
    )) {
      return true;
    }
    if (data['errors'] is List && _listImpliesOutOfStock(data['errors'])) {
      return true;
    }
    final nested = data['data'];
    if (nested is Map && nested['issues'] is List) {
      return _listImpliesOutOfStock(nested['issues']);
    }
    return false;
  }

  static bool _listImpliesOutOfStock(List<dynamic> items) {
    for (final item in items) {
      final text = item.toString().toLowerCase();
      if (text.contains('out_of_stock') ||
          text.contains('out of stock') ||
          text.contains('insufficient') ||
          text.contains('stock')) {
        return true;
      }
    }
    return false;
  }

  static bool _messageImpliesOutOfStock(String? message) {
    if (message == null || message.isEmpty) return false;
    final lower = message.toLowerCase();
    return lower.contains('out_of_stock') ||
        lower.contains('out of stock') ||
        lower.contains('insufficient stock') ||
        lower.contains('not in stock') ||
        lower.contains('no stock');
  }
}
