import '../../../apis/services/pet_service.dart';
import '../models/pet_profile.dart';

class PetRepository {
  PetRepository({required this.service});

  final PetService service;

  Future<PetsListResult> getPets({int page = 1, int pageSize = 12}) {
    return service.getPets(page: page, pageSize: pageSize);
  }

  Future<PetProfile> getPet(String id) {
    return service.getPet(id);
  }

  Future<PetProfile> createPet(PetFormInput input) {
    return service.createPet(input);
  }

  Future<PetProfile> updatePet(String id, PetFormInput input) {
    return service.updatePet(id, input);
  }
}
