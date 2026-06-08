import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/order.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.profileRepository,
    required this.ordersRepository,
    required this.localeController,
    required this.authController,
  });

  final ProfileRepository profileRepository;
  final OrdersRepository ordersRepository;
  final LocaleController localeController;
  final AuthController authController;

  bool isLoading = true;
  String? error;
  User? user;
  List<Address> addresses = const [];
  List<Order> recentOrders = const [];

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (!authController.isAuthenticated) {
      isLoading = false;
      user = null;
      addresses = const [];
      recentOrders = const [];
      update();
      return;
    }

    isLoading = true;
    error = null;
    update();

    // Profile is critical — if it fails, show the error state.
    try {
      user = await profileRepository.getProfile();
    } catch (err) {
      error = AppErrorMapper.map(err).message;
      isLoading = false;
      update();
      return;
    }

    // Addresses and recent orders are non-critical — load in parallel.
    await Future.wait([
      profileRepository
          .getAddresses()
          .then((result) => addresses = result)
          .catchError((_) => addresses = const []),
      ordersRepository
          .getOrders()
          .then((result) => recentOrders = result.take(3).toList())
          .catchError((_) => recentOrders = const []),
    ]);

    isLoading = false;
    update();
  }

  Future<void> setLocale(Locale locale) async {
    await localeController.setLocale(locale);
  }

  Future<void> logout() async {
    await authController.logout();
  }
}
