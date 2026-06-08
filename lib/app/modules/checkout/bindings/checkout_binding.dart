import 'package:get/get.dart';

import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/checkout_repository.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CheckoutController>()) {
      Get.put<CheckoutController>(
        CheckoutController(
          checkoutRepository: Get.find<CheckoutRepository>(),
          cartRepository: Get.find<CartRepository>(),
        ),
      );
    }
  }

  static void ensureInitialized() {
    CheckoutBinding().dependencies();
  }
}
