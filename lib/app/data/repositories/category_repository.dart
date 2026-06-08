import '../../../apis/services/category_service.dart';
import '../../core/services/cache_service.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'paged_products.dart';

/// All data comes directly from the backend API.
/// On network failure the local cache is used as a read-through layer.
/// If no cache exists the error is re-thrown so the UI can show it.
class CategoryRepository {
  CategoryRepository({required this.service, this.cacheService});

  final CategoryService service;
  final CacheService? cacheService;

  Future<List<Category>> getCategories() async {
    const cacheKey = 'categories';
    try {
      final categories = await service.getCategories();
      final active = categories.where((c) => c.isActive).toList();
      await cacheService?.writeJson(
        cacheKey,
        active.map((item) => item.toJson()).toList(),
      );
      return active;
    } catch (e) {
      final cached = cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return cached
            .map((item) => Category.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      rethrow;
    }
  }

  Future<Category> getCategory(String slug) async {
    final cacheKey = 'category-detail-$slug';
    try {
      final category = await service.getCategory(slug);
      await cacheService?.writeJson(cacheKey, category.toJson());
      return category;
    } catch (e) {
      final cached = cacheService?.readJsonMap(cacheKey);
      if (cached != null) return Category.fromJson(cached);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCategoryBreadcrumbs(String slug) async {
    final cacheKey = 'category-breadcrumbs-$slug';
    try {
      final breadcrumbs = await service.getCategoryBreadcrumbs(slug);
      await cacheService?.writeJson(cacheKey, breadcrumbs);
      return breadcrumbs;
    } catch (e) {
      final cached = cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return cached.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      rethrow;
    }
  }

  Future<PagedProducts> getCategoryProducts({
    required String slug,
    required int page,
    required String sort,
  }) async {
    final cacheKey = 'category-$slug-$page-$sort';
    try {
      final products = await service.getProductsByCategory(slug, page, sort);
      await cacheService?.writeJson(
        cacheKey,
        products.map((item) => item.toJson()).toList(),
      );
      return PagedProducts(
        items: products,
        page: page,
        hasMore: products.isNotEmpty,
      );
    } catch (e) {
      final cached = cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return PagedProducts(
          items: cached
              .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
              .toList(),
          page: page,
          hasMore: false,
        );
      }
      rethrow;
    }
  }
}
