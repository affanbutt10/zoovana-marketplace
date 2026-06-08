import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/home_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(
        HomeController(
          homeRepository: Get.find<HomeRepository>(),
          authRepository: Get.find<AuthRepository>(),
          cartRepository: Get.find<CartRepository>(),
        ),
      );
    }
  }

  static void ensureInitialized() {
    HomeBinding().dependencies();
  }
}
