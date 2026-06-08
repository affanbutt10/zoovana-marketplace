abstract final class ApiEndpoints {
  // ── Base URLs ──────────────────────────────────────────────────────────────

  static const String authBaseUrl = 'https://api.auth.zoovana.net/api/v1';
  static const String authOrigin = 'https://api.auth.zoovana.net';

  /// Catalogue, cart, orders, receipts, profile / mp-clients
  static const String marketBaseUrl = 'https://api.market.zoovana.net/api/v1';

  /// Profile / mp-clients lives on the auth server, not the market server
  static const String mainBaseUrl = 'https://api.auth.zoovana.net/api/v1';

  /// Pet profiles (petcare service)
  static const String petcareBaseUrl = 'https://api.petcare.zoovana.net/api/v1';

  /// Mobile marketplace web endpoints (HTML receipt print views)
  static const String mobileApiBaseUrl = 'https://m.zoovana.net/api';

  // ── Auth routes ────────────────────────────────────────────────────────────

  static const String loginPath = '/auth/login';
  static const String socialLoginPath = '/marketplace/auth/social-login';
  static const String refreshPath = '/auth/refresh';
  static const String registerPath = '/auth/register';
  static const String forgotPasswordPath = '/auth/forgot-password';
  static const String logoutPath = '/auth/logout';

  /// Replaced by userProfilePath — this Next.js session URL no longer exists
  static const String nextAuthSessionUrl = '$authOrigin/api/auth/session';

  // ── Catalogue routes (marketDio) ───────────────────────────────────────────

  static const String productsPath = '/catalog/products';
  static const String categoriesPath = '/catalog/categories';
  static const String searchPath = '/catalog/search';

  static String productById(String id) => '/catalog/products/$id';
  static String productsByCategory(String slug) =>
      '/catalog/categories/$slug/products';
  static String categoryBySlug(String slug) => '/catalog/categories/$slug';
  static String categoryBreadcrumbs(String slug) =>
      '/catalog/categories/$slug/breadcrumbs';
  static String relatedProducts(String id) => '/catalog/products/$id/related';
  static String productReviews(String id) => '/catalog/products/$id/reviews';
  static String productInCategory(String slug, String id) =>
      '/catalog/categories/$slug/products/$id';

  // ── Seller routes (marketDio) ──────────────────────────────────────────────

  static const String sellerProductsPath = '/seller/products';
  static String sellerProductById(String id) => '/seller/products/$id';
  
  // ── User / profile routes (mainDio) ───────────────────────────────────────

  static const String userProfilePath = '/mp-clients/me';
  static const String userAddressesPath = '/mp-clients/me/addresses';

  /// Real address list endpoint used by the market API
  static const String addressListPath = '/address/list';
  static const String userNotificationPrefsPath =
      '/mp-clients/me/notifications/preferences';
  static const String deleteAccountPath = '/mp-clients/me';
  static String userAddressById(String id) => '/mp-clients/me/addresses/$id';

  // ── Cart routes (marketDio) ────────────────────────────────────────────────

  static const String cartPath = '/cart';
  static const String cartItemsPath = '/cart/items';
  static const String cartItemsBulkPath = '/cart/items/bulk';
  static const String cartPromoPath = '/cart/promo';
  static const String cartTotalsPath = '/cart/totals';
  static const String cartShippingOptionsPath = '/cart/shipping-options';
  static const String cartSyncPath = '/cart/sync';
  static const String cartValidatePath = '/cart/validate';
  static const String cartSummaryPath = '/cart/summary';
  static String cartItemById(String id) => '/cart/items/$id';

  // ── Checkout routes (marketDio) ───────────────────────────────────────────

  static const String checkoutPath = '/checkout';
  static const String checkoutSummaryPath = '/checkout/summary';
  static const String checkoutValidatePath = '/checkout/validate';
  static const String checkoutPaymentMethodsPath = '/checkout/payment-methods';

  // ── Order routes (marketDio) ──────────────────────────────────────────────

  static const String ordersPath = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String orderByNumber(String number) => '/orders/number/$number';
  static String orderTracking(String id) => '/orders/$id/tracking';
  static String orderCancel(String id) => '/orders/$id/cancel';
  static String subOrder(String orderId, String subOrderId) =>
      '/orders/$orderId/sub-orders/$subOrderId';

  // ── Receipt routes (marketDio) ────────────────────────────────────────────

  static const String receiptsPath = '/my/receipts';
  static String receiptsByOrder(String orderId) =>
      '/my/receipts/order/$orderId';
  static String receiptById(String id) => '/my/receipts/$id';
  static String receiptPdf(String id) => '/my/receipts/$id/pdf';
  static String receiptPrint(String id) => '/receipts/$id/print';
  static String orderPdf(String orderId) => '/orders/$orderId/pdf';

  // ── Petcare routes (petcareDio) ─────────────────────────────────────────────

  static const String petsPath = '/pets';
  static const String myBookingsPath = '/bookings/my';
  static String petById(String id) => '/pets/$id';
}
