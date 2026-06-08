import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../app/data/models/booking.dart';

class BookingService {
  final Dio _dio = ApiClient().petcareDio;

  Future<BookingsListResult> getMyBookings({
    String filter = 'pending',
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.myBookingsPath,
      queryParameters: {'filter': filter, 'page': page, 'page_size': pageSize},
    );
    final body = response.data as Map<String, dynamic>? ?? {};
    final bookings = (body['data'] as List? ?? [])
        .whereType<Map>()
        .map((e) => Booking.fromJson(e.map((k, v) => MapEntry('$k', v))))
        .toList();
    final meta = body['meta'] as Map<String, dynamic>? ?? {};
    return BookingsListResult(
      bookings: bookings,
      page: (meta['page'] as num?)?.toInt() ?? page,
      pageSize: (meta['page_size'] as num?)?.toInt() ?? pageSize,
      total: (meta['total'] as num?)?.toInt() ?? bookings.length,
      hasNext: meta['has_next'] as bool? ?? false,
    );
  }
}
