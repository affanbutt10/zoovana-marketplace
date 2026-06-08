# Requirements Document

## Introduction

Zoovana App UI is a professional Flutter mobile application for the Zoovana pet-products marketplace. The app targets English and Arabic-speaking customers in Saudi Arabia and the wider GCC region. The existing skeleton (Riverpod + GoRouter + Dio) provides routing, providers, and API service stubs but has no real UI — every screen is plain Material widgets with no design system, no branding, and no visual polish. This feature replaces all placeholder UI with a production-quality, bilingual (LTR/RTL), pet-marketplace aesthetic that mirrors the Zoovana Next.js website.

---

## Glossary

- **App**: The Zoovana Flutter mobile application.
- **Theme_System**: The centralized Flutter ThemeData configuration that defines colors, typography, component styles, and spacing tokens.
- **Home_Screen**: The main landing screen containing the hero banner, category belt, featured products, trust band, shop-by-need section, and Saudi promotional banner.
- **Category_Belt**: The horizontally scrollable row of pet-category tiles on the Home_Screen.
- **Hero_Banner**: The auto-advancing image carousel at the top of the Home_Screen.
- **Trust_Band**: The horizontal strip of four feature/trust icons displayed on the Home_Screen.
- **Product_Card**: A reusable widget displaying a product image, name, price, compare-at price, and badge.
- **Product_Badge**: An overlay label on a Product_Card indicating one of: Out of Stock, Sale (percentage), Featured, or New.
- **Skeleton_Loader**: A shimmer-animated placeholder widget shown while async data is loading.
- **Bottom_Nav**: The persistent five-tab bottom navigation bar (Home, Categories, Search, Cart, Profile).
- **Guest_Cart**: A cart stored locally in SharedPreferences under the key `zoovana_guest_cart` for unauthenticated users.
- **Auth_Cart**: A server-side cart accessed via the `/cart` API for authenticated users.
- **Cart_Sync**: The process of merging Guest_Cart items into Auth_Cart upon user login, with deduplication by product ID.
- **RTL_Layout**: A right-to-left layout applied when the active locale is Arabic (`ar`).
- **Protected_Route**: A GoRouter route that redirects unauthenticated users to `/login`.
- **Token_Refresh**: The process of exchanging a refresh token for a new access token via the auth interceptor.
- **Saudi_Phone**: A Saudi mobile number in the format `05XXXXXXXX`, normalized to `+9665XXXXXXXX` for API submission.
- **Breadcrumb**: A navigation trail widget shown on category and product screens using `breadcrumb_pets.png` and `breadcrumb_shape01.png`.
- **WhatsApp_FAB**: A floating action button using `whatsapp.svg` that opens a WhatsApp chat link.
- **Sale_Badge**: An orange overlay on a Product_Card showing the discount percentage, using `sale.svg`.
- **CachedImage**: A network image loaded and cached via the `cached_network_image` package.

---

## Requirements

### Requirement 1: Design System and Theme

**User Story:** As a developer, I want a centralized design system, so that all screens share consistent colors, typography, spacing, and component styles without duplication.

#### Acceptance Criteria

1. THE Theme_System SHALL define a primary color of `#1B6B4A` (deep teal-green) and an accent color of `#F5A623` (warm amber) as the CTA and sale-badge color.
2. THE Theme_System SHALL define a typographic scale using a clean sans-serif font family, with distinct styles for display, headline, body, label, and caption text.
3. THE Theme_System SHALL define border-radius tokens: small (8 dp), medium (12 dp), large (20 dp), and pill (100 dp).
4. THE Theme_System SHALL define spacing tokens in multiples of 4 dp (4, 8, 12, 16, 20, 24, 32, 48).
5. THE Theme_System SHALL configure card elevation, shadow color, and surface color for Product_Card and category tile components.
6. WHEN the active locale is `ar`, THE Theme_System SHALL apply RTL_Layout to all screens and components.
7. THE Theme_System SHALL register all assets in `assests/` (images and SVGs) so they are accessible throughout the App.

---

### Requirement 2: Bottom Navigation

**User Story:** As a user, I want a persistent bottom navigation bar, so that I can switch between the main sections of the app from any screen.

#### Acceptance Criteria

1. THE Bottom_Nav SHALL display five tabs in order: Home, Categories, Search, Cart, Profile.
2. THE Bottom_Nav SHALL highlight the active tab using the primary color and deactivate inactive tabs using a muted grey.
3. WHEN the Cart tab is tapped and the user is unauthenticated, THE App SHALL redirect the user to `/login`.
4. WHEN the Profile tab is tapped and the user is unauthenticated, THE App SHALL redirect the user to `/login`.
5. WHEN the Cart tab is active and the Auth_Cart or Guest_Cart contains one or more items, THE Bottom_Nav SHALL display a numeric badge on the Cart tab icon showing the total item count.
6. THE Bottom_Nav SHALL remain visible on all main-section screens and SHALL be hidden on modal screens (login, register, checkout, product detail).

---

### Requirement 3: Home Screen

**User Story:** As a shopper, I want a visually rich home screen, so that I can discover products, categories, and promotions at a glance.

#### Acceptance Criteria

1. THE Home_Screen SHALL display a Hero_Banner carousel at the top using `h3_banner_slide01.jpg`, `h3_banner_img01.jpg`, and `h3_banner_img02.jpg`.
2. THE Hero_Banner SHALL auto-advance every 4 seconds and SHALL display dot indicators reflecting the current slide index.
3. WHEN a Hero_Banner slide is tapped, THE Home_Screen SHALL navigate to the promotional destination associated with that slide.
4. THE Home_Screen SHALL display a Category_Belt below the Hero_Banner using `category_img01.png` through `category_img06.png` with their respective category names.
5. WHEN a category tile in the Category_Belt is tapped, THE Home_Screen SHALL navigate to `/categories/{slug}`.
6. THE Home_Screen SHALL display a featured products section as a 2-column grid of Product_Cards loaded from the `productsProvider`.
7. WHILE the `productsProvider` is in the loading state, THE Home_Screen SHALL display Skeleton_Loaders in place of Product_Cards.
8. THE Home_Screen SHALL display a Trust_Band section using `features_icon01.svg` through `features_icon04.svg` with their corresponding trust labels.
9. THE Home_Screen SHALL display a Saudi promotional banner section using `saudi_banner_left.png` and `saudi_banner_right.png`.
10. THE Home_Screen SHALL display a `Thetopbar.png` branding image in the app bar area.
11. THE Home_Screen SHALL display a WhatsApp_FAB anchored to the bottom-right corner.
12. WHILE the `categoriesProvider` is in the loading state, THE Home_Screen SHALL display Skeleton_Loaders in place of category tiles.
13. IF the `productsProvider` returns an error, THEN THE Home_Screen SHALL display an inline error message with a retry button.

---

### Requirement 4: Categories Screen

**User Story:** As a shopper, I want to browse all pet categories in a grid, so that I can quickly find products for my specific pet.

#### Acceptance Criteria

1. THE Categories_Screen SHALL display all active categories in a 2-column grid using CachedImage for each category image.
2. THE Categories_Screen SHALL use `category_img01.png` through `category_img06.png` as fallback images when a category has no remote image URL.
3. WHILE the `categoriesProvider` is in the loading state, THE Categories_Screen SHALL display Skeleton_Loaders in place of category tiles.
4. WHEN a category tile is tapped, THE Categories_Screen SHALL navigate to `/categories/{slug}`.
5. IF the `categoriesProvider` returns an error, THEN THE Categories_Screen SHALL display a full-screen error state with a retry button.

---

### Requirement 5: Category Products Screen

**User Story:** As a shopper, I want to browse products within a category with filtering and pagination, so that I can find the right product efficiently.

#### Acceptance Criteria

1. THE Category_Products_Screen SHALL display a Breadcrumb at the top using `breadcrumb_pets.png` and `breadcrumb_shape01.png` showing the path Home > Category Name.
2. THE Category_Products_Screen SHALL display products in a 2-column grid of Product_Cards.
3. THE Category_Products_Screen SHALL support infinite scroll pagination, loading the next page when the user scrolls within 200 dp of the list end.
4. WHILE a page is loading, THE Category_Products_Screen SHALL display Skeleton_Loaders at the bottom of the grid.
5. THE Category_Products_Screen SHALL display a filter/sort bar allowing the user to sort by price (ascending/descending) and by newest.
6. WHEN a filter or sort option is changed, THE Category_Products_Screen SHALL reload the product list from the first page with the new parameters.
7. WHEN a Product_Card is tapped, THE Category_Products_Screen SHALL navigate to `/product/{id}`.
8. IF no products are found for the category, THEN THE Category_Products_Screen SHALL display an empty-state illustration with a descriptive message.

---

### Requirement 6: Product Card Widget

**User Story:** As a shopper, I want product cards to clearly show price, discounts, and availability, so that I can make informed purchase decisions quickly.

#### Acceptance Criteria

1. THE Product_Card SHALL display a CachedImage for the product image with a rounded top border.
2. THE Product_Card SHALL display the product name, current price, and compare-at price (struck through) when a compare-at price is present.
3. THE Product_Card SHALL display a Product_Badge using the following priority: Out of Stock (grey) > Sale percentage (amber, using `sale.svg`) > Featured (primary green) > New (blue, when `createdAt` is within 7 days of the current date).
4. THE Product_Card SHALL display an "Add to Cart" icon button in the bottom-right corner.
5. WHEN the "Add to Cart" button is tapped and the user is authenticated, THE Product_Card SHALL call `cartProvider.addToCart` with quantity 1.
6. WHEN the "Add to Cart" button is tapped and the user is unauthenticated, THE Product_Card SHALL add the item to the Guest_Cart in SharedPreferences.
7. IF the product stock is 0, THEN THE Product_Card SHALL disable the "Add to Cart" button and display the Out of Stock badge.

---

### Requirement 7: Product Detail Screen

**User Story:** As a shopper, I want a detailed product page with an image gallery and clear purchase options, so that I can confidently decide to buy.

#### Acceptance Criteria

1. THE Product_Detail_Screen SHALL display a horizontally swipeable image gallery with dot indicators for all product images.
2. THE Product_Detail_Screen SHALL display the product name, current price, compare-at price (struck through), and Sale_Badge when applicable.
3. THE Product_Detail_Screen SHALL display a quantity selector allowing the user to increment or decrement the quantity, with a minimum value of 1.
4. THE Product_Detail_Screen SHALL display an "Add to Cart" button using the accent color.
5. WHEN the "Add to Cart" button is tapped and the user is authenticated, THE Product_Detail_Screen SHALL call `cartProvider.addToCart` with the selected quantity and display a confirmation snackbar.
6. WHEN the "Add to Cart" button is tapped and the user is unauthenticated, THE Product_Detail_Screen SHALL add the item to the Guest_Cart and display a confirmation snackbar.
7. THE Product_Detail_Screen SHALL display a related products horizontal scroll section loaded from `/catalog/products/{id}/related`.
8. WHILE product data is loading, THE Product_Detail_Screen SHALL display a Skeleton_Loader for the image gallery and product details.
9. IF the product stock is 0, THEN THE Product_Detail_Screen SHALL disable the "Add to Cart" button and display an "Out of Stock" label.
10. THE Product_Detail_Screen SHALL display a WhatsApp_FAB anchored to the bottom-right corner.
11. THE Product_Detail_Screen SHALL display a Breadcrumb showing Home > Category > Product Name.

---

### Requirement 8: Search Screen

**User Story:** As a shopper, I want to search for products with autocomplete, so that I can find specific items quickly.

#### Acceptance Criteria

1. THE Search_Screen SHALL display a search input field that is focused automatically when the screen opens.
2. WHEN the search input contains fewer than 2 characters, THE Search_Screen SHALL display a recent searches list or a prompt to type more characters.
3. WHEN the search input contains 2 or more characters, THE Search_Screen SHALL call `/catalog/search` with a debounce of 300 milliseconds.
4. WHILE a search request is in progress, THE Search_Screen SHALL display Skeleton_Loaders in place of results.
5. THE Search_Screen SHALL display search results as a 2-column grid of Product_Cards.
6. IF the search returns zero results, THEN THE Search_Screen SHALL display an empty-state message with the searched term.
7. WHEN a Product_Card in the results is tapped, THE Search_Screen SHALL navigate to `/product/{id}`.

---

### Requirement 9: Cart Screen

**User Story:** As a shopper, I want to review and manage my cart before checkout, so that I can confirm my order contents and total.

#### Acceptance Criteria

1. THE Cart_Screen SHALL display all cart items with CachedImage, product name, unit price, and a quantity stepper.
2. WHEN the quantity stepper is incremented or decremented, THE Cart_Screen SHALL call `cartProvider.updateCartItem` and optimistically update the displayed quantity.
3. WHEN the remove button on a cart item is tapped, THE Cart_Screen SHALL call `cartProvider.removeFromCart` and remove the item from the list with a slide-out animation.
4. THE Cart_Screen SHALL display a promo code input field and an "Apply" button.
5. WHEN a promo code is submitted, THE Cart_Screen SHALL call `/cart/promo` and display the discount amount or an error message.
6. THE Cart_Screen SHALL display a totals summary section showing subtotal, discount, shipping, and grand total.
7. THE Cart_Screen SHALL display a "Proceed to Checkout" CTA button using the accent color.
8. WHEN the "Proceed to Checkout" button is tapped, THE Cart_Screen SHALL navigate to `/checkout`.
9. IF the cart is empty, THEN THE Cart_Screen SHALL display an empty-state illustration with a "Start Shopping" button that navigates to `/categories`.
10. WHILE cart data is loading, THE Cart_Screen SHALL display Skeleton_Loaders for each cart item row.

---

### Requirement 10: Checkout Screen

**User Story:** As a shopper, I want to complete my purchase by entering my address and selecting a payment method, so that I can place an order.

#### Acceptance Criteria

1. THE Checkout_Screen SHALL display a multi-step form with steps: Address, Payment, Confirmation.
2. THE Checkout_Screen SHALL display an address form with fields: full name, phone number, street address, city, and postal code.
3. WHEN a phone number is entered, THE Checkout_Screen SHALL validate the Saudi_Phone format (`05XXXXXXXX`) and normalize it to `+9665XXXXXXXX` before submission.
4. IF the phone number does not match the Saudi_Phone format, THEN THE Checkout_Screen SHALL display an inline validation error below the phone field.
5. THE Checkout_Screen SHALL load available payment methods from `/checkout/payment-methods` and display them as selectable options.
6. THE Checkout_Screen SHALL display an order summary panel showing item count, subtotal, and grand total.
7. WHEN the "Place Order" button is tapped and all fields are valid, THE Checkout_Screen SHALL call `POST /checkout` and navigate to the order confirmation screen.
8. IF the checkout API call fails, THEN THE Checkout_Screen SHALL display an error snackbar with the failure reason and keep the user on the Checkout_Screen.
9. WHILE the checkout submission is in progress, THE Checkout_Screen SHALL display a loading indicator on the "Place Order" button and disable all form inputs.

---

### Requirement 11: Orders Screen

**User Story:** As a shopper, I want to view my order history with status filtering, so that I can track my purchases.

#### Acceptance Criteria

1. THE Orders_Screen SHALL display a list of order cards loaded from `GET /orders`.
2. THE Orders_Screen SHALL display a status filter tab bar with options: All, Pending, Processing, Shipped, Delivered, Cancelled.
3. WHEN a status filter tab is selected, THE Orders_Screen SHALL filter the displayed orders to match the selected status.
4. WHILE orders are loading, THE Orders_Screen SHALL display Skeleton_Loaders for each order card.
5. WHEN an order card is tapped, THE Orders_Screen SHALL navigate to `/orders/{id}`.
6. IF the orders list is empty for the selected filter, THEN THE Orders_Screen SHALL display an empty-state message.

---

### Requirement 12: Order Detail Screen

**User Story:** As a shopper, I want to see the full details of an order including sub-orders and tracking, so that I can monitor my delivery.

#### Acceptance Criteria

1. THE Order_Detail_Screen SHALL display the order ID, placement date, status, and grand total.
2. THE Order_Detail_Screen SHALL display a list of sub-orders, each showing the seller name, items, and sub-total.
3. THE Order_Detail_Screen SHALL display a tracking section loaded from `GET /orders/{id}/tracking` showing the tracking timeline.
4. WHILE order data is loading, THE Order_Detail_Screen SHALL display Skeleton_Loaders for the order header and sub-order list.
5. IF tracking data is unavailable, THEN THE Order_Detail_Screen SHALL display a "Tracking not yet available" message in the tracking section.

---

### Requirement 13: Receipts Screen

**User Story:** As a shopper, I want to view and access my receipts, so that I can keep records of my purchases.

#### Acceptance Criteria

1. THE Receipts_Screen SHALL display a list of receipt cards loaded from `GET /my/receipts`, showing receipt number, date, and total.
2. WHEN a receipt card is tapped, THE Receipts_Screen SHALL navigate to the receipt detail view loaded from `GET /my/receipts/{id}`.
3. THE Receipt_Detail_View SHALL display the full receipt including itemized products, taxes, and grand total.
4. WHILE receipts are loading, THE Receipts_Screen SHALL display Skeleton_Loaders for each receipt card.
5. IF the receipts list is empty, THEN THE Receipts_Screen SHALL display an empty-state message.

---

### Requirement 14: Profile Screen

**User Story:** As a registered user, I want to manage my account details, addresses, wishlist, and settings from a single profile screen, so that I can keep my account up to date.

#### Acceptance Criteria

1. THE Profile_Screen SHALL display a tab bar with four tabs: Orders, Wishlist, Addresses, Settings.
2. THE Profile_Screen SHALL display the user's name and email in a profile header section.
3. WHEN the Orders tab is active, THE Profile_Screen SHALL display the user's recent orders using the same order card component as the Orders_Screen.
4. WHEN the Wishlist tab is active, THE Profile_Screen SHALL display wishlisted products as a 2-column grid of Product_Cards.
5. WHEN the Addresses tab is active, THE Profile_Screen SHALL display saved addresses with options to add, edit, and delete.
6. WHEN the Settings tab is active, THE Profile_Screen SHALL display a language toggle (English / Arabic) and a logout button.
7. WHEN the language toggle is changed, THE App SHALL switch the active locale and apply RTL_Layout if Arabic is selected.
8. WHEN the logout button is tapped, THE Profile_Screen SHALL call `authProvider.logout`, clear all stored tokens, and navigate to the Home_Screen.

---

### Requirement 15: Authentication Screens

**User Story:** As a new or returning user, I want clean login, registration, and password-recovery screens, so that I can access my account securely.

#### Acceptance Criteria

1. THE Login_Screen SHALL display email and password fields, a "Login" button, a "Forgot Password" link, and a "Register" link.
2. WHEN the "Login" button is tapped and both fields are non-empty, THE Login_Screen SHALL call `authProvider.login` and navigate to the Home_Screen on success.
3. IF the login API call fails, THEN THE Login_Screen SHALL display an inline error message below the form.
4. THE Register_Screen SHALL display fields for full name, email, phone number, and password with a "Register" button.
5. WHEN a phone number is entered on the Register_Screen, THE Register_Screen SHALL validate the Saudi_Phone format and display an inline error if invalid.
6. WHEN the "Register" button is tapped and all fields are valid, THE Register_Screen SHALL call `authProvider.register` and navigate to the Home_Screen on success.
7. THE Forgot_Password_Screen SHALL display an email field and a "Send Reset Link" button.
8. WHEN the "Send Reset Link" button is tapped, THE Forgot_Password_Screen SHALL call the password-reset API and display a confirmation message.
9. WHILE any auth operation is in progress, THE Login_Screen, Register_Screen, and Forgot_Password_Screen SHALL display a loading indicator on the submit button and disable all form inputs.

---

### Requirement 16: Authentication Token Management

**User Story:** As a user, I want my session to be maintained automatically and terminated gracefully on failure, so that I am not unexpectedly logged out during normal use.

#### Acceptance Criteria

1. THE App SHALL store the access token and refresh token in FlutterSecureStorage under the keys `access_token` and `refresh_token`.
2. WHEN an API request returns HTTP 401, THE App SHALL attempt a single token refresh using the stored refresh token before retrying the original request.
3. IF the token refresh request fails, THEN THE App SHALL delete all stored tokens, set `authProvider` to unauthenticated, and redirect the user to `/login`.
4. THE App SHALL attach the `Authorization: Bearer {access_token}` header to all authenticated API requests via the AuthInterceptor.

---

### Requirement 17: Guest Cart and Cart Sync

**User Story:** As a guest shopper, I want my cart to persist without logging in, and to be merged with my account cart when I log in, so that I do not lose items I added before authenticating.

#### Acceptance Criteria

1. WHEN an unauthenticated user adds a product to the cart, THE App SHALL persist the item in SharedPreferences under the key `zoovana_guest_cart` as a JSON array.
2. THE Guest_Cart JSON array SHALL store each item as an object with fields `product_id`, `quantity`, and `added_at`.
3. WHEN a user logs in successfully, THE App SHALL read the Guest_Cart from SharedPreferences and call `POST /cart/sync` with the guest items.
4. WHEN performing Cart_Sync, THE App SHALL deduplicate items by `product_id`, keeping the higher quantity when the same product exists in both the Guest_Cart and Auth_Cart.
5. WHEN Cart_Sync completes successfully, THE App SHALL clear the Guest_Cart from SharedPreferences.
6. IF Cart_Sync fails, THEN THE App SHALL retain the Guest_Cart in SharedPreferences and display a non-blocking warning to the user.

---

### Requirement 18: Skeleton Loading States

**User Story:** As a user, I want smooth loading placeholders on all data-heavy screens, so that the app feels responsive while content is being fetched.

#### Acceptance Criteria

1. THE Skeleton_Loader SHALL use a shimmer animation cycling between two grey tones at a period of 1.5 seconds.
2. THE Skeleton_Loader SHALL be available in three variants: card (for Product_Card), list-row (for cart items and order cards), and text-block (for headings and descriptions).
3. WHEN any `AsyncValue` provider is in the loading state, THE corresponding screen section SHALL display the appropriate Skeleton_Loader variant.
4. WHEN data loads successfully, THE Skeleton_Loader SHALL be replaced by the actual content with a 200-millisecond fade-in transition.

---

### Requirement 19: Animations and Transitions

**User Story:** As a user, I want smooth screen transitions and micro-interactions, so that the app feels polished and responsive.

#### Acceptance Criteria

1. WHEN navigating from a Product_Card to the Product_Detail_Screen, THE App SHALL use a hero transition on the product image.
2. WHEN a screen is pushed onto the navigation stack, THE App SHALL use a slide-in-from-right transition for LTR and slide-in-from-left for RTL.
3. WHEN a cart item is removed, THE Cart_Screen SHALL animate the item out with a horizontal slide and height collapse over 250 milliseconds.
4. WHEN the Bottom_Nav tab changes, THE App SHALL animate the active indicator with a 150-millisecond ease-in-out transition.

---

### Requirement 20: Bilingual and RTL Support

**User Story:** As an Arabic-speaking user, I want the app to display fully in Arabic with correct right-to-left layout, so that I can use the app comfortably in my language.

#### Acceptance Criteria

1. THE App SHALL support two locales: `en` (English, LTR) and `ar` (Arabic, RTL).
2. WHEN the active locale is `ar`, THE App SHALL apply `Directionality(textDirection: TextDirection.rtl)` to the root widget tree.
3. THE App SHALL provide localized strings for all user-visible text via the Flutter localization system (`flutter_localizations`).
4. WHEN the active locale is `ar`, THE App SHALL mirror all directional icons (back arrows, navigation arrows using `right_arrow.svg`) to their RTL equivalents.
5. THE App SHALL persist the user's locale preference in SharedPreferences and restore it on next launch.
