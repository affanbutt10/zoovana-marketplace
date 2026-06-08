import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Zoovana'**
  String get homeTitle;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeGreetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for a new friend?'**
  String get homeGreetingSubtitle;

  /// No description provided for @homeHi.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeHi(String name);

  /// No description provided for @homePopularTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Pets & Products'**
  String get homePopularTitle;

  /// No description provided for @homeDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover New Pets'**
  String get homeDiscoverTitle;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @homeNewCollection.
  ///
  /// In en, this message translates to:
  /// **'New Collection'**
  String get homeNewCollection;

  /// No description provided for @homeHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Everything\nyour pet needs.'**
  String get homeHeroHeadline;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'In one place.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeShopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get homeShopNow;

  /// No description provided for @homeFeaturedProducts.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get homeFeaturedProducts;

  /// No description provided for @homeTrustFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get homeTrustFreeDelivery;

  /// No description provided for @homeTrustSecurePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure Payment'**
  String get homeTrustSecurePayment;

  /// No description provided for @homeTrustQualityGuarantee.
  ///
  /// In en, this message translates to:
  /// **'Quality Guarantee'**
  String get homeTrustQualityGuarantee;

  /// No description provided for @homeTrustSupport.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get homeTrustSupport;

  /// No description provided for @homeTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeTryAgain;

  /// No description provided for @homeGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get homeGuestName;

  /// No description provided for @homeExploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Top Categories'**
  String get homeExploreCategories;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeSeeAll;

  /// No description provided for @homeFeatureWideSelection.
  ///
  /// In en, this message translates to:
  /// **'Wide Selection'**
  String get homeFeatureWideSelection;

  /// No description provided for @homeFeatureWideSelectionSub.
  ///
  /// In en, this message translates to:
  /// **'Dogs, cats & more'**
  String get homeFeatureWideSelectionSub;

  /// No description provided for @homeFeatureQualityProducts.
  ///
  /// In en, this message translates to:
  /// **'Quality Products'**
  String get homeFeatureQualityProducts;

  /// No description provided for @homeFeatureQualityProductsSub.
  ///
  /// In en, this message translates to:
  /// **'Food & accessories'**
  String get homeFeatureQualityProductsSub;

  /// No description provided for @homeFeatureFastDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery'**
  String get homeFeatureFastDelivery;

  /// No description provided for @homeFeatureFastDeliverySub.
  ///
  /// In en, this message translates to:
  /// **'Right to your door'**
  String get homeFeatureFastDeliverySub;

  /// No description provided for @homeFeatureSelectionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Wide Pet Selection'**
  String get homeFeatureSelectionDetailTitle;

  /// No description provided for @homeFeatureSelectionDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'We offer an incredible variety of pets including playful dogs, calm cats, and singing birds. Find your perfect companion among our vetted, healthy, and happy pets.'**
  String get homeFeatureSelectionDetailDescription;

  /// No description provided for @homeFeatureQualityDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Give your pet the best with our premium selection of food, durable toys, and comfortable accessories. We only stock top-rated brands that ensure the well-being of your little friends.'**
  String get homeFeatureQualityDetailDescription;

  /// No description provided for @homeFeatureDeliveryDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Shop from the comfort of your home and let us handle the rest. We ensure fast, reliable, and trackable delivery right to your door.'**
  String get homeFeatureDeliveryDetailDescription;

  /// No description provided for @homeFeatureDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Service'**
  String get homeFeatureDefaultTitle;

  /// No description provided for @homeFeatureDefaultDescription.
  ///
  /// In en, this message translates to:
  /// **'We are proud to offer premium service to you and your pets.'**
  String get homeFeatureDefaultDescription;

  /// No description provided for @homePremiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get homePremiumFeature;

  /// No description provided for @homeTrustHappyPets.
  ///
  /// In en, this message translates to:
  /// **'Over 10k\nHappy Pets'**
  String get homeTrustHappyPets;

  /// No description provided for @homeTrustSafeGuaranteed.
  ///
  /// In en, this message translates to:
  /// **'100% Safe\nGuaranteed'**
  String get homeTrustSafeGuaranteed;

  /// No description provided for @homeTrustSupport247.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support\nAvailable'**
  String get homeTrustSupport247;

  /// No description provided for @homeCtaBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to spoil your pet? 🐶'**
  String get homeCtaBannerTitle;

  /// No description provided for @homeStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get homeStartShopping;

  /// No description provided for @homeTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get homeTopRated;

  /// No description provided for @homeExploreCategoriesCta.
  ///
  /// In en, this message translates to:
  /// **'Explore Categories'**
  String get homeExploreCategoriesCta;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @categoriesShopBy.
  ///
  /// In en, this message translates to:
  /// **'Shop by Category'**
  String get categoriesShopBy;

  /// No description provided for @categoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Curated collections for your beloved companions'**
  String get categoriesSubtitle;

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get categoriesEmpty;

  /// No description provided for @categoriesEmptyMoment.
  ///
  /// In en, this message translates to:
  /// **'No categories available at the moment.'**
  String get categoriesEmptyMoment;

  /// No description provided for @categoriesPremiumSelection.
  ///
  /// In en, this message translates to:
  /// **'Premium selection'**
  String get categoriesPremiumSelection;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceDesc;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @filterSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get filterSort;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @productsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Products'**
  String productsCount(int count);

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No products found in this category.'**
  String get noProductsInCategory;

  /// No description provided for @backToCategories.
  ///
  /// In en, this message translates to:
  /// **'Back to categories'**
  String get backToCategories;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @productBadgeSale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get productBadgeSale;

  /// No description provided for @productBadgeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get productBadgeFeatured;

  /// No description provided for @productBadgeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get productBadgeNew;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @relatedProducts.
  ///
  /// In en, this message translates to:
  /// **'Related Products'**
  String get relatedProducts;

  /// No description provided for @productAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart'**
  String get productAddedToCart;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @productPetName.
  ///
  /// In en, this message translates to:
  /// **'Pet Name:'**
  String get productPetName;

  /// No description provided for @productDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance:'**
  String get productDistance;

  /// No description provided for @productDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get productDistanceLabel;

  /// No description provided for @productTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get productTags;

  /// No description provided for @productSex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get productSex;

  /// No description provided for @productAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get productAge;

  /// No description provided for @productBreed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get productBreed;

  /// No description provided for @productAbout.
  ///
  /// In en, this message translates to:
  /// **'About {name}'**
  String productAbout(String name);

  /// No description provided for @productSimilarPets.
  ///
  /// In en, this message translates to:
  /// **'Similar Pets'**
  String get productSimilarPets;

  /// No description provided for @productIWantHim.
  ///
  /// In en, this message translates to:
  /// **'I Want Him'**
  String get productIWantHim;

  /// No description provided for @productIWantHer.
  ///
  /// In en, this message translates to:
  /// **'I Want Her'**
  String get productIWantHer;

  /// No description provided for @productAdding.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get productAdding;

  /// No description provided for @productFindingPerfect.
  ///
  /// In en, this message translates to:
  /// **'Finding your perfect pet...'**
  String get productFindingPerfect;

  /// No description provided for @productCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load this pet.'**
  String get productCouldNotLoad;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for products...'**
  String get searchHint;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the perfect products for your pets'**
  String get searchSubtitle;

  /// No description provided for @searchFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Search by breed, size, or product name...'**
  String get searchFieldHint;

  /// No description provided for @searchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchRecentSearches;

  /// No description provided for @searchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get searchClearAll;

  /// No description provided for @searchPopularSearches.
  ///
  /// In en, this message translates to:
  /// **'Popular Searches'**
  String get searchPopularSearches;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// No description provided for @searchTypeMore.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search'**
  String get searchTypeMore;

  /// No description provided for @searchStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Searching'**
  String get searchStartTitle;

  /// No description provided for @searchStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover premium products for your beloved pets'**
  String get searchStartSubtitle;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find anything for \"{query}\"'**
  String searchNoResultsSubtitle(String query);

  /// No description provided for @searchBrowseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get searchBrowseCategories;

  /// No description provided for @searchResultsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} Products Found'**
  String searchResultsFound(int count);

  /// No description provided for @searchShowingResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Showing results for \"{query}\"'**
  String searchShowingResultsFor(String query);

  /// No description provided for @searchSortAndFilter.
  ///
  /// In en, this message translates to:
  /// **'Sort and filter'**
  String get searchSortAndFilter;

  /// No description provided for @searchPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get searchPriceRange;

  /// No description provided for @sortRelevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get sortRelevance;

  /// No description provided for @sortPriceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get sortPriceLowHigh;

  /// No description provided for @sortPriceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get sortPriceHighLow;

  /// No description provided for @sortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortTopRated;

  /// No description provided for @searchSuggestionPremiumDogFood.
  ///
  /// In en, this message translates to:
  /// **'Premium Dog Food'**
  String get searchSuggestionPremiumDogFood;

  /// No description provided for @searchSuggestionCatToys.
  ///
  /// In en, this message translates to:
  /// **'Cat Toys'**
  String get searchSuggestionCatToys;

  /// No description provided for @searchSuggestionPetBed.
  ///
  /// In en, this message translates to:
  /// **'Pet Bed'**
  String get searchSuggestionPetBed;

  /// No description provided for @searchSuggestionGroomingKit.
  ///
  /// In en, this message translates to:
  /// **'Grooming Kit'**
  String get searchSuggestionGroomingKit;

  /// No description provided for @searchSuggestionLeatherCollar.
  ///
  /// In en, this message translates to:
  /// **'Leather Collar'**
  String get searchSuggestionLeatherCollar;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cartTitle;

  /// No description provided for @cartYourCart.
  ///
  /// In en, this message translates to:
  /// **'Your Cart'**
  String get cartYourCart;

  /// No description provided for @cartReviewItems.
  ///
  /// In en, this message translates to:
  /// **'Review your selected items'**
  String get cartReviewItems;

  /// No description provided for @cartReviewBeforeCheckout.
  ///
  /// In en, this message translates to:
  /// **'Review your selected items before checkout'**
  String get cartReviewBeforeCheckout;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty. Start browsing curated products.'**
  String get cartEmptyMessage;

  /// No description provided for @cartStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get cartStartShopping;

  /// No description provided for @cartBrowseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get cartBrowseCategories;

  /// No description provided for @cartHavePromoCode.
  ///
  /// In en, this message translates to:
  /// **'Have a promo code?'**
  String get cartHavePromoCode;

  /// No description provided for @cartEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code here'**
  String get cartEnterCode;

  /// No description provided for @cartPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo Code'**
  String get cartPromoCode;

  /// No description provided for @cartApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get cartApply;

  /// No description provided for @cartItems.
  ///
  /// In en, this message translates to:
  /// **'Cart Items ({count})'**
  String cartItems(int count);

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// No description provided for @cartDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get cartDiscount;

  /// No description provided for @cartShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get cartShipping;

  /// No description provided for @cartShippingFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get cartShippingFree;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartEstimatedTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total'**
  String get cartEstimatedTotal;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cartCheckout;

  /// No description provided for @cartProceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get cartProceedToCheckout;

  /// No description provided for @cartRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cartRemoveItem;

  /// No description provided for @cartPromoApplied.
  ///
  /// In en, this message translates to:
  /// **'Promo code applied.'**
  String get cartPromoApplied;

  /// No description provided for @cartPromoError.
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code'**
  String get cartPromoError;

  /// No description provided for @cartProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get cartProduct;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your order in just a few steps'**
  String get checkoutSubtitle;

  /// No description provided for @checkoutAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get checkoutAddress;

  /// No description provided for @checkoutPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkoutPayment;

  /// No description provided for @checkoutReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get checkoutReview;

  /// No description provided for @checkoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get checkoutConfirmation;

  /// No description provided for @checkoutShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get checkoutShippingAddress;

  /// No description provided for @checkoutShippingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your delivery information'**
  String get checkoutShippingSubtitle;

  /// No description provided for @checkoutFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get checkoutFullName;

  /// No description provided for @checkoutFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get checkoutFullNameHint;

  /// No description provided for @checkoutPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get checkoutPhone;

  /// No description provided for @checkoutPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+966'**
  String get checkoutPhoneHint;

  /// No description provided for @checkoutStreet.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get checkoutStreet;

  /// No description provided for @checkoutStreetHint.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get checkoutStreetHint;

  /// No description provided for @checkoutDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get checkoutDistrict;

  /// No description provided for @checkoutDistrictHint.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get checkoutDistrictHint;

  /// No description provided for @checkoutCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get checkoutCity;

  /// No description provided for @checkoutCityHint.
  ///
  /// In en, this message translates to:
  /// **''**
  String get checkoutCityHint;

  /// No description provided for @checkoutPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get checkoutPostalCode;

  /// No description provided for @checkoutPostalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get checkoutPostalCodeHint;

  /// No description provided for @checkoutRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get checkoutRequired;

  /// No description provided for @checkoutDeliveryEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimated delivery: 2-4 business days'**
  String get checkoutDeliveryEstimate;

  /// No description provided for @checkoutSelectPayment.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method.'**
  String get checkoutSelectPayment;

  /// No description provided for @checkoutCompleteDetails.
  ///
  /// In en, this message translates to:
  /// **'Please complete all checkout details.'**
  String get checkoutCompleteDetails;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred payment option'**
  String get checkoutPaymentSubtitle;

  /// No description provided for @checkoutNoPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available.'**
  String get checkoutNoPaymentMethods;

  /// No description provided for @checkoutCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get checkoutCreditCard;

  /// No description provided for @checkoutCreditCardDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay securely by card'**
  String get checkoutCreditCardDescription;

  /// No description provided for @checkoutCashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get checkoutCashOnDelivery;

  /// No description provided for @checkoutCashOnDeliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay when your order arrives'**
  String get checkoutCashOnDeliveryDescription;

  /// No description provided for @checkoutOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get checkoutOrderSummary;

  /// No description provided for @checkoutContinueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get checkoutContinueToPayment;

  /// No description provided for @checkoutContinueToReview.
  ///
  /// In en, this message translates to:
  /// **'Continue to Review'**
  String get checkoutContinueToReview;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutSecurePayment.
  ///
  /// In en, this message translates to:
  /// **'Your payment is secure'**
  String get checkoutSecurePayment;

  /// No description provided for @checkoutBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get checkoutBack;

  /// No description provided for @checkoutOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully'**
  String get checkoutOrderPlaced;

  /// No description provided for @checkoutOrderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully!'**
  String get checkoutOrderPlacedTitle;

  /// No description provided for @checkoutOrderPlacedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your purchase. We have received your order and will process it shortly.'**
  String get checkoutOrderPlacedSubtitle;

  /// No description provided for @checkoutBackToShop.
  ///
  /// In en, this message translates to:
  /// **'Back to Shop'**
  String get checkoutBackToShop;

  /// No description provided for @checkoutViewOrders.
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get checkoutViewOrders;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get ordersTitle;

  /// No description provided for @ordersAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersAppBarTitle;

  /// No description provided for @ordersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get ordersEmpty;

  /// No description provided for @ordersNoMatchingFilter.
  ///
  /// In en, this message translates to:
  /// **'No orders found matching this filter.'**
  String get ordersNoMatchingFilter;

  /// No description provided for @ordersAllOrders.
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get ordersAllOrders;

  /// No description provided for @ordersActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ordersActive;

  /// No description provided for @ordersDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get ordersDelivered;

  /// No description provided for @orderStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get orderStatusAll;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String orderNumber(String id);

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get orderPlaced;

  /// No description provided for @orderStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get orderStores;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderItems;

  /// No description provided for @orderTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get orderTracking;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @orderSellerSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Seller Subtotal'**
  String get orderSellerSubtotal;

  /// No description provided for @orderTrackingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Tracking not yet available'**
  String get orderTrackingUnavailable;

  /// No description provided for @receiptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get receiptsTitle;

  /// No description provided for @receiptsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get receiptsAppBarTitle;

  /// No description provided for @receiptsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No receipts found'**
  String get receiptsEmpty;

  /// No description provided for @receiptsNoPurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'No purchase history found.'**
  String get receiptsNoPurchaseHistory;

  /// No description provided for @receiptsTotalSpending.
  ///
  /// In en, this message translates to:
  /// **'Total spending history.'**
  String get receiptsTotalSpending;

  /// No description provided for @receiptsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} receipt'**
  String receiptsCount(int count);

  /// No description provided for @receiptsCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} receipts'**
  String receiptsCountPlural(int count);

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt #{number}'**
  String receiptNumber(String number);

  /// No description provided for @receiptLineItems.
  ///
  /// In en, this message translates to:
  /// **'Line Items'**
  String get receiptLineItems;

  /// No description provided for @receiptProofOfPurchase.
  ///
  /// In en, this message translates to:
  /// **'Proof of Purchase'**
  String get receiptProofOfPurchase;

  /// No description provided for @receiptTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get receiptTotalPaid;

  /// No description provided for @receiptLineItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} line items'**
  String receiptLineItemsCount(int count);

  /// No description provided for @profileOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get profileOrders;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileSaved;

  /// No description provided for @profileWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get profileWishlist;

  /// No description provided for @profileAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get profileAddresses;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English / Arabic'**
  String get profileLanguageSubtitle;

  /// No description provided for @profileAddAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get profileAddAddress;

  /// No description provided for @profileEditAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get profileEditAddress;

  /// No description provided for @profileDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get profileDeleteAddress;

  /// No description provided for @profileQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get profileQuickAccess;

  /// No description provided for @profileOrdersTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get profileOrdersTrack;

  /// No description provided for @profileReceiptsInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get profileReceiptsInvoices;

  /// No description provided for @profileMyPets.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get profileMyPets;

  /// No description provided for @profileMyPetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your pets'**
  String get profileMyPetsSubtitle;

  /// No description provided for @profileMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get profileMyBookings;

  /// No description provided for @profileMyBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View appointments'**
  String get profileMyBookingsSubtitle;

  /// No description provided for @myPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get myPetsTitle;

  /// No description provided for @myBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookingsTitle;

  /// No description provided for @addPet.
  ///
  /// In en, this message translates to:
  /// **'Add Pet'**
  String get addPet;

  /// No description provided for @addBooking.
  ///
  /// In en, this message translates to:
  /// **'Add Booking'**
  String get addBooking;

  /// No description provided for @noPetsFound.
  ///
  /// In en, this message translates to:
  /// **'No pets found. Add a pet to get started!'**
  String get noPetsFound;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found. Book a service to get started!'**
  String get noBookingsFound;

  /// No description provided for @profilePrimaryAddress.
  ///
  /// In en, this message translates to:
  /// **'Primary Address'**
  String get profilePrimaryAddress;

  /// No description provided for @profileNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No address saved yet.'**
  String get profileNoAddress;

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profileWishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty.'**
  String get profileWishlistEmpty;

  /// No description provided for @profileWishlistItems.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String profileWishlistItems(int count);

  /// No description provided for @profileCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile.'**
  String get profileCouldNotLoad;

  /// No description provided for @profileView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get profileView;

  /// No description provided for @profileDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileDetailTitle;

  /// No description provided for @profileAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get profileAccountInfo;

  /// No description provided for @profileAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get profileAccountStatus;

  /// No description provided for @profileSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get profileSavedAddresses;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsername;

  /// No description provided for @profileAccountVerified.
  ///
  /// In en, this message translates to:
  /// **'Account Verified'**
  String get profileAccountVerified;

  /// No description provided for @profileAccountActive.
  ///
  /// In en, this message translates to:
  /// **'Account Active'**
  String get profileAccountActive;

  /// No description provided for @profileRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get profileRegistration;

  /// No description provided for @profileVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profileVerified;

  /// No description provided for @profilePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get profilePending;

  /// No description provided for @profileActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profileActive;

  /// No description provided for @profileInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get profileInactive;

  /// No description provided for @profileDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get profileDefault;

  /// No description provided for @profileNoAddressesSaved.
  ///
  /// In en, this message translates to:
  /// **'No addresses saved yet.'**
  String get profileNoAddressesSaved;

  /// No description provided for @profileUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileUser;

  /// No description provided for @profileLanguageEnglishCode.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get profileLanguageEnglishCode;

  /// No description provided for @profileLanguageArabicCode.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get profileLanguageArabicCode;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationOrderShippedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order shipped'**
  String get notificationOrderShippedTitle;

  /// No description provided for @notificationOrderShippedBody.
  ///
  /// In en, this message translates to:
  /// **'Your premium dog food is on the way.'**
  String get notificationOrderShippedBody;

  /// No description provided for @notificationOrderShippedTime.
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get notificationOrderShippedTime;

  /// No description provided for @notificationFlashSaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Flash sale event'**
  String get notificationFlashSaleTitle;

  /// No description provided for @notificationFlashSaleBody.
  ///
  /// In en, this message translates to:
  /// **'Get 20% off all cat accessories this weekend.'**
  String get notificationFlashSaleBody;

  /// No description provided for @notificationFlashSaleTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationFlashSaleTime;

  /// No description provided for @notificationWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Zoovana'**
  String get notificationWelcomeTitle;

  /// No description provided for @notificationWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Thanks for joining our premium pet community.'**
  String get notificationWelcomeBody;

  /// No description provided for @notificationWelcomeTime.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get notificationWelcomeTime;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back, Pet Parent!'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your cart, orders, and exclusive member deals'**
  String get loginSubtitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get loginRegister;

  /// No description provided for @loginNewToZoovana.
  ///
  /// In en, this message translates to:
  /// **'New to Zoovana?'**
  String get loginNewToZoovana;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get loginCreateAccount;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get loginError;

  /// No description provided for @loginFreeShipping.
  ///
  /// In en, this message translates to:
  /// **'Free Shipping'**
  String get loginFreeShipping;

  /// No description provided for @loginVetApproved.
  ///
  /// In en, this message translates to:
  /// **'Vet Approved'**
  String get loginVetApproved;

  /// No description provided for @loginEasyReturns.
  ///
  /// In en, this message translates to:
  /// **'Easy Returns'**
  String get loginEasyReturns;

  /// No description provided for @loginValidateEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get loginValidateEmail;

  /// No description provided for @loginValidateEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginValidateEmailFormat;

  /// No description provided for @loginValidatePassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginValidatePassword;

  /// No description provided for @loginValidatePasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginValidatePasswordLength;

  /// No description provided for @authChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get authChangeLanguage;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @registerCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerCreateAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Zoovana for a premium pet shopping experience.'**
  String get registerSubtitle;

  /// No description provided for @registerName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get registerName;

  /// No description provided for @registerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get registerNameHint;

  /// No description provided for @registerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmail;

  /// No description provided for @registerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get registerPhone;

  /// No description provided for @registerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'05XXXXXXXX'**
  String get registerPhoneHint;

  /// No description provided for @registerPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPassword;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get registerSignIn;

  /// No description provided for @registerAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get registerAccountCreated;

  /// No description provided for @registerCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'Please check your email to verify your account before signing in.'**
  String get registerCheckEmail;

  /// No description provided for @registerValidateName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get registerValidateName;

  /// No description provided for @registerValidateEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get registerValidateEmail;

  /// No description provided for @registerValidateEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get registerValidateEmailFormat;

  /// No description provided for @registerValidatePassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get registerValidatePassword;

  /// No description provided for @registerValidatePasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get registerValidatePasswordLength;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordResetTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordCheckEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get forgotPasswordCheckEmailTitle;

  /// No description provided for @forgotPasswordCheckEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a reset link to {email}.'**
  String forgotPasswordCheckEmailSubtitle(String email);

  /// No description provided for @forgotPasswordSpamNote.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive it? Check your spam folder or try again in a few minutes.'**
  String get forgotPasswordSpamNote;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordBackToLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get forgotPasswordBackToLoginLink;

  /// No description provided for @forgotPasswordEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get forgotPasswordEmail;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to your email'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordValidateEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgotPasswordValidateEmail;

  /// No description provided for @forgotPasswordValidateEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get forgotPasswordValidateEmailFormat;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Cached data will be used when available.'**
  String get offlineBanner;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error;

  /// No description provided for @errorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorTryAgain;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNoInternet;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password. Please try again.'**
  String get errorWrongCredentials;

  /// No description provided for @errorServerDown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get errorServerDown;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorInvalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request. Please check your input.'**
  String get errorInvalidRequest;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do that.'**
  String get errorPermissionDenied;

  /// No description provided for @errorResourceNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get errorResourceNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'A conflict occurred. Please try again.'**
  String get errorConflict;

  /// No description provided for @errorCheckInput.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get errorCheckInput;

  /// No description provided for @offlineCachedData.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Showing cached data.'**
  String get offlineCachedData;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Add to wishlist'**
  String get addToWishlist;

  /// No description provided for @removeFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get removeFromWishlist;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Saudi phone number (05XXXXXXXX)'**
  String get phoneInvalid;

  /// No description provided for @couldNotLoadOrder.
  ///
  /// In en, this message translates to:
  /// **'Could not load order.'**
  String get couldNotLoadOrder;

  /// No description provided for @couldNotLoadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Could not load receipt.'**
  String get couldNotLoadReceipt;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @currencySar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySar;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
