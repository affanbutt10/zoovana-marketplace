import '../../../apis/services/user_service.dart';
import '../models/user.dart';

/// All data comes directly from the backend API.
/// No mock fallbacks — errors are propagated to the UI layer.
class ProfileRepository {
  ProfileRepository({required this.service});

  final UserService service;

  Future<User> getProfile() {
    return service.getProfile();
  }

  Future<void> updateProfile(Map<String, dynamic> data) {
    return service.updateProfile(data);
  }

  Future<List<Address>> getAddresses() {
    return service.getAddresses();
  }

  Future<Address> addAddress(Map<String, dynamic> data) {
    return service.addAddress(data);
  }

  Future<Address> updateAddress(String id, Map<String, dynamic> data) {
    return service.updateAddress(id, data);
  }

  Future<void> deleteAddress(String id) {
    return service.deleteAddress(id);
  }

  Future<Map<String, dynamic>> getNotificationPreferences() {
    return service.getNotificationPreferences();
  }

  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, dynamic> data,
  ) {
    return service.updateNotificationPreferences(data);
  }

  Future<void> deleteAccount() {
    return service.deleteAccount();
  }
}
