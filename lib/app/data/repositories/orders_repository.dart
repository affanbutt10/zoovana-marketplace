import '../../../apis/services/order_service.dart';
import '../models/order.dart';

/// Repository for order data.
/// All data comes directly from the backend API.
/// No mock or cached fallbacks — errors are propagated to the UI layer.
class OrdersRepository {
  OrdersRepository({required this.service});

  final OrderService service;

  /// Fetch all orders from the backend.
  /// Throws if API call fails.
  Future<List<Order>> getOrders() async {
    return await service.getOrders();
  }

  /// Fetch a single order by ID from the backend.
  /// Throws if API call fails.
  Future<Order> getOrder(String id) async {
    return await service.getOrder(id);
  }

  /// Fetch a single order by order number from the backend.
  /// Throws if API call fails.
  Future<Order> getOrderByNumber(String orderNumber) async {
    return await service.getOrderByNumber(orderNumber);
  }

  /// Fetch tracking events for an order from the backend.
  /// Throws if API call fails.
  Future<List<TrackingEvent>> getTracking(String id) async {
    return await service.getTracking(id);
  }

  /// Fetch a sub-order by order ID and sub-order ID from the backend.
  /// Throws if API call fails.
  Future<SubOrder> getSubOrder(String orderId, String subOrderId) async {
    return await service.getSubOrder(orderId, subOrderId);
  }

  /// Cancel an order on the backend.
  /// Throws if API call fails.
  Future<Map<String, dynamic>> cancelOrder(String id) async {
    return await service.cancelOrder(id);
  }
}
