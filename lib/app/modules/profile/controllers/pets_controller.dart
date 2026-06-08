import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/pet_profile.dart';
import '../../../data/repositories/pet_repository.dart';

class PetsController extends GetxController {
  PetsController({required this.repository});

  final PetRepository repository;

  List<PetProfile> pets = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? error;
  int page = 1;
  bool hasMore = true;
  static const int pageSize = 12;

  @override
  void onInit() {
    super.onInit();
    loadPets();
  }

  Future<void> loadPets() async {
    page = 1;
    hasMore = true;
    isLoading = true;
    error = null;
    update();
    try {
      final result = await repository.getPets(page: page, pageSize: pageSize);
      pets = result.pets;
      hasMore = result.hasNext;
    } catch (err) {
      error = AppErrorMapper.map(err).message;
      pets = [];
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
      final result =
          await repository.getPets(page: nextPage, pageSize: pageSize);
      pets = [...pets, ...result.pets];
      page = nextPage;
      hasMore = result.hasNext;
    } catch (_) {
      // Keep existing list on pagination failure.
    }
    isLoadingMore = false;
    update();
  }

  void onPetSaved(PetProfile pet) {
    final index = pets.indexWhere((p) => p.id == pet.id);
    if (index >= 0) {
      pets[index] = pet;
    } else {
      pets = [pet, ...pets];
    }
    update();
  }
}
