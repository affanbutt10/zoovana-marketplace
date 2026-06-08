import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';

class AuthService {
  final Dio _dio = ApiClient().authDio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    debugPrint(
      '[AuthService] login — POST '
      '${ApiEndpoints.authBaseUrl}${ApiEndpoints.loginPath} | email: $email',
    );
    try {
      final response = await _dio.post(
        ApiEndpoints.loginPath,
        data: {'email': email, 'password': password},
        options: Options(
          extra: const {'skipAuth': true, 'skipAuthRefresh': true},
        ),
      );
      debugPrint(
        '[AuthService] login — status: ${response.statusCode} | '
        'data type: ${response.data.runtimeType}',
      );
      return ResponseParser.flatten(ResponseParser.asMap(response.data));
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] login — DioException: ${e.type} | '
        'status: ${e.response?.statusCode} | message: ${e.message}',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> socialLoginWithGoogle(String idToken) async {
    debugPrint(
      '[AuthService] socialLoginWithGoogle — POST '
      '${ApiEndpoints.authBaseUrl}${ApiEndpoints.socialLoginPath}',
    );
    try {
      final response = await _dio.post(
        ApiEndpoints.socialLoginPath,
        data: {'provider': 'google', 'id_token': idToken},
        options: Options(
          extra: const {'skipAuth': true, 'skipAuthRefresh': true},
        ),
      );
      debugPrint(
        '[AuthService] socialLoginWithGoogle — status: ${response.statusCode} | '
        'data type: ${response.data.runtimeType}',
      );
      return ResponseParser.flatten(ResponseParser.asMap(response.data));
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] socialLoginWithGoogle — DioException: ${e.type} | '
        'status: ${e.response?.statusCode} | message: ${e.message}',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    debugPrint(
      '[AuthService] refresh — POST '
      '${ApiEndpoints.authBaseUrl}${ApiEndpoints.refreshPath}',
    );
    try {
      final response = await _dio.post(
        ApiEndpoints.refreshPath,
        data: {'refresh_token': refreshToken},
        options: Options(
          extra: const {'skipAuth': true, 'skipAuthRefresh': true},
        ),
      );
      debugPrint('[AuthService] refresh — status: ${response.statusCode}');
      return ResponseParser.flatten(ResponseParser.asMap(response.data));
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] refresh — DioException: ${e.type} | '
        'status: ${e.response?.statusCode} | message: ${e.message}',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSession() async {
    debugPrint(
      '[AuthService] getSession — GET '
      '${ApiEndpoints.authBaseUrl}${ApiEndpoints.userProfilePath}',
    );
    try {
      // The real profile endpoint lives on the auth server.
      // authDio base is https://api.auth.zoovana.net/api/v1
      // but getSession is called without a token (skipAuth), so we build
      // a one-off request on mainDio which carries the Bearer token.
      final response = await ApiClient().mainDio.get(
        ApiEndpoints.userProfilePath,
      );
      debugPrint('[AuthService] getSession — status: ${response.statusCode}');
      return ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['data', 'profile', 'user'],
      );
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] getSession — DioException: ${e.type} | '
        'status: ${e.response?.statusCode}',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name, {
    String? phone,
  }) async {
    debugPrint(
      '[AuthService] register — POST ${ApiEndpoints.registerPath} | '
      'email: $email, full_name: $name, phone_number: $phone',
    );
    try {
      final payload = <String, dynamic>{
        'email': email,
        'password': password,
        'full_name': name, // API field: full_name
      };
      if (phone != null && phone.isNotEmpty) {
        payload['phone_number'] = phone; // API field: phone_number
      }

      final response = await _dio.post(
        ApiEndpoints.registerPath,
        data: payload,
        options: Options(
          extra: const {'skipAuth': true, 'skipAuthRefresh': true},
        ),
      );
      debugPrint(
        '[AuthService] register — status: ${response.statusCode} | '
        'data type: ${response.data.runtimeType}',
      );
      // Response shape: {success, message, data: {client_id, email, full_name, message}}
      // No tokens on register — caller should not try to persist tokens.
      return ResponseParser.flatten(ResponseParser.asMap(response.data));
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] register — DioException: ${e.type} | '
        'status: ${e.response?.statusCode} | message: ${e.message}',
      );
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    debugPrint(
      '[AuthService] forgotPassword — POST ${ApiEndpoints.forgotPasswordPath} '
      '| email: $email',
    );
    try {
      final response = await _dio.post(
        ApiEndpoints.forgotPasswordPath,
        data: {'email': email},
      );
      debugPrint(
        '[AuthService] forgotPassword — status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] forgotPassword — DioException: ${e.type} | '
        'status: ${e.response?.statusCode} | message: ${e.message}',
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    debugPrint('[AuthService] logout — POST ${ApiEndpoints.logoutPath}');
    try {
      final response = await _dio.post(ApiEndpoints.logoutPath);
      debugPrint('[AuthService] logout — status: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] logout — DioException: ${e.type} | '
        'status: ${e.response?.statusCode}',
      );
      rethrow;
    }
  }
}
