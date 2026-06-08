import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/receipt.dart';
import '../../../data/repositories/receipts_repository.dart';

class ReceiptsController extends GetxController {
  ReceiptsController({required this.repository});

  final ReceiptsRepository repository;

  bool isLoading = true;
  String? error;
  List<Receipt> receipts = const [];

  @override
  void onInit() {
    super.onInit();
    loadReceipts();
  }

  Future<void> loadReceipts() async {
    isLoading = true;
    error = null;
    update();
    try {
      receipts = await repository.getReceipts();
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isLoading = false;
    update();
  }
}
