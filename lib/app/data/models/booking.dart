class Booking {
  const Booking({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.dateTime,
    required this.status,
  });

  final String id;
  final String serviceName;
  final String providerName;
  final DateTime dateTime;
  final String status;

  bool get isUpcoming {
    final normalized = status.toLowerCase();
    return normalized == 'upcoming' ||
        normalized == 'pending' ||
        normalized == 'confirmed' ||
        normalized == 'scheduled';
  }

  String get displayStatus {
    final normalized = status.toLowerCase();
    return switch (normalized) {
      'pending' => 'Pending',
      'confirmed' || 'scheduled' => 'Upcoming',
      'completed' => 'Completed',
      'cancelled' || 'canceled' => 'Cancelled',
      _ =>
        status.isEmpty
            ? 'Pending'
            : '${status[0].toUpperCase()}${status.substring(1)}',
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    final dateValue =
        json['scheduled_at'] ??
        json['appointment_at'] ??
        json['booking_time'] ??
        json['booking_date'] ??
        json['date_time'] ??
        json['date'];

    return Booking(
      id: _readString(json, const ['id', 'booking_id', 'uuid']),
      serviceName: _readString(json, const [
        'service_name',
        'serviceName',
        'service',
        'title',
        'name',
      ], fallback: 'Petcare Booking'),
      providerName: _readString(json, const [
        'provider_name',
        'providerName',
        'provider',
        'clinic_name',
        'business_name',
        'vendor_name',
      ], fallback: 'Zoovana Petcare'),
      dateTime: _parseDate(dateValue),
      status: _readString(json, const ['status', 'state'], fallback: 'pending'),
    );
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is Map) {
        final nestedName =
            value['name'] ?? value['full_name'] ?? value['title'];
        if (nestedName is String && nestedName.trim().isNotEmpty) {
          return nestedName.trim();
        }
      }
    }
    return fallback;
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toLocal() ?? DateTime.now();
    }
    return DateTime.now();
  }
}

class BookingsListResult {
  const BookingsListResult({
    required this.bookings,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasNext,
  });

  final List<Booking> bookings;
  final int page;
  final int pageSize;
  final int total;
  final bool hasNext;
}
