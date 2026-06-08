import '../../../apis/services/booking_service.dart';
import '../models/booking.dart';

class BookingRepository {
  BookingRepository({required this.service});

  final BookingService service;

  Future<BookingsListResult> getMyBookings({
    String filter = 'pending',
    int page = 1,
    int pageSize = 20,
  }) {
    return service.getMyBookings(
      filter: filter,
      page: page,
      pageSize: pageSize,
    );
  }
}
