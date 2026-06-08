# Implementation Plan: Zoovana App UI

## Overview

Implement the full production UI for the Zoovana Flutter pet-products marketplace on top of the existing Riverpod + GoRouter + Dio skeleton. Tasks are ordered so each phase builds on the previous, ending with full integration. The implementation language is **Dart / Flutter**.

## Tasks

- [x] 1. Design system and theme foundation
  - [x] 1.1 Create `lib/app/core/theme/app_colors.dart` with all static color constants (`primary`, `accent`, `surface`, `onSurface`, `muted`, `error`, `skeletonBase`, `skeletonHighlight`)
    - _Requirements: 1.1_
  - [x] 1.2 Write property test for spacing tokens divisibility
    - **Property 1: Spacing tokens are multiples of 4**
    - **Validates: Requirements 1.4**
  - [x] 1.3 Create `lib/app/core/theme/app_spacing.dart`, `app_radius.dart`, and `app_text_styles.dart` with all token constants
    - _Requirements: 1.2, 1.3, 1.4_
  - [x] 1.4 Create `lib/app/core/theme/app_theme.dart` building `ThemeData` with `ColorScheme`, `TextTheme` (Poppins/Cairo), `CardTheme`, `ElevatedButtonTheme`, and `BottomNavigationBarTheme`
    - _Requirements: 1.1, 1.2, 1.5_
  - [x] 1.5 Register all assets in `pubspec.yaml` under `flutter.assets` with the `assests/` prefix (images and SVGs)
    - _Requirements: 1.7_
  - [x] 1.6 Create `lib/providers/locale_provider.dart` with `LocaleNotifier` that persists locale to SharedPreferences under `zoovana_locale` and restores on startup
    - _Requirements: 20.1, 20.5_
  - [x] 1.7 Write property test for locale persistence round-trip
    - **Property 35: Locale persistence round-trip**
    - **Validates: Requirements 20.5**
  - [x] 1.8 Update `lib/main.dart` to use `app_theme.dart`, wire `localeProvider` into `MaterialApp.router`, and register `flutter_localizations` delegates with `en` and `ar` locales
    - _Requirements: 1.6, 20.1, 20.2_

- [x] 2. Navigation and shell scaffold
  - [x] 2.1 Create `lib/app/routes/scaffold_with_bottom_nav.dart` — shell widget rendering `BottomNavigationBar` with five tabs (Home, Categories, Search, Cart, Profile), active tab highlighted with `AppColors.primary`, inactive tabs muted
    - _Requirements: 2.1, 2.2_
  - [x] 2.2 Write property test for active tab color
    - **Property 3: Active tab uses primary color**
    - **Validates: Requirements 2.2**
  - [x] 2.3 Write property test for bottom nav visibility by route
    - **Property 5: Bottom nav visibility by route**
    - **Validates: Requirements 2.6**
  - [x] 2.4 Add cart item count badge to the Cart tab icon in `ScaffoldWithBottomNav` by reading a `cartItemCountProvider`
    - _Requirements: 2.5_
  - [x] 2.5 Write property test for cart badge reflecting item count
    - **Property 4: Cart badge reflects item count**
    - **Validates: Requirements 2.5**
  - [x] 2.6 Rewrite `lib/app/routes/app_router.dart` with a `ShellRoute` wrapping the five main tabs, standalone routes for auth/product/checkout/orders, `redirect` guards for protected routes reading `authStateProvider`, and `CustomTransitionPage` with directional slide transitions
    - _Requirements: 2.3, 2.4, 2.6, 19.2_
  - [x] 2.7 Write property test for directional slide transition by locale
    - **Property 33: Directional slide transition by locale**
    - **Validates: Requirements 19.2**

- [x] 3. Shared widgets library
  - [x] 3.1 Create `lib/app/widgets/skeleton_loader.dart` with three variants (`card`, `listRow`, `textBlock`) using `AnimationController` (1500ms repeat) and `ColorTween` between `skeletonBase` and `skeletonHighlight`
    - _Requirements: 18.1, 18.2_
  - [x] 3.2 Write property test for skeleton loaders shown during loading state
    - **Property 8: Skeleton loaders shown during loading state**
    - **Validates: Requirements 3.7, 3.12, 4.3, 5.4, 7.8, 8.4, 9.10, 11.4**
  - [x] 3.3 Write property test for skeleton replaced with fade-in on data
    - **Property 9: Skeleton loaders replaced with fade-in on data**
    - **Validates: Requirements 18.4**
  - [x] 3.4 Create `lib/app/widgets/cached_image.dart` — thin wrapper around `CachedNetworkImage` with fallback asset parameter
    - _Requirements: 4.1, 6.1_
  - [x] 3.5 Create `lib/app/widgets/quantity_stepper.dart` — `+`/`-` row enforcing minimum value of 1
    - _Requirements: 7.3_
  - [x] 3.6 Write property test for quantity stepper minimum invariant
    - **Property 16: Quantity stepper minimum invariant**
    - **Validates: Requirements 7.3**
  - [x] 3.7 Create `lib/app/widgets/error_state.dart` and `lib/app/widgets/empty_state.dart` with retry callback and optional CTA button respectively
    - _Requirements: 3.13, 4.5, 5.8, 8.6, 9.9, 11.6_
  - [x] 3.8 Create `lib/app/widgets/breadcrumb_widget.dart` using `breadcrumb_pets.png` and `breadcrumb_shape01.png` as decorative elements, with `right_arrow.svg` mirrored in RTL via `Transform.scale(scaleX: -1)`
    - _Requirements: 5.1, 7.11, 20.4_
  - [x] 3.9 Create `lib/app/widgets/whatsapp_fab.dart` using `whatsapp.svg`, opens `https://wa.me/966XXXXXXXXX` via `url_launcher`
    - _Requirements: 3.11, 7.10_

- [x] 4. Data models — extend existing models
  - [x] 4.1 Extend `lib/app/data/models/product.dart` to add `nameAr`, `descriptionAr`, `compareAtPrice`, `imageUrls`, `categorySlug`, `isFeatured`, and `createdAt` fields with updated `fromJson`/`toJson`
    - _Requirements: 6.2, 6.3, 7.1, 7.2_
  - [x] 4.2 Extend `lib/app/data/models/category.dart` to add `nameAr` and make `imageUrl` nullable with updated `fromJson`/`toJson`
    - _Requirements: 4.2_
  - [x] 4.3 Extend `lib/app/data/models/cart.dart` to add `subtotal`, `discount`, `shipping`, `promoCode` to `Cart` and `productNameAr`, `stock` to `CartItem`; create `GuestCartItem` model with `toJson`/`fromJson`
    - _Requirements: 9.6, 17.2_
  - [x] 4.4 Write property test for guest cart JSON schema
    - **Property 29: Guest cart JSON schema**
    - **Validates: Requirements 17.2**
  - [x] 4.5 Create `lib/app/data/models/order.dart` with `Order`, `SubOrder`, `OrderItem`, and `TrackingEvent` models
    - _Requirements: 12.1, 12.2, 12.3_
  - [x] 4.6 Create `lib/app/data/models/receipt.dart` with `Receipt` and `ReceiptItem` models
    - _Requirements: 13.1, 13.3_
  - [x] 4.7 Create `lib/app/data/models/user.dart` with `User` model (id, name, email, phone, addresses)
    - _Requirements: 14.2_

- [x] 5. API services — complete service implementations
  - [x] 5.1 Complete `lib/apis/services/product_service.dart` — add `getProductsByCategory(slug, page, sort)`, `getRelatedProducts(id)`, and update `searchProducts` to match extended `Product` model
    - _Requirements: 5.2, 5.3, 5.5, 7.7_
  - [x] 5.2 Complete `lib/apis/services/category_service.dart` — implement `getCategories()` returning `List<Category>` using extended model
    - _Requirements: 4.1_ 
  - [x] 5.3 Complete `lib/apis/services/cart_service.dart` — add `applyPromoCode(code)` calling `POST /cart/promo` and `syncCart` with deduplication logic
    - _Requirements: 9.4, 9.5, 17.3_
  - [x] 5.4 Create `lib/apis/services/cart_sync_service.dart` with `merge(guestCart, authCart)` static method that deduplicates by `product_id` keeping the higher quantity
    - _Requirements: 17.4_
  - [x] 5.5 Write property test for cart sync deduplication
    - **Property 31: Cart sync deduplication keeps higher quantity**
    - **Validates: Requirements 17.4**
  - [x] 5.6 Complete `lib/apis/services/checkout_service.dart` — implement `getPaymentMethods()` and `placeOrder(payload)` calling `POST /checkout`
    - _Requirements: 10.5, 10.7_
  - [x] 5.7 Complete `lib/apis/services/order_service.dart` — implement `getOrders()`, `getOrder(id)`, and `getTracking(id)`
    - _Requirements: 11.1, 12.1, 12.3_
  - [x] 5.8 Complete `lib/apis/services/receipt_service.dart` — implement `getReceipts()` and `getReceipt(id)`
    - _Requirements: 13.1, 13.2_
  - [x] 5.9 Complete `lib/apis/services/user_service.dart` — implement `getProfile()`, `updateProfile()`, `getAddresses()`, `addAddress()`, `deleteAddress()`, and `getWishlist()`
    - _Requirements: 14.2, 14.4, 14.5_
  - [x] 5.10 Complete `lib/apis/services/auth_service.dart` — add `forgotPassword(email)` and ensure `register` accepts phone parameter
    - _Requirements: 15.4, 15.7_

- [x] 6. API interceptors — complete implementations
  - [x] 6.1 Complete `lib/core/api/interceptors/error.dart` — map `DioException` to typed `AppException` subclasses (`NetworkException`, `ServerException`, `AuthException`, `TimeoutException`) and export from `lib/core/api/exceptions.dart`
    - _Requirements: 16.2, 16.3_
  - [x] 6.2 Complete `lib/core/api/interceptors/auth.dart` — ensure the 401 retry path uses the shared `ApiClient` Dio instance (not a new `Dio()`), updates `authStateProvider` to unauthenticated on refresh failure, and triggers GoRouter redirect to `/login`
    - _Requirements: 16.2, 16.3, 16.4_
  - [x] 6.3 Write property test for auth interceptor attaches Bearer token
    - **Property 27: Auth interceptor attaches Bearer token**
    - **Validates: Requirements 16.4**
  - [x] 6.4 Write property test for token refresh on 401
    - **Property 28: Token refresh on 401**
    - **Validates: Requirements 16.2, 16.3**

- [x] 7. Checkpoint — Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 8. Providers — complete state management
  - [x] 8.1 Update `lib/providers/cart_provider.dart` — add guest cart logic reading/writing SharedPreferences under `zoovana_guest_cart`, expose `cartItemCountProvider`, and wire `CartSyncService` on login
    - _Requirements: 17.1, 17.3, 17.5, 17.6_
  - [x] 8.2 Write property test for guest cart persistence
    - **Property 15: Add to cart — guest path**
    - **Validates: Requirements 6.6, 17.1**
  - [x] 8.3 Write property test for cart sync triggered on login
    - **Property 30: Cart sync triggered on login**
    - **Validates: Requirements 17.3**
  - [x] 8.4 Write property test for guest cart cleared after successful sync
    - **Property 32: Guest cart cleared after successful sync**
    - **Validates: Requirements 17.5**
  - [x] 8.5 Create `lib/providers/category_provider.dart` with `categoriesProvider` (FutureProvider) and `categoryProductsProvider` (StateNotifierProvider with pagination and sort state)
    - _Requirements: 4.1, 5.2, 5.3, 5.5, 5.6_
  - [x] 8.6 Create `lib/providers/order_provider.dart` with `ordersProvider`, `orderProvider.family(id)`, `orderStatusFilterProvider`, and `orderTrackingProvider.family(id)`
    - _Requirements: 11.1, 11.3, 12.1, 12.3_
  - [x] 8.7 Create `lib/providers/checkout_provider.dart` with `CheckoutNotifier` managing multi-step form state, payment methods, and submission
    - _Requirements: 10.1, 10.5, 10.7, 10.8, 10.9_
  - [x] 8.8 Create `lib/providers/profile_provider.dart` with `profileProvider`, `wishlistProvider`, and `addressesProvider`
    - _Requirements: 14.2, 14.4, 14.5_
  - [x] 8.9 Update `lib/providers/auth_provider.dart` — add `register` phone parameter, trigger `CartSyncService` after successful login, and update `AuthState` to include `user` field
    - _Requirements: 15.4, 17.3_

- [x] 9. Localization files
  - [x] 9.1 Create `lib/l10n/app_en.arb` with all English string keys for every user-visible text in the app (nav labels, screen titles, button labels, error messages, empty states, form labels)
    - _Requirements: 20.3_
  - [x] 9.2 Create `lib/l10n/app_ar.arb` with Arabic translations for every key defined in `app_en.arb`
    - _Requirements: 20.3_
  - [x] 9.3 Write property test for localization key completeness
    - **Property 34: Localization key completeness**
    - **Validates: Requirements 20.3**

- [x] 10. Product card widget
  - [x] 10.1 Implement `lib/app/widgets/product_card.dart` with `Hero` tag `product-image-{id}`, `CachedImage` with rounded top corners, product name, price, compare-at price (struck through), and Add to Cart `IconButton`
    - _Requirements: 6.1, 6.2, 6.4_
  - [x] 10.2 Write property test for product card compare-at price display
    - **Property 12: Product card compare-at price display**
    - **Validates: Requirements 6.2**
  - [x] 10.3 Implement badge priority logic in `lib/app/widgets/product_badge.dart` — Out of Stock (grey) > Sale (amber + `sale.svg`) > Featured (primary green) > New (blue, within 7 days) — and apply to `ProductCard`
    - _Requirements: 6.3, 6.7_
  - [x] 10.4 Write property test for product badge priority
    - **Property 13: Product badge priority**
    - **Validates: Requirements 6.3**
  - [x] 10.5 Wire Add to Cart button in `ProductCard` — authenticated path calls `cartProvider.addToCart(id, 1)`, unauthenticated path writes to guest cart in SharedPreferences; disable button when `stock == 0`
    - _Requirements: 6.5, 6.6, 6.7_
  - [x] 10.6 Write property test for add to cart authenticated path
    - **Property 14: Add to cart — authenticated path**
    - **Validates: Requirements 6.5**

- [x] 11. Home screen
  - [x] 11.1 Implement `HeroBannerCarousel` in `lib/app/modules/home/widgets/hero_banner_carousel.dart` — `PageView` with `Timer.periodic(4s)` auto-advance, dot indicators, using `h3_banner_slide01.jpg`, `h3_banner_img01.jpg`, `h3_banner_img02.jpg`
    - _Requirements: 3.1, 3.2, 3.3_
  - [x] 11.2 Write property test for hero banner auto-advance
    - **Property 6: Hero banner auto-advances**
    - **Validates: Requirements 3.2**
  - [x] 11.3 Implement `CategoryBelt` in `lib/app/modules/home/widgets/category_belt.dart` — horizontal `ListView` of `CategoryTile` widgets using `category_img01-06.png` as fallbacks, navigates to `/categories/{slug}` on tap
    - _Requirements: 3.4, 3.5_
  - [x] 11.4 Write property test for category tile navigation
    - **Property 7: Category tile navigation**
    - **Validates: Requirements 3.5, 4.4**
  - [x] 11.5 Implement `TrustBand` in `lib/app/modules/home/widgets/trust_band.dart` using `features_icon01-04.svg` with localized trust labels
    - _Requirements: 3.8_
  - [x] 11.6 Implement `SaudiBanner` in `lib/app/modules/home/widgets/saudi_banner.dart` using `saudi_banner_left.png` and `saudi_banner_right.png`
    - _Requirements: 3.9_
  - [x] 11.7 Rewrite `lib/app/modules/home/home_screen.dart` — `CustomScrollView` with `HomeAppBar` (`Thetopbar.png`), `HeroBannerCarousel`, `CategoryBelt` (with skeleton on loading), featured products 2-column grid (with skeleton on loading), `TrustBand`, `SaudiBanner`, `WhatsAppFab`, and inline error with retry
    - _Requirements: 3.1, 3.6, 3.7, 3.10, 3.11, 3.12, 3.13_

- [x] 12. Categories and category products screens
  - [x] 12.1 Rewrite `lib/app/modules/categories/categories_screen.dart` — 2-column `GridView` of `CategoryTile` with `CachedImage` and local fallbacks, skeleton on loading, full-screen error state with retry, navigates to `/categories/{slug}` on tap
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_
  - [x] 12.2 Write property test for category grid shows only active categories
    - **Property 10: Category grid shows only active categories**
    - **Validates: Requirements 4.1**
  - [x] 12.3 Write property test for category fallback image for missing remote URL
    - **Property 11: Category fallback image for missing remote URL**
    - **Validates: Requirements 4.2**
  - [x] 12.4 Rewrite `lib/app/modules/categories/category_products_screen.dart` — `Breadcrumb` (Home > Category Name), `FilterSortBar` (price asc/desc, newest), 2-column `ProductCard` grid with infinite scroll (`ScrollController` triggers next page at 200dp from end), skeleton at bottom during page load, empty state when no products
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8_

- [x] 13. Product detail screen
  - [x] 13.1 Implement `ProductImageGallery` in `lib/app/modules/products/widgets/product_image_gallery.dart` — `PageView` with dot indicators, `Hero` on first image using tag `product-image-{id}`
    - _Requirements: 7.1, 19.1_
  - [x] 13.2 Rewrite `lib/app/modules/products/product_detail_screen.dart` — `ProductImageGallery`, product name/price/compare-at/badge, `QuantityStepper`, Add to Cart button (accent color, auth vs. guest logic, disabled when OOS), related products horizontal scroll, `Breadcrumb` (Home > Category > Product), `WhatsAppFab`, skeleton on loading, confirmation snackbar on add
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 7.10, 7.11_
  - [x] 13.3 Write property test for add to cart with selected quantity
    - **Property 17: Add to cart with selected quantity**
    - **Validates: Requirements 7.5**

- [x] 14. Search screen
  - [x] 14.1 Implement `lib/app/modules/search/search_search.dart` — autofocus `TextField`, debounce 300ms via `Timer`, recent searches list when query < 2 chars, 2-column `ProductCard` grid for results, skeleton during search, empty state with searched term, navigates to `/product/{id}` on tap
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7_
  - [x] 14.2 Write property test for search debounce threshold
    - **Property 18: Search debounce threshold**
    - **Validates: Requirements 8.2, 8.3**

- [x] 15. Cart screen
  - [x] 15.1 Rewrite `lib/app/modules/cart/cart_screen.dart` — `AnimatedList` of `CartItemRow` (CachedImage, name, price, `QuantityStepper`, remove button with 250ms slide-out + height collapse animation), promo code field + Apply button, `CartTotals` (subtotal, discount, shipping, grand total), "Proceed to Checkout" CTA, empty state with "Start Shopping" → `/categories`, skeleton on loading
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 9.9, 9.10, 19.3_
  - [x] 15.2 Write property test for cart totals completeness
    - **Property 19: Cart totals completeness**
    - **Validates: Requirements 9.6**

- [x] 16. Checkout screen
  - [x] 16.1 Implement `lib/app/modules/checkout/checkout_screen.dart` — 3-step `CheckoutStepper` (Address → Payment → Confirmation), `AddressForm` (name, phone with Saudi validation, street, city, postal code), `PaymentMethodSelector` (radio list from API), `OrderSummaryPanel`, `PlaceOrderButton` with loading state disabling all inputs, error snackbar on failure
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6, 10.7, 10.8, 10.9_
  - [x] 16.2 Implement `lib/app/core/validators/phone_validator.dart` with `validate(phone)` returning error string or null, and `normalize(phone)` converting `05XXXXXXXX` → `+9665XXXXXXXX`
    - _Requirements: 10.3, 10.4, 15.5_
  - [x] 16.3 Write property test for Saudi phone normalization
    - **Property 20: Saudi phone normalization**
    - **Validates: Requirements 10.3**
  - [x] 16.4 Write property test for Saudi phone validation rejection
    - **Property 21: Saudi phone validation rejection**
    - **Validates: Requirements 10.4**
  - [x] 16.5 Write property test for form inputs disabled during submission
    - **Property 22: Form inputs disabled during submission**
    - **Validates: Requirements 10.9, 15.9**

- [x] 17. Orders and order detail screens
  - [x] 17.1 Implement `lib/app/modules/orders/orders_screen.dart` — `OrderStatusTabBar` (All, Pending, Processing, Shipped, Delivered, Cancelled), `ListView` of `OrderCard`, skeleton on loading, empty state per filter, navigates to `/orders/{id}` on tap
    - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5, 11.6_
  - [x] 17.2 Write property test for order status filter
    - **Property 23: Order status filter**
    - **Validates: Requirements 11.3**
  - [x] 17.3 Write property test for order card navigation
    - **Property 24: Order card navigation**
    - **Validates: Requirements 11.5**
  - [x] 17.4 Implement `lib/app/modules/orders/order_detail_screen.dart` — order header (ID, date, status, total), sub-orders list (seller name, items, subtotal), tracking timeline section, skeleton on loading, "Tracking not yet available" fallback
    - _Requirements: 12.1, 12.2, 12.3, 12.4, 12.5_

- [x] 18. Receipts screen
  - [x] 18.1 Implement `lib/app/modules/receipts/receipts_screen.dart` — list of receipt cards (number, date, total), skeleton on loading, empty state, navigates to receipt detail on tap
    - _Requirements: 13.1, 13.2, 13.4, 13.5_
  - [x] 18.2 Implement `lib/app/modules/receipts/receipt_detail_screen.dart` — full receipt with itemized products, taxes, and grand total
    - _Requirements: 13.3_

- [x] 19. Profile screen
  - [x] 19.1 Implement `lib/app/modules/profile/profile_screen.dart` — `ProfileHeader` (avatar, name, email), `ProfileTabBar` (Orders, Wishlist, Addresses, Settings), each tab rendering the appropriate content
    - _Requirements: 14.1, 14.2_
  - [x] 19.2 Write property test for profile header displays user data
    - **Property 25: Profile header displays user data**
    - **Validates: Requirements 14.2**
  - [x] 19.3 Implement Orders tab content reusing `OrderCard` component, Wishlist tab as 2-column `ProductCard` grid, Addresses tab with add/edit/delete actions
    - _Requirements: 14.3, 14.4, 14.5_
  - [x] 19.4 Implement Settings tab with `LanguageToggle` (English / Arabic) that updates `localeProvider` and persists to SharedPreferences, and `LogoutButton` that calls `authProvider.logout` and navigates to Home
    - _Requirements: 14.6, 14.7, 14.8_
  - [x] 19.5 Write property test for locale toggle applies directionality
    - **Property 26: Locale toggle applies directionality**
    - **Validates: Requirements 14.7, 20.2**
  - [x] 19.6 Write property test for RTL layout applied for Arabic locale
    - **Property 2: RTL layout applied for Arabic locale**
    - **Validates: Requirements 1.6, 20.2**

- [x] 20. Authentication screens
  - [x] 20.1 Rewrite `lib/app/modules/auth/login_screen.dart` — email + password fields, Login button calling `authProvider.login`, inline error below form, Forgot Password link → `/forgot-password`, Register link → `/register`, loading state disables inputs and shows button spinner
    - _Requirements: 15.1, 15.2, 15.3, 15.9_
  - [x] 20.2 Create `lib/app/modules/auth/register_screen.dart` — name, email, phone (Saudi validation inline on `onChanged`), password fields, Register button calling `authProvider.register`, loading state disables inputs
    - _Requirements: 15.4, 15.5, 15.6, 15.9_
  - [x] 20.3 Create `lib/app/modules/auth/forgot_password_screen.dart` — email field, Send Reset Link button calling `authService.forgotPassword`, confirmation message on success, loading state disables inputs
    - _Requirements: 15.7, 15.8, 15.9_

- [x] 21. RTL and localization wiring
  - [x] 21.1 Audit all screens and widgets to replace hardcoded strings with `AppLocalizations.of(context)!.key` calls
    - _Requirements: 20.3_
  - [x] 21.2 Wrap all directional icons (`right_arrow.svg`) in `Transform.scale(scaleX: isRtl ? -1 : 1)` throughout the codebase
    - _Requirements: 20.4_

- [x] 22. Final checkpoint — Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties defined in the design document
- Unit tests validate specific examples and edge cases
- The `assests/` folder name (with the typo) is intentional — it matches the existing project structure
