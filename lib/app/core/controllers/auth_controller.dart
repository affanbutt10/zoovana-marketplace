import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../apis/services/google_auth_client.dart';
import '../errors/app_error_mapper.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/cart_repository.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController({required this.authRepository, required this.cartRepository});

  final AuthRepository authRepository;
  final CartRepository cartRepository;

  bool isAuthenticated = false;
  bool isLoading = false;
  bool resetEmailSent = false;
  bool? lastSocialLoginProfileCompleted;
  String? error;

  /// Clears any lingering error and resets loading/sent state.
  /// Call this when navigating to an auth screen so stale errors don't bleed through.
  void clearError() {
    if (error != null || isLoading || resetEmailSent) {
      error = null;
      isLoading = false;
      resetEmailSent = false;
      update();
    }
  }

  Future<void> restoreSession() async {
    debugPrint('[AuthController] restoreSession — checking stored token');
    isAuthenticated = await authRepository.isAuthenticated();
    debugPrint(
      '[AuthController] restoreSession — isAuthenticated: $isAuthenticated',
    );
    update();
  }

  Future<bool> login(String email, String password) async {
    debugPrint('[AuthController] login — email: $email');
    isLoading = true;
    error = null;
    update();
    try {
      final data = await authRepository.login(email, password);
      debugPrint(
        '[AuthController] login — response keys: ${data.keys.toList()}',
      );
      await cartRepository.syncGuestCart();
      debugPrint('[AuthController] login — guest cart synced');
      isAuthenticated = true;
      isLoading = false;
      update();
      return true;
    } catch (err) {
      debugPrint('[AuthController] login — ERROR: $err');
      isLoading = false;
      error = AppErrorMapper.map(err).message;
      debugPrint('[AuthController] login — mapped error: $error');
      update();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    debugPrint('[AuthController] loginWithGoogle');
    isLoading = true;
    error = null;
    lastSocialLoginProfileCompleted = null;
    update();
    try {
      final data = await authRepository.loginWithGoogle();
      if (data == null) {
        isLoading = false;
        update();
        return false;
      }
      await cartRepository.syncGuestCart();
      debugPrint('[AuthController] loginWithGoogle — guest cart synced');
      isAuthenticated = true;
      isLoading = false;
      lastSocialLoginProfileCompleted = data['profile_completed'] as bool?;
      update();
      return true;
    } on GoogleAuthCancelledException catch (err) {
      debugPrint(
        '[AuthController] loginWithGoogle — cancelled or misconfigured: ${err.message}',
      );
      isLoading = false;
      if (err.message?.contains('Cancelled by user') == true) {
        error = 'Google sign-in was cancelled.';
      } else {
        error = 'Google sign-in could not complete. Error: ${err.message}. (If you see [16] Account reauth failed, check your SHA fingerprints).';
      }
      update();
      return false;
    } catch (err) {
      debugPrint('[AuthController] loginWithGoogle — ERROR: $err');
      isLoading = false;
      error = AppErrorMapper.map(err).message;
      debugPrint('[AuthController] loginWithGoogle — mapped error: $error');
      update();
      return false;
    }
  }

  Future<bool> register(
    String email,
    String password,
    String name, {
    String? phone,
  }) async {
    debugPrint(
      '[AuthController] register — email: $email, name: $name, phone: $phone',
    );
    isLoading = true;
    error = null;
    update();
    try {
      await authRepository.register(email, password, name, phone: phone);
      debugPrint(
        '[AuthController] register — success (email verification required)',
      );
      isLoading = false;
      update();
      // Registration succeeded but no tokens are issued yet.
      // The user must verify their email before logging in.
      return true;
    } catch (err) {
      debugPrint('[AuthController] register — ERROR: $err');
      isLoading = false;
      error = AppErrorMapper.map(err).message;
      debugPrint('[AuthController] register — mapped error: $error');
      update();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    debugPrint('[AuthController] forgotPassword — email: $email');
    isLoading = true;
    error = null;
    update();
    try {
      await authRepository.forgotPassword(email);
      debugPrint('[AuthController] forgotPassword — success');
      isLoading = false;
      resetEmailSent = true;
      update();
      return true;
    } catch (err) {
      debugPrint('[AuthController] forgotPassword — ERROR: $err');
      isLoading = false;
      error = AppErrorMapper.map(err).message;
      debugPrint('[AuthController] forgotPassword — mapped error: $error');
      update();
      return false;
    }
  }

  Future<void> logout({bool redirect = true}) async {
    debugPrint('[AuthController] logout — redirect: $redirect');
    await authRepository.logout();
    isAuthenticated = false;
    error = null;
    update();
    if (redirect) {
      debugPrint('[AuthController] logout — navigating to login');
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> handleUnauthorized() async {
    await logout(redirect: true);
  }
}
