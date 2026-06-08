import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/errors/app_error_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/pet_profile.dart';
import '../../data/repositories/pet_repository.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_input.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../widgets/cached_image.dart';
import 'controllers/pets_controller.dart';
import '../../../l10n/app_localizations.dart';

class PetFormScreen extends StatefulWidget {
  const PetFormScreen({super.key, this.petId});

  /// When set, loads and updates an existing pet.
  final String? petId;

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicalNotesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _behaviorNotesController = TextEditingController();
  final _vetContactController = TextEditingController();

  final _picker = ImagePicker();
  String _species = 'dog';
  DateTime? _birthDate;
  bool _isVaccinated = false;
  String? _photoPath;
  String? _vaccinationRecordPath;
  String? _existingPhotoUrl;
  bool _isLoading = false;
  bool _isSaving = false;

  bool get _isEditing => widget.petId != null && widget.petId!.isNotEmpty;

  static const _speciesOptions = [
    ('dog', '🐕', 'Dog'),
    ('cat', '🐈', 'Cat'),
    ('bird', '🐦', 'Bird'),
    ('rabbit', '🐇', 'Rabbit'),
    ('other', '🐾', 'Other'),
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadPet();
    }
  }

  Future<void> _loadPet() async {
    setState(() => _isLoading = true);
    try {
      final pet = await Get.find<PetRepository>().getPet(widget.petId!);
      _nameController.text = pet.name;
      _breedController.text = pet.breed;
      _ageController.text = pet.age.toString();
      _weightController.text = pet.weightKg > 0
          ? pet.weightKg.toStringAsFixed(0)
          : '';
      _medicalNotesController.text = pet.medicalNotes ?? '';
      _medicationsController.text = pet.medications ?? '';
      _behaviorNotesController.text = pet.behaviorNotes ?? '';
      _vetContactController.text = pet.veterinarianContact ?? '';
      _species = pet.species.toLowerCase();
      _isVaccinated = pet.isVaccinated;
      _existingPhotoUrl = pet.primaryPhotoUrl;
      if (pet.birthDate != null && pet.birthDate!.isNotEmpty) {
        _birthDate = DateTime.tryParse(pet.birthDate!);
      }
    } catch (error) {
      if (mounted) {
        AppSnackbar.show(
          context,
          message: AppErrorMapper.map(error).message,
          type: SnackbarType.error,
        );
        Get.back();
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _medicalNotesController.dispose();
    _medicationsController.dispose();
    _behaviorNotesController.dispose();
    _vetContactController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickPhoto() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file != null) setState(() => _photoPath = file.path);
  }

  Future<void> _pickVaccinationRecord() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file != null) setState(() => _vaccinationRecordPath = file.path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final input = PetFormInput(
        name: _nameController.text.trim(),
        species: _species,
        breed: _breedController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        birthDate: _birthDate?.toIso8601String().split('T').first,
        weightKg: double.tryParse(_weightController.text.trim()),
        medicalNotes: _medicalNotesController.text.trim(),
        medications: _medicationsController.text.trim(),
        behaviorNotes: _behaviorNotesController.text.trim(),
        veterinarianContact: _vetContactController.text.trim(),
        isVaccinated: _isVaccinated,
        photoPath: _photoPath,
        vaccinationRecordPath: _vaccinationRecordPath,
      );

      final repo = Get.find<PetRepository>();
      final PetProfile saved;
      if (_isEditing) {
        saved = await repo.updatePet(widget.petId!, input);
      } else {
        saved = await repo.createPet(input);
      }

      if (Get.isRegistered<PetsController>()) {
        Get.find<PetsController>().onPetSaved(saved);
      }

      if (mounted) {
        AppSnackbar.show(
          context,
          message: _isEditing
              ? 'Pet updated successfully'
              : 'Pet added successfully',
        );
        Get.back(result: saved);
      }
    } catch (error) {
      if (mounted) {
        AppSnackbar.show(
          context,
          message: AppErrorMapper.map(error).message,
          type: SnackbarType.error,
        );
      }
    }
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          _isEditing ? 'Edit Pet' : (l10n?.addPet ?? 'Add Pet'),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  _sectionTitle(context, 'Basic Information'),
                  AppInput(
                    controller: _nameController,
                    label: 'Pet Name',
                    hintText: 'Enter pet name',
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Species',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _speciesOptions.map((opt) {
                      final selected = _species == opt.$1;
                      return ChoiceChip(
                        label: Text('${opt.$2} ${opt.$3}'),
                        selected: selected,
                        onSelected: (_) => setState(() => _species = opt.$1),
                        selectedColor: AppColors.brandSoft,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInput(
                    controller: _breedController,
                    label: 'Breed',
                    hintText: 'Enter breed',
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          controller: _ageController,
                          label: 'Age (Years)',
                          hintText: 'Enter age',
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            final n = int.tryParse(v?.trim() ?? '');
                            if (n == null || n < 0) return 'Invalid age';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppInput(
                          controller: _weightController,
                          label: 'Weight (KG)',
                          hintText: 'Enter weight',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: _pickBirthDate,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birth Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.large),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(
                        _birthDate != null
                            ? _birthDate!.toIso8601String().split('T').first
                            : 'Select date',
                        style: TextStyle(
                          color: _birthDate != null
                              ? AppColors.textMain
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInput(
                    controller: _medicalNotesController,
                    label: 'Medical Notes',
                    hintText: 'Allergies, surgeries, chronic conditions...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionTitle(context, 'Health & Medical Records'),
                  Material(
                    color: AppColors.brandSoft.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    child: CheckboxListTile(
                      value: _isVaccinated,
                      onChanged: (v) =>
                          setState(() => _isVaccinated = v ?? false),
                      title: const Text(
                        'Vaccinated',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      secondary: const Icon(
                        Icons.health_and_safety_outlined,
                        color: AppColors.brand,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInput(
                    controller: _medicationsController,
                    label: 'Medications',
                    hintText: 'Current medications and dosages...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInput(
                    controller: _vetContactController,
                    label: 'Veterinarian Contact',
                    hintText: 'Phone or clinic name...',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _uploadTile(
                    context,
                    title: 'Vaccination Record (Image)',
                    subtitle: _vaccinationRecordPath ?? 'Tap to upload image',
                    onTap: _pickVaccinationRecord,
                    icon: Icons.description_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppInput(
                    controller: _behaviorNotesController,
                    label: 'Behavior Notes',
                    hintText: 'Temperament, fears, social behavior...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Pet Photo (1 image maximum)',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: _photoPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppRadius.large,
                              ),
                              child: Image.file(
                                File(_photoPath!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : _existingPhotoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppRadius.large,
                              ),
                              child: CachedImage(
                                url: _existingPhotoUrl!,
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppButton(
                    label: _isEditing ? 'Save Changes' : 'Add Pet',
                    isLoading: _isSaving,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _uploadTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: AppColors.borderSubtle,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brand),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.upload_outlined),
          ],
        ),
      ),
    );
  }
}
