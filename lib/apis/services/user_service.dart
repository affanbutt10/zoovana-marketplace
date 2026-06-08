import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';
import '../../app/data/models/user.dart';

class UserService {
  // Profile lives on the auth server (mainDio → api.auth.zoovana.net)
  final Dio _authDio = ApiClient().mainDio;
  // Addresses and other market resources live on the market server
  final Dio _marketDio = ApiClient().marketDio;

  /// GET /mp-clients/me  (auth server)
  /// Response: { success, data: { id, email, phone_number, full_name, ... } }
  Future<User> getProfile() async {
    final response = await _authDio.get(ApiEndpoints.userProfilePath);
    return User.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['data', 'profile', 'user'],
      ),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _authDio.put(ApiEndpoints.userProfilePath, data: data);
  }

  /// GET /address/list  (market server)
  /// Response: { success, data: [ { id, full_name, phone_number, ... } ] }
  Future<List<Address>> getAddresses() async {
    final response = await _marketDio.get(ApiEndpoints.addressListPath);
    final data = ResponseParser.extractList(
      response.data,
      candidateKeys: const ['data'],
    );
    return data.map(Address.fromJson).toList();
  }

  Future<Address> addAddress(Map<String, dynamic> data) async {
    final response = await _marketDio.post(
      ApiEndpoints.addressListPath,
      data: data,
    );
    return Address.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['address', 'data'],
      ),
    );
  }

  Future<Address> updateAddress(String id, Map<String, dynamic> data) async {
    final response = await _marketDio.put(
      ApiEndpoints.userAddressById(id),
      data: data,
    );
    return Address.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['address', 'data'],
      ),
    );
  }

  Future<void> deleteAddress(String id) async {
    await _marketDio.delete(ApiEndpoints.userAddressById(id));
  }

  Future<Map<String, dynamic>> getNotificationPreferences() async {
    final response = await _authDio.get(ApiEndpoints.userNotificationPrefsPath);
    return ResponseParser.extractMap(response.data);
  }

  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, dynamic> data,
  ) async {
    final response = await _authDio.put(
      ApiEndpoints.userNotificationPrefsPath,
      data: data,
    );
    return ResponseParser.extractMap(response.data);
  }

  Future<void> deleteAccount() async {
    await _authDio.delete(ApiEndpoints.deleteAccountPath);
  }
}
