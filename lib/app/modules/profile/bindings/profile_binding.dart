import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(
        ProfileController(
          profileRepository: Get.find<ProfileRepository>(),
          ordersRepository: Get.find<OrdersRepository>(),
          localeController: Get.find<LocaleController>(),
          authController: Get.find<AuthController>(),
        ),
      );
    }
  }

  static void ensureInitialized() {
    ProfileBinding().dependencies();
  }
}
