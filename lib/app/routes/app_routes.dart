abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const categories = '/categories';
  static const category = '/category/:id';
  static const search = '/search';
  static const notifications = '/notifications';
  static const product = '/product/:id';
  static const feature = '/feature/:id';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const profile = '/profile';
  static const profileDetail = '/profile/detail';
  static const myPets = '/profile/my-pets';
  static const myBookings = '/profile/my-bookings';
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';
  static const receipts = '/receipts';
  static const receipt = '/receipt/:id';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static String categoryById(String id) => '/category/$id';
  static String productById(String id) => '/product/$id';
  static String featureById(String id) => '/feature/$id';
  static String orderById(String id) => '/orders/$id';
  static String receiptById(String id) => '/receipt/$id';
}
