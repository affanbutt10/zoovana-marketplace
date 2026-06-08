import 'package:get/get.dart';

import '../../../data/repositories/booking_repository.dart';
import '../controllers/bookings_controller.dart';

class BookingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BookingsController>()) {
      Get.put<BookingsController>(
        BookingsController(repository: Get.find<BookingRepository>()),
      );
    }
  }

  static void ensureInitialized() {
    BookingsBinding().dependencies();
  }
}
