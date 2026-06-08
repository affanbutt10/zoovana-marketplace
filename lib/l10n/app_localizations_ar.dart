// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCategories => 'الفئات';

  @override
  String get navSearch => 'بحث';

  @override
  String get navCart => 'السلة';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get homeTitle => 'زوفانا';

  @override
  String get homeGreetingMorning => 'صباح الخير';

  @override
  String get homeGreetingAfternoon => 'مساء الخير';

  @override
  String get homeGreetingEvening => 'مساء الخير';

  @override
  String get homeGreetingSubtitle => 'هل أنت مستعد لصديق جديد؟';

  @override
  String homeHi(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get homePopularTitle => 'الحيوانات والمنتجات الشائعة';

  @override
  String get homeDiscoverTitle => 'اكتشف حيوانات جديدة';

  @override
  String get homeViewAll => 'عرض الكل';

  @override
  String get homeNewCollection => 'مجموعة جديدة';

  @override
  String get homeHeroHeadline => 'كل ما يحتاجه\nحيوانك الأليف.';

  @override
  String get homeHeroSubtitle => 'في مكان واحد.';

  @override
  String get homeShopNow => 'تسوق الآن';

  @override
  String get homeFeaturedProducts => 'المنتجات المميزة';

  @override
  String get homeTrustFreeDelivery => 'توصيل مجاني';

  @override
  String get homeTrustSecurePayment => 'دفع آمن';

  @override
  String get homeTrustQualityGuarantee => 'ضمان الجودة';

  @override
  String get homeTrustSupport => 'دعم على مدار الساعة';

  @override
  String get homeTryAgain => 'حاول مجدداً';

  @override
  String get homeGuestName => 'ضيف';

  @override
  String get homeExploreCategories => 'استكشف أبرز الفئات';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeFeatureWideSelection => 'تشكيلة واسعة';

  @override
  String get homeFeatureWideSelectionSub => 'كلاب، قطط والمزيد';

  @override
  String get homeFeatureQualityProducts => 'منتجات عالية الجودة';

  @override
  String get homeFeatureQualityProductsSub => 'طعام وإكسسوارات';

  @override
  String get homeFeatureFastDelivery => 'توصيل سريع';

  @override
  String get homeFeatureFastDeliverySub => 'مباشرة إلى بابك';

  @override
  String get homeFeatureSelectionDetailTitle =>
      'تشكيلة واسعة للحيوانات الأليفة';

  @override
  String get homeFeatureSelectionDetailDescription =>
      'نقدم تشكيلة رائعة من الحيوانات الأليفة، من الكلاب المرحة إلى القطط الهادئة والطيور المغردة. اعثر على رفيقك المثالي بين حيوانات صحية وسعيدة تم التحقق منها بعناية.';

  @override
  String get homeFeatureQualityDetailDescription =>
      'امنح حيوانك الأفضل مع تشكيلتنا المميزة من الطعام والألعاب المتينة والإكسسوارات المريحة. نوفر علامات موثوقة تساعد على رعاية أصدقائك الصغار.';

  @override
  String get homeFeatureDeliveryDetailDescription =>
      'تسوق من راحة منزلك واترك الباقي علينا. نوفر توصيلاً سريعاً وموثوقاً وقابلاً للتتبع حتى بابك.';

  @override
  String get homeFeatureDefaultTitle => 'خدمة مميزة';

  @override
  String get homeFeatureDefaultDescription =>
      'نفخر بتقديم خدمة مميزة لك ولحيواناتك الأليفة.';

  @override
  String get homePremiumFeature => 'ميزة مميزة';

  @override
  String get homeTrustHappyPets => 'أكثر من 10 آلاف\nحيوان سعيد';

  @override
  String get homeTrustSafeGuaranteed => '100% آمن\nمضمون';

  @override
  String get homeTrustSupport247 => 'دعم على مدار\nالساعة';

  @override
  String get homeCtaBannerTitle => 'هل أنت مستعد لإسعاد حيوانك؟ 🐶';

  @override
  String get homeStartShopping => 'ابدأ التسوق';

  @override
  String get homeTopRated => 'الأعلى تقييماً';

  @override
  String get homeExploreCategoriesCta => 'استكشف الفئات';

  @override
  String get categoriesTitle => 'الفئات';

  @override
  String get categoriesShopBy => 'تسوق حسب الفئة';

  @override
  String get categoriesSubtitle => 'مجموعات منتقاة لرفاقك الأعزاء';

  @override
  String get categoriesEmpty => 'لا توجد فئات متاحة';

  @override
  String get categoriesEmptyMoment => 'لا توجد فئات متاحة في الوقت الحالي.';

  @override
  String get categoriesPremiumSelection => 'اختيار مميز';

  @override
  String get sortPriceAsc => 'السعر: من الأقل إلى الأعلى';

  @override
  String get sortPriceDesc => 'السعر: من الأعلى إلى الأقل';

  @override
  String get sortNewest => 'الأحدث';

  @override
  String get filterSort => 'ترتيب';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String productsCount(int count) {
    return '$count منتج';
  }

  @override
  String get noProductsInCategory => 'لم يتم العثور على منتجات في هذه الفئة.';

  @override
  String get backToCategories => 'العودة إلى الفئات';

  @override
  String get addToCart => 'إضافة إلى السلة';

  @override
  String get outOfStock => 'نفد المخزون';

  @override
  String get productBadgeSale => 'تخفيض';

  @override
  String get productBadgeFeatured => 'مميز';

  @override
  String get productBadgeNew => 'جديد';

  @override
  String get quantity => 'الكمية';

  @override
  String get relatedProducts => 'منتجات ذات صلة';

  @override
  String get productAddedToCart => 'تمت إضافة المنتج إلى السلة';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get productPetName => 'اسم الحيوان:';

  @override
  String get productDistance => 'المسافة:';

  @override
  String get productDistanceLabel => 'المسافة';

  @override
  String get productTags => 'الوسوم';

  @override
  String get productSex => 'الجنس';

  @override
  String get productAge => 'العمر';

  @override
  String get productBreed => 'السلالة';

  @override
  String productAbout(String name) {
    return 'عن $name';
  }

  @override
  String get productSimilarPets => 'حيوانات مشابهة';

  @override
  String get productIWantHim => 'أريده';

  @override
  String get productIWantHer => 'أريدها';

  @override
  String get productAdding => 'جارٍ الإضافة...';

  @override
  String get productFindingPerfect => 'نبحث عن حيوانك المثالي...';

  @override
  String get productCouldNotLoad => 'تعذّر تحميل هذا الحيوان.';

  @override
  String get searchHint => 'ابحث عن المنتجات...';

  @override
  String get searchTitle => 'بحث';

  @override
  String get searchSubtitle => 'ابحث عن المنتجات المثالية لحيواناتك';

  @override
  String get searchFieldHint => 'ابحث بالسلالة أو الحجم أو اسم المنتج...';

  @override
  String get searchRecentSearches => 'عمليات البحث الأخيرة';

  @override
  String get searchClearAll => 'مسح الكل';

  @override
  String get searchPopularSearches => 'عمليات البحث الشائعة';

  @override
  String get searchNoResults => 'لم يتم العثور على نتائج';

  @override
  String get searchTypeMore => 'اكتب حرفين على الأقل للبحث';

  @override
  String get searchStartTitle => 'ابدأ البحث';

  @override
  String get searchStartSubtitle => 'اكتشف منتجات مميزة لحيواناتك الأليفة';

  @override
  String get searchNoResultsTitle => 'لا توجد نتائج';

  @override
  String searchNoResultsSubtitle(String query) {
    return 'لم نتمكن من العثور على أي شيء لـ \"$query\"';
  }

  @override
  String get searchBrowseCategories => 'تصفح الفئات';

  @override
  String searchResultsFound(int count) {
    return 'تم العثور على $count منتج';
  }

  @override
  String searchShowingResultsFor(String query) {
    return 'عرض نتائج \"$query\"';
  }

  @override
  String get searchSortAndFilter => 'الفرز والتصفية';

  @override
  String get searchPriceRange => 'نطاق السعر';

  @override
  String get sortRelevance => 'الأكثر صلة';

  @override
  String get sortPriceLowHigh => 'السعر: من الأقل إلى الأعلى';

  @override
  String get sortPriceHighLow => 'السعر: من الأعلى إلى الأقل';

  @override
  String get sortTopRated => 'الأعلى تقييماً';

  @override
  String get searchSuggestionPremiumDogFood => 'طعام كلاب فاخر';

  @override
  String get searchSuggestionCatToys => 'ألعاب القطط';

  @override
  String get searchSuggestionPetBed => 'سرير للحيوان الأليف';

  @override
  String get searchSuggestionGroomingKit => 'مجموعة العناية';

  @override
  String get searchSuggestionLeatherCollar => 'طوق جلدي';

  @override
  String get cartTitle => 'سلتي';

  @override
  String get cartYourCart => 'سلتك';

  @override
  String get cartReviewItems => 'راجع العناصر المحددة';

  @override
  String get cartReviewBeforeCheckout => 'راجع العناصر المحددة قبل الدفع';

  @override
  String get cartEmpty => 'سلتك فارغة';

  @override
  String get cartEmptyMessage => 'سلتك فارغة. ابدأ تصفح المنتجات المنتقاة.';

  @override
  String get cartStartShopping => 'ابدأ التسوق';

  @override
  String get cartBrowseCategories => 'تصفح الفئات';

  @override
  String get cartHavePromoCode => 'هل لديك رمز خصم؟';

  @override
  String get cartEnterCode => 'أدخل الرمز هنا';

  @override
  String get cartPromoCode => 'رمز الخصم';

  @override
  String get cartApply => 'تطبيق';

  @override
  String cartItems(int count) {
    return 'عناصر السلة ($count)';
  }

  @override
  String get cartSubtotal => 'المجموع الفرعي';

  @override
  String get cartDiscount => 'الخصم';

  @override
  String get cartShipping => 'الشحن';

  @override
  String get cartShippingFree => 'مجاني';

  @override
  String get cartTotal => 'الإجمالي';

  @override
  String get cartEstimatedTotal => 'الإجمالي التقديري';

  @override
  String get cartCheckout => 'الدفع';

  @override
  String get cartProceedToCheckout => 'المتابعة للدفع';

  @override
  String get cartRemoveItem => 'إزالة';

  @override
  String get cartPromoApplied => 'تم تطبيق رمز الخصم.';

  @override
  String get cartPromoError => 'رمز الخصم غير صالح';

  @override
  String get cartProduct => 'منتج';

  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get checkoutSubtitle => 'أتمم طلبك في خطوات بسيطة';

  @override
  String get checkoutAddress => 'العنوان';

  @override
  String get checkoutPayment => 'الدفع';

  @override
  String get checkoutReview => 'المراجعة';

  @override
  String get checkoutConfirmation => 'التأكيد';

  @override
  String get checkoutShippingAddress => 'عنوان الشحن';

  @override
  String get checkoutShippingSubtitle => 'أدخل معلومات التوصيل';

  @override
  String get checkoutFullName => 'الاسم الكامل';

  @override
  String get checkoutFullNameHint => 'الاسم الكامل';

  @override
  String get checkoutPhone => 'رقم الهاتف';

  @override
  String get checkoutPhoneHint => '+966';

  @override
  String get checkoutStreet => 'عنوان الشارع';

  @override
  String get checkoutStreetHint => 'عنوان الشارع';

  @override
  String get checkoutDistrict => 'الحي';

  @override
  String get checkoutDistrictHint => 'الحي';

  @override
  String get checkoutCity => 'المدينة';

  @override
  String get checkoutCityHint => '';

  @override
  String get checkoutPostalCode => 'الرمز البريدي';

  @override
  String get checkoutPostalCodeHint => 'الرمز البريدي';

  @override
  String get checkoutRequired => 'مطلوب';

  @override
  String get checkoutDeliveryEstimate => 'التوصيل المتوقع: ٢-٤ أيام عمل';

  @override
  String get checkoutSelectPayment => 'يرجى اختيار طريقة دفع.';

  @override
  String get checkoutCompleteDetails => 'يرجى إكمال جميع تفاصيل الدفع.';

  @override
  String get checkoutPaymentMethod => 'طريقة الدفع';

  @override
  String get checkoutPaymentSubtitle => 'اختر طريقة الدفع المفضلة لديك';

  @override
  String get checkoutNoPaymentMethods => 'لا توجد طرق دفع متاحة.';

  @override
  String get checkoutCreditCard => 'بطاقة ائتمانية';

  @override
  String get checkoutCreditCardDescription => 'ادفع بأمان عبر البطاقة';

  @override
  String get checkoutCashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get checkoutCashOnDeliveryDescription => 'ادفع عند وصول طلبك';

  @override
  String get checkoutOrderSummary => 'ملخص الطلب';

  @override
  String get checkoutContinueToPayment => 'المتابعة للدفع';

  @override
  String get checkoutContinueToReview => 'المتابعة للمراجعة';

  @override
  String get checkoutPlaceOrder => 'تأكيد الطلب';

  @override
  String get checkoutSecurePayment => 'مدفوعاتك آمنة';

  @override
  String get checkoutBack => 'رجوع';

  @override
  String get checkoutOrderPlaced => 'تم تقديم الطلب بنجاح';

  @override
  String get checkoutOrderPlacedTitle => 'تم تقديم الطلب بنجاح!';

  @override
  String get checkoutOrderPlacedSubtitle =>
      'شكراً لشرائك. لقد استلمنا طلبك وسنعالجه قريباً.';

  @override
  String get checkoutBackToShop => 'العودة للتسوق';

  @override
  String get checkoutViewOrders => 'عرض الطلبات';

  @override
  String get ordersTitle => 'طلباتي';

  @override
  String get ordersAppBarTitle => 'الطلبات';

  @override
  String get ordersEmpty => 'لا توجد طلبات';

  @override
  String get ordersNoMatchingFilter => 'لا توجد طلبات تطابق هذا الفلتر.';

  @override
  String get ordersAllOrders => 'جميع الطلبات';

  @override
  String get ordersActive => 'نشط';

  @override
  String get ordersDelivered => 'تم التسليم';

  @override
  String get orderStatusAll => 'الكل';

  @override
  String get orderStatusPending => 'قيد الانتظار';

  @override
  String get orderStatusProcessing => 'قيد المعالجة';

  @override
  String get orderStatusShipped => 'تم الشحن';

  @override
  String get orderStatusDelivered => 'تم التسليم';

  @override
  String get orderStatusCancelled => 'ملغي';

  @override
  String orderNumber(String id) {
    return 'طلب #$id';
  }

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get orderPlaced => 'تاريخ الطلب';

  @override
  String get orderStores => 'المتاجر';

  @override
  String get orderItems => 'العناصر';

  @override
  String get orderTracking => 'التتبع';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get orderSellerSubtotal => 'مجموع البائع';

  @override
  String get orderTrackingUnavailable => 'التتبع غير متاح بعد';

  @override
  String get receiptsTitle => 'الإيصالات';

  @override
  String get receiptsAppBarTitle => 'الإيصالات';

  @override
  String get receiptsEmpty => 'لا توجد إيصالات';

  @override
  String get receiptsNoPurchaseHistory => 'لا يوجد سجل مشتريات.';

  @override
  String get receiptsTotalSpending => 'إجمالي سجل الإنفاق.';

  @override
  String receiptsCount(int count) {
    return '$count إيصال';
  }

  @override
  String receiptsCountPlural(int count) {
    return '$count إيصالات';
  }

  @override
  String receiptNumber(String number) {
    return 'إيصال #$number';
  }

  @override
  String get receiptLineItems => 'بنود الفاتورة';

  @override
  String get receiptProofOfPurchase => 'إثبات الشراء';

  @override
  String get receiptTotalPaid => 'إجمالي المدفوع';

  @override
  String receiptLineItemsCount(int count) {
    return '$count بند';
  }

  @override
  String get profileOrders => 'الطلبات';

  @override
  String get profileSaved => 'المحفوظات';

  @override
  String get profileWishlist => 'المفضلة';

  @override
  String get profileAddresses => 'العناوين';

  @override
  String get profileSettings => 'الإعدادات';

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get profileLogoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileLanguageSubtitle => 'العربية / الإنجليزية';

  @override
  String get profileAddAddress => 'إضافة عنوان';

  @override
  String get profileEditAddress => 'تعديل العنوان';

  @override
  String get profileDeleteAddress => 'حذف العنوان';

  @override
  String get profileQuickAccess => 'وصول سريع';

  @override
  String get profileOrdersTrack => 'تتبع';

  @override
  String get profileReceiptsInvoices => 'الفواتير';

  @override
  String get profileMyPets => 'حيواناتي الأليفة';

  @override
  String get profileMyPetsSubtitle => 'إدارة حيواناتك';

  @override
  String get profileMyBookings => 'حجوزاتي';

  @override
  String get profileMyBookingsSubtitle => 'عرض المواعيد';

  @override
  String get myPetsTitle => 'حيواناتي الأليفة';

  @override
  String get myBookingsTitle => 'حجوزاتي';

  @override
  String get addPet => 'إضافة أليف';

  @override
  String get addBooking => 'إضافة حجز';

  @override
  String get noPetsFound =>
      'لم يتم العثور على حيوانات أليفة. أضف حيوانًا للبدء!';

  @override
  String get noBookingsFound => 'لم يتم العثور على حجوزات. احجز خدمة للبدء!';

  @override
  String get profilePrimaryAddress => 'العنوان الرئيسي';

  @override
  String get profileNoAddress => 'لم يتم حفظ أي عنوان بعد.';

  @override
  String get profilePreferences => 'التفضيلات';

  @override
  String get profileWishlistEmpty => 'قائمة المفضلة فارغة.';

  @override
  String profileWishlistItems(int count) {
    return '$count عناصر';
  }

  @override
  String get profileCouldNotLoad => 'تعذّر تحميل الملف الشخصي.';

  @override
  String get profileView => 'عرض';

  @override
  String get profileDetailTitle => 'ملفي الشخصي';

  @override
  String get profileAccountInfo => 'معلومات الحساب';

  @override
  String get profileAccountStatus => 'حالة الحساب';

  @override
  String get profileSavedAddresses => 'العناوين المحفوظة';

  @override
  String get profileFullName => 'الاسم الكامل';

  @override
  String get profileEmail => 'البريد الإلكتروني';

  @override
  String get profilePhone => 'الهاتف';

  @override
  String get profileUsername => 'اسم المستخدم';

  @override
  String get profileAccountVerified => 'الحساب موثق';

  @override
  String get profileAccountActive => 'الحساب نشط';

  @override
  String get profileRegistration => 'التسجيل';

  @override
  String get profileVerified => 'موثق';

  @override
  String get profilePending => 'قيد الانتظار';

  @override
  String get profileActive => 'نشط';

  @override
  String get profileInactive => 'غير نشط';

  @override
  String get profileDefault => 'افتراضي';

  @override
  String get profileNoAddressesSaved => 'لم يتم حفظ أي عنوان بعد.';

  @override
  String get profileUser => 'مستخدم';

  @override
  String get profileLanguageEnglishCode => 'EN';

  @override
  String get profileLanguageArabicCode => 'AR';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationOrderShippedTitle => 'تم شحن الطلب';

  @override
  String get notificationOrderShippedBody =>
      'طعام الكلاب الفاخر في طريقه إليك.';

  @override
  String get notificationOrderShippedTime => 'قبل ساعتين';

  @override
  String get notificationFlashSaleTitle => 'عرض سريع';

  @override
  String get notificationFlashSaleBody =>
      'احصل على خصم 20% على جميع إكسسوارات القطط هذا الأسبوع.';

  @override
  String get notificationFlashSaleTime => 'أمس';

  @override
  String get notificationWelcomeTitle => 'مرحباً بك في زوفانا';

  @override
  String get notificationWelcomeBody =>
      'شكراً لانضمامك إلى مجتمع زوفانا المميز للحيوانات الأليفة.';

  @override
  String get notificationWelcomeTime => 'قبل يومين';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginWelcome => 'مرحباً بعودتك، أيها المربي!';

  @override
  String get loginSubtitle =>
      'سجّل دخولك للوصول إلى سلتك وطلباتك وعروض الأعضاء الحصرية';

  @override
  String get loginEmail => 'البريد الإلكتروني';

  @override
  String get loginEmailHint => 'you@example.com';

  @override
  String get loginPassword => 'كلمة المرور';

  @override
  String get loginPasswordHint => '••••••••';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get loginForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginRegister => 'ليس لديك حساب؟ سجل الآن';

  @override
  String get loginNewToZoovana => 'جديد في زوفانا؟';

  @override
  String get loginCreateAccount => 'إنشاء حساب';

  @override
  String get loginError => 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get loginFreeShipping => 'شحن مجاني';

  @override
  String get loginVetApproved => 'معتمد من الأطباء البيطريين';

  @override
  String get loginEasyReturns => 'إرجاع سهل';

  @override
  String get loginValidateEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get loginValidateEmailFormat => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get loginValidatePassword => 'يرجى إدخال كلمة المرور';

  @override
  String get loginValidatePasswordLength =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get authChangeLanguage => 'تغيير اللغة';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerCreateAccount => 'إنشاء حساب';

  @override
  String get registerSubtitle =>
      'انضم إلى زوفانا لتجربة تسوق مميزة لحيواناتك الأليفة.';

  @override
  String get registerName => 'الاسم الكامل';

  @override
  String get registerNameHint => 'محمد أحمد';

  @override
  String get registerEmail => 'البريد الإلكتروني';

  @override
  String get registerPhone => 'رقم الهاتف';

  @override
  String get registerPhoneHint => '05XXXXXXXX';

  @override
  String get registerPassword => 'كلمة المرور';

  @override
  String get registerButton => 'إنشاء حساب';

  @override
  String get registerAlreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get registerSignIn => 'تسجيل الدخول';

  @override
  String get registerAccountCreated => 'تم إنشاء الحساب';

  @override
  String get registerCheckEmail =>
      'يرجى التحقق من بريدك الإلكتروني لتفعيل حسابك قبل تسجيل الدخول.';

  @override
  String get registerValidateName => 'يرجى إدخال اسمك';

  @override
  String get registerValidateEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get registerValidateEmailFormat => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get registerValidatePassword => 'يرجى إدخال كلمة مرور';

  @override
  String get registerValidatePasswordLength =>
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordResetTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get forgotPasswordCheckEmailTitle => 'تحقق من بريدك الإلكتروني';

  @override
  String forgotPasswordCheckEmailSubtitle(String email) {
    return 'لقد أرسلنا رابط إعادة التعيين إلى $email.';
  }

  @override
  String get forgotPasswordSpamNote =>
      'لم تستلمه؟ تحقق من مجلد البريد العشوائي أو حاول مجدداً بعد دقائق.';

  @override
  String get forgotPasswordBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get forgotPasswordBackToLoginLink => 'العودة لتسجيل الدخول';

  @override
  String get forgotPasswordEmail => 'عنوان البريد الإلكتروني';

  @override
  String get forgotPasswordEmailHint => 'you@example.com';

  @override
  String get forgotPasswordSend => 'إرسال رابط إعادة التعيين';

  @override
  String get forgotPasswordSuccess =>
      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني';

  @override
  String get forgotPasswordValidateEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get forgotPasswordValidateEmailFormat =>
      'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get offlineBanner =>
      'أنت غير متصل بالإنترنت. سيتم استخدام البيانات المخزنة عند توفرها.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get error => 'حدث خطأ ما';

  @override
  String get errorTryAgain => 'حدث خطأ ما. يرجى المحاولة مجدداً.';

  @override
  String get errorNoInternet =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك.';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب. يرجى المحاولة مجدداً.';

  @override
  String get errorSessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مجدداً.';

  @override
  String get errorWrongCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مجدداً.';

  @override
  String get errorServerDown => 'حدث خطأ من جانبنا. يرجى المحاولة لاحقاً.';

  @override
  String get errorTooManyRequests =>
      'طلبات كثيرة جداً. يرجى الانتظار لحظة والمحاولة مجدداً.';

  @override
  String get errorInvalidRequest =>
      'الطلب غير صالح. يرجى التحقق من البيانات المدخلة.';

  @override
  String get errorPermissionDenied => 'ليست لديك صلاحية لتنفيذ هذا الإجراء.';

  @override
  String get errorResourceNotFound => 'لم يتم العثور على المورد المطلوب.';

  @override
  String get errorConflict => 'حدث تعارض. يرجى المحاولة مجدداً.';

  @override
  String get errorCheckInput => 'يرجى التحقق من البيانات والمحاولة مجدداً.';

  @override
  String get offlineCachedData =>
      'لا يوجد اتصال بالإنترنت. يتم عرض البيانات المخزنة.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get confirm => 'تأكيد';

  @override
  String get back => 'رجوع';

  @override
  String get close => 'إغلاق';

  @override
  String get addToWishlist => 'إضافة إلى قائمة الرغبات';

  @override
  String get removeFromWishlist => 'إزالة من قائمة الرغبات';

  @override
  String get phoneInvalid => 'يرجى إدخال رقم هاتف سعودي صالح (05XXXXXXXX)';

  @override
  String get couldNotLoadOrder => 'تعذّر تحميل الطلب.';

  @override
  String get couldNotLoadReceipt => 'تعذّر تحميل الإيصال.';

  @override
  String get tryAgain => 'حاول مجدداً';

  @override
  String get currencySar => 'ر.س';
}
