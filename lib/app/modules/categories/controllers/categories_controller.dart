import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/category_repository.dart';

class CategoriesController extends GetxController {
  CategoriesController({required this.repository});

  final CategoryRepository repository;

  bool isLoading = true;
  String? error;
  List<Category> categories = const [];

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading = true;
    error = null;
    update();
    try {
      categories = await repository.getCategories();
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isLoading = false;
    update();
  }
}
