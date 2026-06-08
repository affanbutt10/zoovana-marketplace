/// Pet profile from petcare service GET/POST/PUT /pets
class PetPhoto {
  final String id;
  final String photoUrl;
  final int displayOrder;

  const PetPhoto({
    required this.id,
    required this.photoUrl,
    this.displayOrder = 0,
  });

  factory PetPhoto.fromJson(Map<String, dynamic> json) {
    return PetPhoto(
      id: (json['id'] ?? '') as String,
      photoUrl: (json['photo_url'] ?? '') as String,
      displayOrder: (json['display_order'] ?? 0) as int,
    );
  }
}

class PetProfile {
  final String id;
  final String ownerId;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String? birthDate;
  final double weightKg;
  final String? medicalNotes;
  final String? medications;
  final bool isVaccinated;
  final String? vaccinationRecordUrl;
  final String? behaviorNotes;
  final String? veterinarianContact;
  final List<PetPhoto> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PetProfile({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.birthDate,
    required this.weightKg,
    this.medicalNotes,
    this.medications,
    this.isVaccinated = false,
    this.vaccinationRecordUrl,
    this.behaviorNotes,
    this.veterinarianContact,
    this.photos = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  String? get primaryPhotoUrl =>
      photos.isNotEmpty ? photos.first.photoUrl : null;

  String get speciesLabel {
    if (species.isEmpty) return species;
    return '${species[0].toUpperCase()}${species.substring(1)}';
  }

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    final rawWeight = json['weight_kg'];
    final weight = rawWeight is num
        ? rawWeight.toDouble()
        : double.tryParse(rawWeight?.toString() ?? '0') ?? 0.0;

    return PetProfile(
      id: (json['id'] ?? '') as String,
      ownerId: (json['owner_id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      species: (json['species'] ?? '') as String,
      breed: (json['breed'] ?? '') as String,
      age: (json['age'] as num?)?.toInt() ?? 0,
      birthDate: json['birth_date'] as String?,
      weightKg: weight,
      medicalNotes: json['medical_notes'] as String?,
      medications: json['medications'] as String?,
      isVaccinated: (json['is_vaccinated'] ?? false) as bool,
      vaccinationRecordUrl: json['vaccination_record_url'] as String?,
      behaviorNotes: json['behavior_notes'] as String?,
      veterinarianContact: json['veterinarian_contact'] as String?,
      photos: (json['photos'] as List? ?? [])
          .map((e) => PetPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

class PetsListResult {
  const PetsListResult({
    required this.pets,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasNext,
  });

  final List<PetProfile> pets;
  final int page;
  final int pageSize;
  final int total;
  final bool hasNext;
}

/// Input for create/update multipart requests.
class PetFormInput {
  const PetFormInput({
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.birthDate,
    this.weightKg,
    this.medicalNotes,
    this.medications,
    this.behaviorNotes,
    this.veterinarianContact,
    this.isVaccinated = false,
    this.photoPath,
    this.vaccinationRecordPath,
  });

  final String name;
  final String species;
  final String breed;
  final int age;
  final String? birthDate;
  final double? weightKg;
  final String? medicalNotes;
  final String? medications;
  final String? behaviorNotes;
  final String? veterinarianContact;
  final bool isVaccinated;
  final String? photoPath;
  final String? vaccinationRecordPath;
}
