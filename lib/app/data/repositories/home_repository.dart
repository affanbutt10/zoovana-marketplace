import '../models/category.dart';
import '../models/product.dart';
import 'category_repository.dart';
import 'product_repository.dart';

class HomeContent {
  const HomeContent({
    required this.categories,
    required this.featuredProducts,
    required this.freshArrivals,
  });

  final List<Category> categories;
  final List<Product> featuredProducts;
  final List<Product> freshArrivals;
}

/// Loads home screen content from the backend API.
/// Errors are propagated so the HomeController can surface them to the UI.
class HomeRepository {
  HomeRepository({
    required this.productRepository,
    required this.categoryRepository,
  });

  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  Future<HomeContent> loadHomeContent() async {
    final results = await Future.wait<dynamic>([
      categoryRepository.getCategories(),
      productRepository.getFeaturedProducts(),
      productRepository.getProducts(limit: 10),
    ]);

    return HomeContent(
      categories: results[0] as List<Category>,
      featuredProducts: results[1] as List<Product>,
      freshArrivals: results[2] as List<Product>,
    );
  }
}
