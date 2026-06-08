import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';
import '../../app/data/models/pet_profile.dart';

class PetService {
  final Dio _dio = ApiClient().petcareDio;

  Future<PetsListResult> getPets({int page = 1, int pageSize = 12}) async {
    final response = await _dio.get(
      ApiEndpoints.petsPath,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    final body = response.data as Map<String, dynamic>? ?? {};
    final pets = (body['data'] as List? ?? [])
        .map((e) => PetProfile.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = body['meta'] as Map<String, dynamic>? ?? {};
    return PetsListResult(
      pets: pets,
      page: (meta['page'] ?? page) as int,
      pageSize: (meta['page_size'] ?? pageSize) as int,
      total: (meta['total'] ?? pets.length) as int,
      hasNext: (meta['has_next'] ?? false) as bool,
    );
  }

  Future<PetProfile> getPet(String id) async {
    final response = await _dio.get(ApiEndpoints.petById(id));
    return PetProfile.fromJson(
      ResponseParser.extractMap(response.data, candidateKeys: const ['data']),
    );
  }

  Future<PetProfile> createPet(PetFormInput input) async {
    final response = await _dio.post(
      ApiEndpoints.petsPath,
      data: await _buildFormData(input),
    );
    return PetProfile.fromJson(
      ResponseParser.extractMap(response.data, candidateKeys: const ['data']),
    );
  }

  Future<PetProfile> updatePet(String id, PetFormInput input) async {
    final response = await _dio.put(
      ApiEndpoints.petById(id),
      data: await _buildFormData(input),
    );
    return PetProfile.fromJson(
      ResponseParser.extractMap(response.data, candidateKeys: const ['data']),
    );
  }

  Future<FormData> _buildFormData(PetFormInput input) async {
    final map = <String, dynamic>{
      'name': input.name,
      'species': input.species,
      'breed': input.breed,
      'age': input.age,
      'is_vaccinated': input.isVaccinated,
      if (input.birthDate != null && input.birthDate!.isNotEmpty)
        'birth_date': input.birthDate,
      if (input.weightKg != null) 'weight_kg': input.weightKg,
      if (input.medicalNotes != null && input.medicalNotes!.isNotEmpty)
        'medical_notes': input.medicalNotes,
      if (input.medications != null && input.medications!.isNotEmpty)
        'medications': input.medications,
      if (input.behaviorNotes != null && input.behaviorNotes!.isNotEmpty)
        'behavior_notes': input.behaviorNotes,
      if (input.veterinarianContact != null &&
          input.veterinarianContact!.isNotEmpty)
        'veterinarian_contact': input.veterinarianContact,
    };

    if (input.photoPath != null) {
      map['photos'] = await MultipartFile.fromFile(
        input.photoPath!,
        filename: 'pet_photo.jpg',
      );
    }
    if (input.vaccinationRecordPath != null) {
      map['vaccination_record'] = await MultipartFile.fromFile(
        input.vaccinationRecordPath!,
        filename: 'vaccination_record.jpg',
      );
    }

    return FormData.fromMap(map);
  }
}
