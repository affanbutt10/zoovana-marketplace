/// User / profile models matching the real API response shape:
/// GET /mp-clients/me → data: { id, email, phone_number, full_name,
///   username, is_active, is_verified, is_email_verified,
///   is_phone_verified, registration_status, last_login_at, created_at }
/// Address model matching the real API response shape:
/// GET /address/list → data: [ { id, client_id, full_name, phone_number,
///   email, address_line_1, address_line_2, city, state_province,
///   postal_code, country, address_type, is_default,
///   delivery_instructions, latitude, longitude } ]
class Address {
  final String id;
  final String? clientId;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String stateProvince;
  final String postalCode;
  final String country;
  final String addressType;
  final bool isDefault;
  final String? deliveryInstructions;
  final double? latitude;
  final double? longitude;

  Address({
    required this.id,
    this.clientId,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    this.stateProvince = '',
    this.postalCode = '',
    this.country = 'SA',
    this.addressType = 'home',
    this.isDefault = false,
    this.deliveryInstructions,
    this.latitude,
    this.longitude,
  });

  /// Convenience getter — returns full_name (real API) or falls back to name.
  String get name => fullName;
  /// Convenience getter — returns phone_number (real API).
  String get phone => phoneNumber;
  /// Convenience getter — returns address_line_1 (real API).
  String get street => addressLine1;

  factory Address.fromJson(Map<String, dynamic> json) {
    // Support both real API fields and legacy field names
    final fullName = (json['full_name'] ??
            json['name'] ??
            '') as String;
    final phoneNumber = (json['phone_number'] ??
            json['phone'] ??
            '') as String;
    final addressLine1 = (json['address_line_1'] ??
            json['street'] ??
            '') as String;

    final rawLat = json['latitude'];
    final latitude = rawLat is num ? rawLat.toDouble() : null;
    final rawLng = json['longitude'];
    final longitude = rawLng is num ? rawLng.toDouble() : null;

    return Address(
      id: (json['id'] ?? '') as String,
      clientId: json['client_id'] as String?,
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: json['email'] as String?,
      addressLine1: addressLine1,
      addressLine2: (json['address_line_2'] ?? '') as String,
      city: (json['city'] ?? '') as String,
      stateProvince: (json['state_province'] ??
              json['district'] ??
              '') as String,
      postalCode: (json['postal_code'] ?? '') as String,
      country: (json['country'] ?? 'SA') as String,
      addressType: (json['address_type'] ?? 'home') as String,
      isDefault: (json['is_default'] ?? false) as bool,
      deliveryInstructions: json['delivery_instructions'] as String?,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state_province': stateProvince,
      'postal_code': postalCode,
      'country': country,
      'address_type': addressType,
      'is_default': isDefault,
      'delivery_instructions': deliveryInstructions,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? username;
  final bool isActive;
  final bool isVerified;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String registrationStatus;
  final List<Address> addresses;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.username,
    required this.isActive,
    required this.isVerified,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.registrationStatus,
    required this.addresses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '') as String,
      // API uses full_name; fall back to name for backward compat
      name: (json['full_name'] ?? json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: (json['phone_number'] ?? json['phone'] ?? '') as String,
      username: json['username'] as String?,
      isActive: (json['is_active'] ?? true) as bool,
      isVerified: (json['is_verified'] ?? false) as bool,
      isEmailVerified: (json['is_email_verified'] ?? false) as bool,
      isPhoneVerified: (json['is_phone_verified'] ?? false) as bool,
      registrationStatus:
          (json['registration_status'] ?? 'pending_verification') as String,
      addresses: (json['addresses'] as List? ?? [])
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'phone_number': phone,
      'username': username,
      'is_active': isActive,
      'is_verified': isVerified,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'registration_status': registrationStatus,
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }
}
