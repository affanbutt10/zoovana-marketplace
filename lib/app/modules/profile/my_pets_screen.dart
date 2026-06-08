import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../data/models/pet_profile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../widgets/cached_image.dart';
import 'bindings/pets_binding.dart';
import 'controllers/pets_controller.dart';
import 'pet_form_screen.dart';
import '../../../l10n/app_localizations.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  @override
  void initState() {
    super.initState();
    PetsBinding.ensureInitialized();
  }

  IconData _speciesIcon(String species) {
    return switch (species.toLowerCase()) {
      'dog' => Icons.pets_rounded,
      'cat' => Icons.emoji_nature_rounded,
      'bird' => Icons.flutter_dash_rounded,
      _ => Icons.star_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GetBuilder<PetsController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.surfaceBase,
          appBar: AppTopBar(
            leading: IconButton(
              tooltip: l10n?.back ?? 'Back',
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text(
              l10n?.myPetsTitle ?? 'My Pets',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          body: _buildBody(context, controller, l10n),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: AppButton(
                label: l10n?.addPet ?? 'Add Pet',
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                onPressed: () => Get.to(() => const PetFormScreen()),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    PetsController controller,
    AppLocalizations? l10n,
  ) {
    if (controller.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: AppShimmer.list(count: 4),
      );
    }

    if (controller.error != null && controller.pets.isEmpty) {
      return AppStateView.error(
        message: controller.error!,
        actionLabel: l10n?.retry ?? 'Retry',
        onAction: controller.loadPets,
      );
    }

    if (controller.pets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: const BoxDecoration(
                  color: AppColors.brandSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  size: 64,
                  color: AppColors.brand,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n?.noPetsFound ??
                    'No pets found. Add a pet to get started!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadPets,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: controller.pets.length + (controller.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= controller.pets.length) {
            if (controller.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.loadMore();
            });
            return const SizedBox.shrink();
          }

          final pet = controller.pets[index];
          return _PetCard(
            pet: pet,
            speciesIcon: _speciesIcon(pet.species),
            onTap: () => Get.to(() => PetFormScreen(petId: pet.id)),
          )
              .animate()
              .fadeIn(delay: (index * 80).ms)
              .slideY(
                begin: 0.1,
                end: 0,
                duration: AppMotion.medium,
                curve: AppMotion.emphasis,
              );
        },
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({
    required this.pet,
    required this.speciesIcon,
    required this.onTap,
  });

  final PetProfile pet;
  final IconData speciesIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        border: Border.all(
          color: AppColors.brand.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: AppShadows.elevation1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xxLarge),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  child: pet.primaryPhotoUrl != null
                      ? CachedImage(
                          url: pet.primaryPhotoUrl!,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 54,
                          height: 54,
                          color: AppColors.brandSoft,
                          child: Icon(speciesIcon, color: AppColors.brand),
                        ),
                ),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${pet.speciesLabel} · ${pet.breed}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${pet.age} yrs · ${pet.weightKg.toStringAsFixed(0)} kg',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (pet.isVaccinated) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successSoft,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 10,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Vaccinated',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
