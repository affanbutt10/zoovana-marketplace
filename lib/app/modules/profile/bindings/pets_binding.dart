import 'package:get/get.dart';

import '../../../data/repositories/pet_repository.dart';
import '../controllers/pets_controller.dart';

class PetsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PetsController>()) {
      Get.put<PetsController>(
        PetsController(repository: Get.find<PetRepository>()),
      );
    }
  }

  static void ensureInitialized() {
    PetsBinding().dependencies();
  }
}
