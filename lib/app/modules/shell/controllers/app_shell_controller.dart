import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class AppShellController extends GetxController {
  final PageController pageController = PageController();
  int currentIndex = 0;

  static const _cartTabIndex = 3;
  static const _profileTabIndex = 4;

  static const tabRoutes = <String>[
    AppRoutes.home,
    AppRoutes.categories,
    AppRoutes.search,
    AppRoutes.cart,
    AppRoutes.profile,
  ];

  void initialize(int index) {
    if (currentIndex == index) {
      if (pageController.hasClients) {
        pageController.jumpToPage(index);
      }
      if (index == 0) {
        _refreshDashboard();
      }
      return;
    }

    currentIndex = index;
    update();

    if (index == 0) {
      _refreshDashboard();
    }

    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    }
  }

  Future<void> setIndex(int index, {bool animate = true}) async {
    if (index == currentIndex) {
      if (index == 0) {
        _refreshDashboard();
      }
      return;
    }

    if (index == _profileTabIndex &&
        Get.isRegistered<AuthController>() &&
        !Get.find<AuthController>().isAuthenticated) {
      await Get.toNamed(AppRoutes.login);
      return;
    }

    currentIndex = index;
    update();

    // Refresh cart whenever the cart tab is opened so it always shows
    // the latest server state after adding items from product screens.
    if (index == _cartTabIndex) {
      try {
        Get.find<CartRepository>().loadCart();
      } catch (_) {}
    }
    if (index == 0) {
      _refreshDashboard();
    }

    if (!pageController.hasClients) {
      return;
    }

    if (animate) {
      await pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    } else {
      pageController.jumpToPage(index);
    }
  }

  void onPageChanged(int index) {
    if (index == currentIndex) {
      return;
    }
    currentIndex = index;
    update();
  }

  void syncWithRoute(String route) {
    final index = tabRoutes.indexOf(route);
    if (index >= 0 && index != currentIndex) {
      currentIndex = index;
      update();
    }
  }

  void refreshCurrentTab() {
    if (currentIndex == 0) {
      _refreshDashboard();
    }
  }

  void _refreshDashboard() {
    try {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().refreshDashboard();
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
