import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/services/connectivity_service.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../shared/widgets/app_bottom_nav.dart';
import '../../l10n/app_localizations.dart';

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.child,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        final itemCount =
            cartController.cart?.items.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            ) ??
            0;
        final connectivity = Get.find<ConnectivityService>();

        return Obx(
          () => Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            body: Stack(
              children: [
                child,
                if (!connectivity.isOnline.value)
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
                    left: AppSpacing.base,
                    right: AppSpacing.base,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.brandOrange,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.base,
                            vertical: AppSpacing.sm,
                          ),
                          child: Builder(
                            builder: (ctx) => Text(
                              AppLocalizations.of(ctx)?.offlineBanner ??
                                  'You are offline. Cached data will be used when available.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: CurvedBottomNavBar(
              currentIndex: currentIndex,
              onTap: onTap,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home_filled),
                  label: AppLocalizations.of(context)?.navHome ?? 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.category_outlined),
                  activeIcon: const Icon(Icons.category),
                  label: AppLocalizations.of(context)?.navCategories ?? 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.search_rounded),
                  activeIcon: const Icon(Icons.search_rounded),
                  label: AppLocalizations.of(context)?.navSearch ?? 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: itemCount > 0,
                    label: Text('$itemCount'),
                    backgroundColor: AppColors.brandOrange,
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: itemCount > 0,
                    label: Text('$itemCount'),
                    backgroundColor: AppColors.brandOrange,
                    child: const Icon(Icons.shopping_cart_rounded),
                  ),
                  label: AppLocalizations.of(context)?.navCart ?? 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline_rounded),
                  activeIcon: const Icon(Icons.person_rounded),
                  label: AppLocalizations.of(context)?.navProfile ?? 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
