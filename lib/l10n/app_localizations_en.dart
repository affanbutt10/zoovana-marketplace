// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navCategories => 'Categories';

  @override
  String get navSearch => 'Search';

  @override
  String get navCart => 'Cart';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeTitle => 'Zoovana';

  @override
  String get homeGreetingMorning => 'Good Morning';

  @override
  String get homeGreetingAfternoon => 'Good Afternoon';

  @override
  String get homeGreetingEvening => 'Good Evening';

  @override
  String get homeGreetingSubtitle => 'Ready for a new friend?';

  @override
  String homeHi(String name) {
    return 'Hi, $name';
  }

  @override
  String get homePopularTitle => 'Popular Pets & Products';

  @override
  String get homeDiscoverTitle => 'Discover New Pets';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeNewCollection => 'New Collection';

  @override
  String get homeHeroHeadline => 'Everything\nyour pet needs.';

  @override
  String get homeHeroSubtitle => 'In one place.';

  @override
  String get homeShopNow => 'Shop Now';

  @override
  String get homeFeaturedProducts => 'Featured Products';

  @override
  String get homeTrustFreeDelivery => 'Free Delivery';

  @override
  String get homeTrustSecurePayment => 'Secure Payment';

  @override
  String get homeTrustQualityGuarantee => 'Quality Guarantee';

  @override
  String get homeTrustSupport => '24/7 Support';

  @override
  String get homeTryAgain => 'Try again';

  @override
  String get homeGuestName => 'Guest';

  @override
  String get homeExploreCategories => 'Explore Top Categories';

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeFeatureWideSelection => 'Wide Selection';

  @override
  String get homeFeatureWideSelectionSub => 'Dogs, cats & more';

  @override
  String get homeFeatureQualityProducts => 'Quality Products';

  @override
  String get homeFeatureQualityProductsSub => 'Food & accessories';

  @override
  String get homeFeatureFastDelivery => 'Fast Delivery';

  @override
  String get homeFeatureFastDeliverySub => 'Right to your door';

  @override
  String get homeFeatureSelectionDetailTitle => 'Wide Pet Selection';

  @override
  String get homeFeatureSelectionDetailDescription =>
      'We offer an incredible variety of pets including playful dogs, calm cats, and singing birds. Find your perfect companion among our vetted, healthy, and happy pets.';

  @override
  String get homeFeatureQualityDetailDescription =>
      'Give your pet the best with our premium selection of food, durable toys, and comfortable accessories. We only stock top-rated brands that ensure the well-being of your little friends.';

  @override
  String get homeFeatureDeliveryDetailDescription =>
      'Shop from the comfort of your home and let us handle the rest. We ensure fast, reliable, and trackable delivery right to your door.';

  @override
  String get homeFeatureDefaultTitle => 'Premium Service';

  @override
  String get homeFeatureDefaultDescription =>
      'We are proud to offer premium service to you and your pets.';

  @override
  String get homePremiumFeature => 'Premium Feature';

  @override
  String get homeTrustHappyPets => 'Over 10k\nHappy Pets';

  @override
  String get homeTrustSafeGuaranteed => '100% Safe\nGuaranteed';

  @override
  String get homeTrustSupport247 => '24/7 Support\nAvailable';

  @override
  String get homeCtaBannerTitle => 'Ready to spoil your pet? 🐶';

  @override
  String get homeStartShopping => 'Start Shopping';

  @override
  String get homeTopRated => 'Top Rated';

  @override
  String get homeExploreCategoriesCta => 'Explore Categories';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesShopBy => 'Shop by Category';

  @override
  String get categoriesSubtitle =>
      'Curated collections for your beloved companions';

  @override
  String get categoriesEmpty => 'No categories available';

  @override
  String get categoriesEmptyMoment => 'No categories available at the moment.';

  @override
  String get categoriesPremiumSelection => 'Premium selection';

  @override
  String get sortPriceAsc => 'Price: Low to High';

  @override
  String get sortPriceDesc => 'Price: High to Low';

  @override
  String get sortNewest => 'Newest';

  @override
  String get filterSort => 'Sort';

  @override
  String get noProductsFound => 'No products found';

  @override
  String productsCount(int count) {
    return '$count Products';
  }

  @override
  String get noProductsInCategory => 'No products found in this category.';

  @override
  String get backToCategories => 'Back to categories';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get productBadgeSale => 'Sale';

  @override
  String get productBadgeFeatured => 'Featured';

  @override
  String get productBadgeNew => 'New';

  @override
  String get quantity => 'Quantity';

  @override
  String get relatedProducts => 'Related Products';

  @override
  String get productAddedToCart => 'Product added to cart';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get productPetName => 'Pet Name:';

  @override
  String get productDistance => 'Distance:';

  @override
  String get productDistanceLabel => 'Distance';

  @override
  String get productTags => 'Tags';

  @override
  String get productSex => 'Sex';

  @override
  String get productAge => 'Age';

  @override
  String get productBreed => 'Breed';

  @override
  String productAbout(String name) {
    return 'About $name';
  }

  @override
  String get productSimilarPets => 'Similar Pets';

  @override
  String get productIWantHim => 'I Want Him';

  @override
  String get productIWantHer => 'I Want Her';

  @override
  String get productAdding => 'Adding...';

  @override
  String get productFindingPerfect => 'Finding your perfect pet...';

  @override
  String get productCouldNotLoad => 'Could not load this pet.';

  @override
  String get searchHint => 'Search for products...';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchSubtitle => 'Find the perfect products for your pets';

  @override
  String get searchFieldHint => 'Search by breed, size, or product name...';

  @override
  String get searchRecentSearches => 'Recent Searches';

  @override
  String get searchClearAll => 'Clear All';

  @override
  String get searchPopularSearches => 'Popular Searches';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchTypeMore => 'Type at least 2 characters to search';

  @override
  String get searchStartTitle => 'Start Searching';

  @override
  String get searchStartSubtitle =>
      'Discover premium products for your beloved pets';

  @override
  String get searchNoResultsTitle => 'No Results Found';

  @override
  String searchNoResultsSubtitle(String query) {
    return 'We couldn\'t find anything for \"$query\"';
  }

  @override
  String get searchBrowseCategories => 'Browse Categories';

  @override
  String searchResultsFound(int count) {
    return '$count Products Found';
  }

  @override
  String searchShowingResultsFor(String query) {
    return 'Showing results for \"$query\"';
  }

  @override
  String get searchSortAndFilter => 'Sort and filter';

  @override
  String get searchPriceRange => 'Price range';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortPriceLowHigh => 'Price: low to high';

  @override
  String get sortPriceHighLow => 'Price: high to low';

  @override
  String get sortTopRated => 'Top rated';

  @override
  String get searchSuggestionPremiumDogFood => 'Premium Dog Food';

  @override
  String get searchSuggestionCatToys => 'Cat Toys';

  @override
  String get searchSuggestionPetBed => 'Pet Bed';

  @override
  String get searchSuggestionGroomingKit => 'Grooming Kit';

  @override
  String get searchSuggestionLeatherCollar => 'Leather Collar';

  @override
  String get cartTitle => 'My Cart';

  @override
  String get cartYourCart => 'Your Cart';

  @override
  String get cartReviewItems => 'Review your selected items';

  @override
  String get cartReviewBeforeCheckout =>
      'Review your selected items before checkout';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyMessage =>
      'Your cart is empty. Start browsing curated products.';

  @override
  String get cartStartShopping => 'Start Shopping';

  @override
  String get cartBrowseCategories => 'Browse Categories';

  @override
  String get cartHavePromoCode => 'Have a promo code?';

  @override
  String get cartEnterCode => 'Enter code here';

  @override
  String get cartPromoCode => 'Promo Code';

  @override
  String get cartApply => 'Apply';

  @override
  String cartItems(int count) {
    return 'Cart Items ($count)';
  }

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDiscount => 'Discount';

  @override
  String get cartShipping => 'Shipping';

  @override
  String get cartShippingFree => 'Free';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartEstimatedTotal => 'Estimated Total';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String get cartProceedToCheckout => 'Proceed to Checkout';

  @override
  String get cartRemoveItem => 'Remove';

  @override
  String get cartPromoApplied => 'Promo code applied.';

  @override
  String get cartPromoError => 'Invalid promo code';

  @override
  String get cartProduct => 'Product';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutSubtitle => 'Complete your order in just a few steps';

  @override
  String get checkoutAddress => 'Address';

  @override
  String get checkoutPayment => 'Payment';

  @override
  String get checkoutReview => 'Review';

  @override
  String get checkoutConfirmation => 'Confirmation';

  @override
  String get checkoutShippingAddress => 'Shipping Address';

  @override
  String get checkoutShippingSubtitle => 'Enter your delivery information';

  @override
  String get checkoutFullName => 'Full Name';

  @override
  String get checkoutFullNameHint => 'Full name';

  @override
  String get checkoutPhone => 'Phone Number';

  @override
  String get checkoutPhoneHint => '+966';

  @override
  String get checkoutStreet => 'Street Address';

  @override
  String get checkoutStreetHint => 'Street address';

  @override
  String get checkoutDistrict => 'District';

  @override
  String get checkoutDistrictHint => 'District';

  @override
  String get checkoutCity => 'City';

  @override
  String get checkoutCityHint => '';

  @override
  String get checkoutPostalCode => 'Postal Code';

  @override
  String get checkoutPostalCodeHint => 'Postal code';

  @override
  String get checkoutRequired => 'Required';

  @override
  String get checkoutDeliveryEstimate =>
      'Estimated delivery: 2-4 business days';

  @override
  String get checkoutSelectPayment => 'Please select a payment method.';

  @override
  String get checkoutCompleteDetails => 'Please complete all checkout details.';

  @override
  String get checkoutPaymentMethod => 'Payment Method';

  @override
  String get checkoutPaymentSubtitle => 'Select your preferred payment option';

  @override
  String get checkoutNoPaymentMethods => 'No payment methods available.';

  @override
  String get checkoutCreditCard => 'Credit card';

  @override
  String get checkoutCreditCardDescription => 'Pay securely by card';

  @override
  String get checkoutCashOnDelivery => 'Cash on delivery';

  @override
  String get checkoutCashOnDeliveryDescription => 'Pay when your order arrives';

  @override
  String get checkoutOrderSummary => 'Order Summary';

  @override
  String get checkoutContinueToPayment => 'Continue to Payment';

  @override
  String get checkoutContinueToReview => 'Continue to Review';

  @override
  String get checkoutPlaceOrder => 'Place Order';

  @override
  String get checkoutSecurePayment => 'Your payment is secure';

  @override
  String get checkoutBack => 'Back';

  @override
  String get checkoutOrderPlaced => 'Order placed successfully';

  @override
  String get checkoutOrderPlacedTitle => 'Order Placed Successfully!';

  @override
  String get checkoutOrderPlacedSubtitle =>
      'Thank you for your purchase. We have received your order and will process it shortly.';

  @override
  String get checkoutBackToShop => 'Back to Shop';

  @override
  String get checkoutViewOrders => 'View Orders';

  @override
  String get ordersTitle => 'My Orders';

  @override
  String get ordersAppBarTitle => 'Orders';

  @override
  String get ordersEmpty => 'No orders found';

  @override
  String get ordersNoMatchingFilter => 'No orders found matching this filter.';

  @override
  String get ordersAllOrders => 'All Orders';

  @override
  String get ordersActive => 'Active';

  @override
  String get ordersDelivered => 'Delivered';

  @override
  String get orderStatusAll => 'All';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderPlaced => 'Placed';

  @override
  String get orderStores => 'Stores';

  @override
  String get orderItems => 'Items';

  @override
  String get orderTracking => 'Tracking';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get orderSellerSubtotal => 'Seller Subtotal';

  @override
  String get orderTrackingUnavailable => 'Tracking not yet available';

  @override
  String get receiptsTitle => 'Receipts';

  @override
  String get receiptsAppBarTitle => 'Receipts';

  @override
  String get receiptsEmpty => 'No receipts found';

  @override
  String get receiptsNoPurchaseHistory => 'No purchase history found.';

  @override
  String get receiptsTotalSpending => 'Total spending history.';

  @override
  String receiptsCount(int count) {
    return '$count receipt';
  }

  @override
  String receiptsCountPlural(int count) {
    return '$count receipts';
  }

  @override
  String receiptNumber(String number) {
    return 'Receipt #$number';
  }

  @override
  String get receiptLineItems => 'Line Items';

  @override
  String get receiptProofOfPurchase => 'Proof of Purchase';

  @override
  String get receiptTotalPaid => 'Total Paid';

  @override
  String receiptLineItemsCount(int count) {
    return '$count line items';
  }

  @override
  String get profileOrders => 'Orders';

  @override
  String get profileSaved => 'Saved';

  @override
  String get profileWishlist => 'Wishlist';

  @override
  String get profileAddresses => 'Addresses';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileLogout => 'Logout';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageSubtitle => 'English / Arabic';

  @override
  String get profileAddAddress => 'Add Address';

  @override
  String get profileEditAddress => 'Edit Address';

  @override
  String get profileDeleteAddress => 'Delete Address';

  @override
  String get profileQuickAccess => 'Quick Access';

  @override
  String get profileOrdersTrack => 'Track';

  @override
  String get profileReceiptsInvoices => 'Invoices';

  @override
  String get profileMyPets => 'My Pets';

  @override
  String get profileMyPetsSubtitle => 'Manage your pets';

  @override
  String get profileMyBookings => 'My Bookings';

  @override
  String get profileMyBookingsSubtitle => 'View appointments';

  @override
  String get myPetsTitle => 'My Pets';

  @override
  String get myBookingsTitle => 'My Bookings';

  @override
  String get addPet => 'Add Pet';

  @override
  String get addBooking => 'Add Booking';

  @override
  String get noPetsFound => 'No pets found. Add a pet to get started!';

  @override
  String get noBookingsFound =>
      'No bookings found. Book a service to get started!';

  @override
  String get profilePrimaryAddress => 'Primary Address';

  @override
  String get profileNoAddress => 'No address saved yet.';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileWishlistEmpty => 'Your wishlist is empty.';

  @override
  String profileWishlistItems(int count) {
    return '$count items';
  }

  @override
  String get profileCouldNotLoad => 'Could not load profile.';

  @override
  String get profileView => 'View';

  @override
  String get profileDetailTitle => 'My Profile';

  @override
  String get profileAccountInfo => 'Account Information';

  @override
  String get profileAccountStatus => 'Account Status';

  @override
  String get profileSavedAddresses => 'Saved Addresses';

  @override
  String get profileFullName => 'Full Name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileUsername => 'Username';

  @override
  String get profileAccountVerified => 'Account Verified';

  @override
  String get profileAccountActive => 'Account Active';

  @override
  String get profileRegistration => 'Registration';

  @override
  String get profileVerified => 'Verified';

  @override
  String get profilePending => 'Pending';

  @override
  String get profileActive => 'Active';

  @override
  String get profileInactive => 'Inactive';

  @override
  String get profileDefault => 'Default';

  @override
  String get profileNoAddressesSaved => 'No addresses saved yet.';

  @override
  String get profileUser => 'User';

  @override
  String get profileLanguageEnglishCode => 'EN';

  @override
  String get profileLanguageArabicCode => 'AR';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationOrderShippedTitle => 'Order shipped';

  @override
  String get notificationOrderShippedBody =>
      'Your premium dog food is on the way.';

  @override
  String get notificationOrderShippedTime => '2 hours ago';

  @override
  String get notificationFlashSaleTitle => 'Flash sale event';

  @override
  String get notificationFlashSaleBody =>
      'Get 20% off all cat accessories this weekend.';

  @override
  String get notificationFlashSaleTime => 'Yesterday';

  @override
  String get notificationWelcomeTitle => 'Welcome to Zoovana';

  @override
  String get notificationWelcomeBody =>
      'Thanks for joining our premium pet community.';

  @override
  String get notificationWelcomeTime => '2 days ago';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWelcome => 'Welcome Back, Pet Parent!';

  @override
  String get loginSubtitle =>
      'Sign in to access your cart, orders, and exclusive member deals';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginEmailHint => 'you@example.com';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginPasswordHint => '••••••••';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginRegister => 'Don\'t have an account? Register';

  @override
  String get loginNewToZoovana => 'New to Zoovana?';

  @override
  String get loginCreateAccount => 'Create Account';

  @override
  String get loginError => 'Invalid email or password';

  @override
  String get loginFreeShipping => 'Free Shipping';

  @override
  String get loginVetApproved => 'Vet Approved';

  @override
  String get loginEasyReturns => 'Easy Returns';

  @override
  String get loginValidateEmail => 'Please enter your email';

  @override
  String get loginValidateEmailFormat => 'Please enter a valid email';

  @override
  String get loginValidatePassword => 'Please enter your password';

  @override
  String get loginValidatePasswordLength =>
      'Password must be at least 6 characters';

  @override
  String get authChangeLanguage => 'Change language';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerCreateAccount => 'Create Account';

  @override
  String get registerSubtitle =>
      'Join Zoovana for a premium pet shopping experience.';

  @override
  String get registerName => 'Full Name';

  @override
  String get registerNameHint => 'Full name';

  @override
  String get registerEmail => 'Email';

  @override
  String get registerPhone => 'Phone Number';

  @override
  String get registerPhoneHint => '05XXXXXXXX';

  @override
  String get registerPassword => 'Password';

  @override
  String get registerButton => 'Create Account';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account?';

  @override
  String get registerSignIn => 'Sign in';

  @override
  String get registerAccountCreated => 'Account Created';

  @override
  String get registerCheckEmail =>
      'Please check your email to verify your account before signing in.';

  @override
  String get registerValidateName => 'Please enter your name';

  @override
  String get registerValidateEmail => 'Please enter your email';

  @override
  String get registerValidateEmailFormat => 'Please enter a valid email';

  @override
  String get registerValidatePassword => 'Please enter a password';

  @override
  String get registerValidatePasswordLength =>
      'Password must be at least 6 characters';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordResetTitle => 'Reset Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get forgotPasswordCheckEmailTitle => 'Check Your Email';

  @override
  String forgotPasswordCheckEmailSubtitle(String email) {
    return 'We\'ve sent a reset link to $email.';
  }

  @override
  String get forgotPasswordSpamNote =>
      'Didn\'t receive it? Check your spam folder or try again in a few minutes.';

  @override
  String get forgotPasswordBackToLogin => 'Back to Login';

  @override
  String get forgotPasswordBackToLoginLink => 'Back to login';

  @override
  String get forgotPasswordEmail => 'Email Address';

  @override
  String get forgotPasswordEmailHint => 'you@example.com';

  @override
  String get forgotPasswordSend => 'Send Reset Link';

  @override
  String get forgotPasswordSuccess => 'Reset link sent to your email';

  @override
  String get forgotPasswordValidateEmail => 'Please enter your email';

  @override
  String get forgotPasswordValidateEmailFormat => 'Please enter a valid email';

  @override
  String get offlineBanner =>
      'You are offline. Cached data will be used when available.';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Something went wrong';

  @override
  String get errorTryAgain => 'Something went wrong. Please try again.';

  @override
  String get errorNoInternet =>
      'No internet connection. Please check your network.';

  @override
  String get errorTimeout => 'The request timed out. Please try again.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorWrongCredentials =>
      'Incorrect email or password. Please try again.';

  @override
  String get errorServerDown =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get errorTooManyRequests =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get errorInvalidRequest => 'Invalid request. Please check your input.';

  @override
  String get errorPermissionDenied => 'You don\'t have permission to do that.';

  @override
  String get errorResourceNotFound => 'The requested resource was not found.';

  @override
  String get errorConflict => 'A conflict occurred. Please try again.';

  @override
  String get errorCheckInput => 'Please check your input and try again.';

  @override
  String get offlineCachedData =>
      'No internet connection. Showing cached data.';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get addToWishlist => 'Add to wishlist';

  @override
  String get removeFromWishlist => 'Remove from wishlist';

  @override
  String get phoneInvalid =>
      'Please enter a valid Saudi phone number (05XXXXXXXX)';

  @override
  String get couldNotLoadOrder => 'Could not load order.';

  @override
  String get couldNotLoadReceipt => 'Could not load receipt.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get currencySar => 'SAR';
}
