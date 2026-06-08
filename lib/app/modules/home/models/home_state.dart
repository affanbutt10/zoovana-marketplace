import '../../../data/models/category.dart';
import '../../../data/models/product.dart';

class HomeState {
  const HomeState({
    this.isLoading = true,
    this.error,
    this.categories = const [],
    this.featuredProducts = const [],
    this.freshArrivals = const [],
    this.userName,
    this.addingProductIds = const <String>{},
  });

  final bool isLoading;
  final String? error;
  final String? userName;
  final List<Category> categories;
  final List<Product> featuredProducts;
  final List<Product> freshArrivals;
  final Set<String> addingProductIds;

  HomeState copyWith({
    bool? isLoading,
    String? error,
    List<Category>? categories,
    List<Product>? featuredProducts,
    List<Product>? freshArrivals,
    String? userName,
    Set<String>? addingProductIds,
    bool clearError = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      userName: userName ?? this.userName,
      categories: categories ?? this.categories,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      freshArrivals: freshArrivals ?? this.freshArrivals,
      addingProductIds: addingProductIds ?? this.addingProductIds,
    );
  }
}
