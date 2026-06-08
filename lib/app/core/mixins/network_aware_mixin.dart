import 'package:get/get.dart';

import '../services/connectivity_service.dart';
import '../errors/app_error.dart';
import '../../../l10n/app_localizations_en.dart';

/// Mixin for GetX controllers that need to guard API calls against
/// offline state and surface consistent network error messages.
///
/// Usage:
/// ```dart
/// class MyController extends GetxController with NetworkAwareMixin {
///   Future<void> loadData() async {
///     if (!isOnline) {
///       // Surface offline error to UI
///       handleOffline();
///       return;
///     }
///     // ... make API call
///   }
/// }
/// ```
mixin NetworkAwareMixin on GetxController {
  ConnectivityService get _connectivity => Get.find<ConnectivityService>();

  /// Returns `true` when the device has network connectivity.
  bool get isOnline => _connectivity.isOnline.value;

  /// Returns `true` when the device is offline.
  bool get isOffline => !isOnline;

  /// A standard offline [AppError] to surface in the UI.
  AppError get offlineError => AppError(
    type: AppErrorType.offline,
    message: AppLocalizationsEn().offlineCachedData,
    canRetry: true,
  );

  /// Runs [action] only when online.
  ///
  /// If offline, calls [onOffline] (defaults to a no-op).
  /// Returns `true` if [action] was executed, `false` if skipped.
  Future<bool> runIfOnline(
    Future<void> Function() action, {
    void Function()? onOffline,
  }) async {
    if (isOffline) {
      onOffline?.call();
      return false;
    }
    await action();
    return true;
  }
}
