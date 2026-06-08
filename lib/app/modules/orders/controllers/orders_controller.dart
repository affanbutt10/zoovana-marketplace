import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/order.dart';
import '../../../data/repositories/orders_repository.dart';

class OrdersController extends GetxController {
  OrdersController({required this.repository});

  final OrdersRepository repository;

  bool isLoading = true;
  String? error;
  String filter = 'all';
  List<Order> orders = const [];

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading = true;
    error = null;
    update();
    try {
      orders = await repository.getOrders();
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isLoading = false;
    update();
  }

  void setFilter(String value) {
    filter = value;
    update();
  }

  List<Order> get filteredOrders {
    if (filter == 'all') {
      return orders;
    }
    return orders.where((order) => order.status.toLowerCase() == filter).toList();
  }
}
