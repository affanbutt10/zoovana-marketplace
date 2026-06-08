import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/forgot_password_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/register_screen.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/category_products_screen.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/checkout_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/feature_detail_screen.dart';
import '../modules/notifications/notifications_screen.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/order_detail_screen.dart';
import '../modules/orders/orders_screen.dart';
import '../modules/products/bindings/product_binding.dart';
import '../modules/products/product_detail_screen.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/profile_detail_screen.dart';
import '../modules/profile/bindings/bookings_binding.dart';
import '../modules/profile/bindings/pets_binding.dart';
import '../modules/profile/my_pets_screen.dart';
import '../modules/profile/my_bookings_screen.dart';
import '../modules/receipts/bindings/receipts_binding.dart';
import '../modules/receipts/receipt_detail_screen.dart';
import '../modules/receipts/receipts_screen.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/shell/app_shell_screen.dart';
import '../modules/shell/bindings/app_shell_binding.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/splash_screen.dart';
import 'app_routes.dart';
import 'auth_guard.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const AppShellScreen(initialIndex: 0),
      binding: BindingsBuilder(() {
        AppShellBinding().dependencies();
        HomeBinding().dependencies();
      }),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const AppShellScreen(initialIndex: 1),
      binding: BindingsBuilder(() {
        AppShellBinding().dependencies();
        CategoriesBinding().dependencies();
      }),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const AppShellScreen(initialIndex: 2),
      binding: BindingsBuilder(() {
        AppShellBinding().dependencies();
        SearchBinding().dependencies();
      }),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const AppShellScreen(initialIndex: 3),
      binding: BindingsBuilder(() {
        AppShellBinding().dependencies();
        CartBinding().dependencies();
      }),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const AppShellScreen(initialIndex: 4),
      binding: BindingsBuilder(() {
        AppShellBinding().dependencies();
        ProfileBinding().dependencies();
      }),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.profileDetail,
      page: () => const ProfileDetailScreen(),
      binding: BindingsBuilder(() {
        ProfileBinding().dependencies();
      }),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.myPets,
      page: () => const MyPetsScreen(),
      binding: BindingsBuilder(() => PetsBinding().dependencies()),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsScreen(),
      binding: BindingsBuilder(() => BookingsBinding().dependencies()),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.category,
      page: () => CategoryProductsScreen(slug: Get.parameters['id'] ?? ''),
      binding: BindingsBuilder(() {
        final slug = Get.parameters['id'] ?? '';
        CategoryProductsBinding(slug).dependencies();
      }),
    ),
    GetPage(
      name: AppRoutes.product,
      page: () => ProductDetailScreen(id: Get.parameters['id'] ?? ''),
      binding: BindingsBuilder(() {
        final id = Get.parameters['id'] ?? '';
        ProductBinding(id).dependencies();
      }),
    ),
    GetPage(
      name: AppRoutes.feature,
      page: () => FeatureDetailScreen(id: Get.parameters['id'] ?? ''),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersScreen(),
      binding: OrdersBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => OrderDetailScreen(id: Get.parameters['id'] ?? ''),
      binding: BindingsBuilder(() {
        final id = Get.parameters['id'] ?? '';
        OrderDetailBinding(id).dependencies();
      }),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.receipts,
      page: () => const ReceiptsScreen(),
      binding: ReceiptsBinding(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.receipt,
      page: () => ReceiptDetailScreen(
        orderId: '',
        receiptId: Get.parameters['id'] ?? '',
      ),
      binding: BindingsBuilder(() {
        final id = Get.parameters['id'] ?? '';
        ReceiptDetailBinding(id).dependencies();
      }),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
  ];
}
