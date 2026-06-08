import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';
import '../../app/data/models/order.dart';

class OrderService {
  // Orders live on marketDio (zoovana-marketplace.vercel.app/api/market)
  final Dio _dio = ApiClient().marketDio;

  /// GET /orders?page=1&page_size=12
  /// Response: { success, data: { items: [], pagination: {...} } }
  Future<List<Order>> getOrders({int page = 1, int pageSize = 12}) async {
    final response = await _dio.get(
      ApiEndpoints.ordersPath,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    // data is { items: [], pagination: {} }
    final dataMap = ResponseParser.extractMap(
      response.data,
      candidateKeys: const ['data'],
    );
    final items = ResponseParser.extractList(
      dataMap,
      candidateKeys: const ['items'],
    );
    return items.map(Order.fromJson).toList();
  }

  Future<Order> getOrder(String id) async {
    final response = await _dio.get(ApiEndpoints.orderById(id));
    return Order.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['order', 'data'],
      ),
    );
  }

  Future<Order> getOrderByNumber(String orderNumber) async {
    final response = await _dio.get(ApiEndpoints.orderByNumber(orderNumber));
    return Order.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['order', 'data'],
      ),
    );
  }

  Future<List<TrackingEvent>> getTracking(String id) async {
    final response = await _dio.get(ApiEndpoints.orderTracking(id));
    final data = ResponseParser.extractList(response.data);
    return data.map(TrackingEvent.fromJson).toList();
  }

  Future<SubOrder> getSubOrder(String orderId, String subOrderId) async {
    final response = await _dio.get(
      ApiEndpoints.subOrder(orderId, subOrderId),
    );
    return SubOrder.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['sub_order', 'data'],
      ),
    );
  }

  Future<Map<String, dynamic>> cancelOrder(String id) async {
    final response = await _dio.post(ApiEndpoints.orderCancel(id));
    return ResponseParser.extractMap(response.data);
  }
}
