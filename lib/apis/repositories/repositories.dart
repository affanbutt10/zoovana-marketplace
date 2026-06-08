// Repository layer — the only layer UI code should call.
//
// Each repository wraps a service, catches errors, falls back to mock data
// where appropriate, and returns normalized model objects.
//
// Available repositories:
// - AuthRepository     — login, register, logout, token persistence
// - CartRepository     — cart CRUD, guest cart, promo codes, cart sync
// - CategoryRepository — category listing and breadcrumbs
// - CheckoutRepository — checkout summary, payment methods, place order
// - HomeRepository     — home-screen aggregated data
// - OrdersRepository   — order listing, detail, tracking, cancellation
// - ProductRepository  — product listing, detail, search, reviews
// - ProfileRepository  — user profile and address management
// - ReceiptsRepository — receipt listing and PDF download
// - SearchRepository   — product search with caching
export '../../app/data/repositories/auth_repository.dart';
export '../../app/data/repositories/cart_repository.dart';
export '../../app/data/repositories/category_repository.dart';
export '../../app/data/repositories/checkout_repository.dart';
export '../../app/data/repositories/home_repository.dart';
export '../../app/data/repositories/orders_repository.dart';
export '../../app/data/repositories/product_repository.dart';
export '../../app/data/repositories/profile_repository.dart';
export '../../app/data/repositories/receipts_repository.dart';
export '../../app/data/repositories/search_repository.dart';
