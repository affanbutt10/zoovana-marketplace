import '../../../apis/services/checkout_service.dart';
import '../models/order.dart';

/// All data comes directly from the backend API.
/// No mock fallbacks — errors are propagated to the UI layer.
class CheckoutRepository {
  CheckoutRepository({required this.service});

  final CheckoutService service;

  Future<Map<String, dynamic>> getSummary() {
    return service.getSummary();
  }

  Future<Map<String, dynamic>> validateCheckout() {
    return service.validateCheckout();
  }

  Future<List<Map<String, dynamic>>> getPaymentMethods() {
    return service.getPaymentMethods();
  }

  Future<Order> placeOrder(Map<String, dynamic> payload) async {
    final data = await service.placeOrder(payload);
    return Order.fromJson(data);
  }
}
