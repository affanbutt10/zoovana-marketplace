enum AppErrorType {
  auth,
  server,
  network,
  timeout,
  offline,
  unknown,
}

class AppError {
  const AppError({
    required this.type,
    required this.message,
    this.statusCode,
    this.canRetry = false,
  });

  final AppErrorType type;
  final String message;
  final int? statusCode;
  final bool canRetry;

  bool get isOffline =>
      type == AppErrorType.offline || type == AppErrorType.network;
}
