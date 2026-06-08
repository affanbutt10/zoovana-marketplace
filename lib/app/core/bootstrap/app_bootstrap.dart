import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apis/services/auth_service.dart';
import '../../../apis/services/booking_service.dart';
import '../../../apis/services/cart_service.dart';
import '../../../apis/services/category_service.dart';
import '../../../apis/services/checkout_service.dart';
import '../../../apis/services/google_auth_client.dart';
import '../../../apis/services/order_service.dart';
import '../../../apis/services/pet_service.dart';
import '../../../apis/services/product_service.dart';
import '../../../apis/services/receipt_service.dart';
import '../../../apis/services/user_service.dart';
import '../../../apis/core/api_client.dart';
import '../controllers/auth_controller.dart';
import '../controllers/locale_controller.dart';
import '../services/cache_service.dart';
import '../services/timed_cache_service.dart';
import '../services/connectivity_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/checkout_repository.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/repositories/orders_repository.dart';
import '../../data/repositories/pet_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/receipts_repository.dart';
import '../../data/repositories/search_repository.dart';

class AppBootstrap {
  AppBootstrap._();

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    if (!Get.isRegistered<SharedPreferences>()) {
      Get.put<SharedPreferences>(prefs, permanent: true);
    }
    if (!Get.isRegistered<FlutterSecureStorage>()) {
      Get.put<FlutterSecureStorage>(
        const FlutterSecureStorage(),
        permanent: true,
      );
    }
    if (!Get.isRegistered<CacheService>()) {
      Get.put<CacheService>(CacheService(prefs), permanent: true);
    }
    // Register TimedCacheService alongside CacheService.
    if (!Get.isRegistered<TimedCacheService>()) {
      Get.put<TimedCacheService>(TimedCacheService(prefs), permanent: true);
      // Evict stale entries from previous sessions on startup.
      unawaited(Get.find<TimedCacheService>().evictExpired());
    }
    if (!Get.isRegistered<LocaleController>()) {
      Get.put<LocaleController>(LocaleController(prefs), permanent: true);
    }
    if (!Get.isRegistered<ConnectivityService>()) {
      await Get.putAsync<ConnectivityService>(
        () => ConnectivityService().init(),
        permanent: true,
      );
    }

    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<BookingService>(() => BookingService(), fenix: true);
    if (!Get.isRegistered<GoogleAuthClient>()) {
      final googleAuthClient = GoogleAuthClient();
      await googleAuthClient.initialize();
      Get.put<GoogleAuthClient>(googleAuthClient, permanent: true);
    }
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    Get.lazyPut<CategoryService>(() => CategoryService(), fenix: true);
    Get.lazyPut<CartService>(() => CartService(), fenix: true);
    Get.lazyPut<CheckoutService>(() => CheckoutService(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);
    Get.lazyPut<OrderService>(() => OrderService(), fenix: true);
    Get.lazyPut<ReceiptService>(() => ReceiptService(), fenix: true);
    Get.lazyPut<PetService>(() => PetService(), fenix: true);

    Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        service: Get.find<AuthService>(),
        storage: Get.find<FlutterSecureStorage>(),
        googleAuthClient: Get.find<GoogleAuthClient>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(
        service: Get.find<ProductService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(
        service: Get.find<CategoryService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<SearchRepository>(
      () => SearchRepository(
        service: Get.find<ProductService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(
        productRepository: Get.find<ProductRepository>(),
        categoryRepository: Get.find<CategoryRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<CartRepository>(
      () => CartRepository(
        service: Get.find<CartService>(),
        prefs: Get.find<SharedPreferences>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<CheckoutRepository>(
      () => CheckoutRepository(service: Get.find<CheckoutService>()),
      fenix: true,
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(service: Get.find<UserService>()),
      fenix: true,
    );
    Get.lazyPut<OrdersRepository>(
      () => OrdersRepository(service: Get.find<OrderService>()),
      fenix: true,
    );
    Get.lazyPut<ReceiptsRepository>(
      () => ReceiptsRepository(service: Get.find<ReceiptService>()),
      fenix: true,
    );
    Get.lazyPut<PetRepository>(
      () => PetRepository(service: Get.find<PetService>()),
      fenix: true,
    );
    Get.lazyPut<BookingRepository>(
      () => BookingRepository(service: Get.find<BookingService>()),
      fenix: true,
    );

    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(
          authRepository: Get.find<AuthRepository>(),
          cartRepository: Get.find<CartRepository>(),
        ),
        permanent: true,
      );
    }
    await Get.find<AuthController>().restoreSession();

    ApiClient().configure(
      onAuthFailure: Get.find<AuthController>().handleUnauthorized,
    );
  }
}
