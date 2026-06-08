import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/booking.dart';
import '../../../data/repositories/booking_repository.dart';

class BookingsController extends GetxController {
  BookingsController({required this.repository});

  final BookingRepository repository;

  List<Booking> bookings = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? error;
  int page = 1;
  bool hasMore = false;
  static const int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings() async {
    page = 1;
    hasMore = false;
    isLoading = true;
    error = null;
    update();
    try {
      final result = await repository.getMyBookings(
        filter: 'pending',
        page: page,
        pageSize: pageSize,
      );
      bookings = result.bookings;
      hasMore = result.hasNext;
    } catch (err) {
      error = AppErrorMapper.map(err).message;
      bookings = [];
    }
    isLoading = false;
    update();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    update();
    try {
      final nextPage = page + 1;
      final result = await repository.getMyBookings(
        filter: 'pending',
        page: nextPage,
        pageSize: pageSize,
      );
      bookings = [...bookings, ...result.bookings];
      page = nextPage;
      hasMore = result.hasNext;
    } catch (_) {
      // Keep the current list visible if pagination fails.
    }
    isLoadingMore = false;
    update();
  }
}
