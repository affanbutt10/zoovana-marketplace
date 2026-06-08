import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/pet_ui_adapter.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../widgets/cached_image.dart';
import 'bindings/home_binding.dart';
import 'controllers/home_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../routes/app_route_observer.dart';
import '../../routes/app_routes.dart';
import '../shell/controllers/app_shell_controller.dart';

void _openShellTab(int index, String fallbackRoute) {
  if (Get.isRegistered<AppShellController>()) {
    Get.find<AppShellController>().setIndex(index);
  } else {
    Get.toNamed(fallbackRoute);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  PageRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    HomeBinding.ensureInitialized();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && route != _route) {
      if (_route != null) {
        appRouteObserver.unsubscribe(this);
      }
      _route = route;
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshDashboard();
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFABC8FD), // slightly deeper blue tint at top
              Color(0xFFDDE8FF), // richer mid tone
              Color(0xFFF8FBFF), // softer white bottom
            ],
          ),
        ),
        child: GetBuilder<HomeController>(
          builder: (controller) {
            final state = controller.state;

            if (state.isLoading) return _buildShimmerLoading();
            if (state.error != null) {
              return AppStateView.error(
                message: state.error!,
                actionLabel:
                    AppLocalizations.of(context)?.homeTryAgain ?? 'Try again',
                onAction: controller.loadHome,
              );
            }

            final allProducts = <Product>[
              ...state.featuredProducts,
              ...state.freshArrivals,
            ];

            return RefreshIndicator(
              onRefresh: controller.refreshDashboard,
              color: AppColors.brandOrange,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _GreetingHeader(
                      compact: false,
                      name: state.userName,
                    ),
                  ),

                  // Hero Section
                  SliverToBoxAdapter(
                    child: const _HeroSection()
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.05, curve: AppMotion.emphasis),
                  ),

                  // Features Strip
                  SliverPadding(
                    padding: const EdgeInsets.only(top: AppSpacing.base),
                    sliver: SliverToBoxAdapter(
                      child: const _FeatureStrip().animate().fadeIn(
                        delay: 200.ms,
                      ),
                    ),
                  ),

                  // Categories
                  if (state.categories.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.only(top: AppSpacing.base),
                      sliver: SliverToBoxAdapter(
                        child: _InteractiveCategoryGrid(
                          categories: state.categories,
                        ).animate().fadeIn(delay: 300.ms),
                      ),
                    ),

                  // Popular Products
                  if (allProducts.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.only(top: AppSpacing.base),
                      sliver: SliverToBoxAdapter(
                        child: _PopularPetsCarousel(
                          title:
                              AppLocalizations.of(context)?.homePopularTitle ??
                              'Popular Pets & Products',
                          products: allProducts,
                          onAddToCart: (p) =>
                              _handleAddToCart(context, controller, p),
                        ).animate().fadeIn(delay: 400.ms),
                      ),
                    ),

                  // Trust Signals
                  SliverPadding(
                    padding: const EdgeInsets.only(top: AppSpacing.base),
                    sliver: SliverToBoxAdapter(
                      child: const _TrustSignals().animate().fadeIn(
                        delay: 500.ms,
                      ),
                    ),
                  ),

                  if (state.freshArrivals.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.base,
                        AppSpacing.screenPadding,
                        AppSpacing.sm,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.homeDiscoverTitle ??
                                  'Discover New Pets',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _openShellTab(2, AppRoutes.search),
                              child: Text(
                                AppLocalizations.of(context)?.homeViewAll ??
                                    'View All',
                                style: const TextStyle(
                                  color: AppColors.brandOrange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (state.freshArrivals.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.md,
                              childAspectRatio: 0.72,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = state.freshArrivals[index];
                            return _CarouselProductCard(
                                  product: product,
                                  onTap: () =>
                                      Get.toNamed('/product/${product.id}'),
                                  onAddToCart: () => _handleAddToCart(
                                    context,
                                    controller,
                                    product,
                                  ),
                                  index: index,
                                )
                                .animate()
                                .fadeIn(delay: (index * 50).ms)
                                .slideY(begin: 0.1);
                          },
                          childCount: state.freshArrivals.length > 4
                              ? 4
                              : state.freshArrivals.length,
                        ),
                      ),
                    ),

                  // Bottom CTA
                  SliverPadding(
                    padding: const EdgeInsets.only(top: AppSpacing.base),
                    sliver: SliverToBoxAdapter(
                      child: const _BottomCtaBanner().animate().fadeIn(
                        delay: 600.ms,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.paddingOf(context).bottom + 100,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAddToCart(
    BuildContext context,
    HomeController controller,
    Product product,
  ) async {
    await controller.addProductToCart(product);
    if (context.mounted) {
      AppSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.productAddedToCart,
      );
    }
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 100),
          AppShimmer.heroBanner(),
          const SizedBox(height: AppSpacing.sectionGap),
          AppShimmer.categoryStrip(),
          const SizedBox(height: AppSpacing.sectionGap),
          AppShimmer.productGrid(count: 4),
        ],
      ),
    );
  }
}

// ─── Component: Greeting Header ───
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.compact, this.name});
  final bool compact;
  final String? name;

  String _getGreeting(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n?.homeGreetingMorning ?? 'Good Morning';
    if (hour < 17) return l10n?.homeGreetingAfternoon ?? 'Good Afternoon';
    return l10n?.homeGreetingEvening ?? 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final l10n = AppLocalizations.of(context)!;
    final displayName = name ?? l10n.homeGuestName;
    final greeting = _getGreeting(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        topPadding + AppSpacing.base,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.small),
            onTap: () {
              HapticFeedback.selectionClick();
              Get.toNamed('/profile');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.homeHi(displayName),
                      style:
                          (compact
                                  ? Theme.of(context).textTheme.titleLarge
                                  : Theme.of(context).textTheme.headlineMedium)
                              ?.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w800,
                                fontSize: compact ? 22 : 26,
                              ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '🐾',
                      style: TextStyle(
                        fontSize: compact ? 18 : 22,
                        color: AppColors.brandOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$greeting! ${l10n.homeGreetingSubtitle}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: compact ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.selectionClick();
                Get.toNamed('/notifications');
              },
              child: Container(
                width: compact ? 44 : 50,
                height: compact ? 44 : 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.elevation1,
                  border: Border.all(
                    color: AppColors.surfaceRaised,
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textMain,
                  size: 24,
                ),
              ),
            ),
          ).animate().fadeIn().scale(),
        ],
      ),
    );
  }
}

// ─── Component: Hero Section ───

class _HeroSection extends StatefulWidget {
  const _HeroSection();

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _orbController;

  Offset _tiltOffset = Offset.zero;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(period: const Duration(milliseconds: 3500));

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    )..repeat(reverse: true);

    _orbController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails d, BoxConstraints constraints) {
    setState(() {
      _tiltOffset = Offset(
        ((d.localPosition.dx / constraints.maxWidth) - 0.5).clamp(-0.5, 0.5),
        ((d.localPosition.dy / constraints.maxHeight) - 0.5).clamp(-0.5, 0.5),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        boxShadow: [
          // Deep blue glow below
          BoxShadow(
            color: AppColors.brand.withValues(alpha: 0.30),
            blurRadius: 48,
            offset: const Offset(0, 22),
            spreadRadius: -6,
          ),
          // Navy ambient shadow
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          // Top-left white specular
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.55),
            blurRadius: 16,
            offset: const Offset(-6, -6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanUpdate: (d) => _onPanUpdate(d, constraints),
            onPanEnd: (_) => setState(() => _tiltOffset = Offset.zero),
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-_tiltOffset.dy * 0.07)
                ..rotateY(_tiltOffset.dx * 0.07)
                ..scaleByDouble(
                  _isPressed ? 0.984 : 1.0,
                  _isPressed ? 0.984 : 1.0,
                  1.0,
                  1.0,
                ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xxLarge),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── 1. Dark navy base ──────────────────────────────
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.navyGradient,
                      ),
                    ),

                    // ── 2. Animated blue radial bloom ──────────────────
                    AnimatedBuilder(
                      animation: _gradientController,
                      builder: (_, _) {
                        final t = _gradientController.value;
                        return Stack(
                          children: [
                            // Primary bloom — top right
                            Positioned(
                              top: -60 + t * 30,
                              right: -30 + t * 20,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.brand.withValues(alpha: 0.28),
                                      AppColors.brand.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Secondary bloom — bottom left
                            Positioned(
                              bottom: -50 + (1 - t) * 25,
                              left: -20 + t * 15,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.brandLight.withValues(
                                        alpha: 0.18,
                                      ),
                                      AppColors.brandLight.withValues(
                                        alpha: 0.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Subtle teal-ish accent bloom — center
                            Positioned(
                              top: 30 + t * 20,
                              left: constraints.maxWidth * 0.35,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.info.withValues(alpha: 0.12),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // ── 3. Dot-grid texture overlay ────────────────────
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _DotGridPainter(
                            dotColor: AppColors.brandLight.withValues(
                              alpha: 0.06,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── 4. Diagonal shimmer sweep ──────────────────────
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (_, _) {
                            final t = _shimmerController.value;
                            return ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment(-2.0 + t * 5.0, -1.0),
                                  end: Alignment(-1.2 + t * 5.0, 1.0),
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.07),
                                    Colors.white.withValues(alpha: 0.13),
                                    Colors.white.withValues(alpha: 0.07),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.srcOver,
                              child: Container(
                                color: Colors.white.withValues(alpha: 0.0),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // ── 5. Thin glass edge border ──────────────────────
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppRadius.xxLarge,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.10),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── 6. Top gloss line ──────────────────────────────
                    Positioned(
                      top: 0,
                      left: 24,
                      right: 24,
                      child: Container(
                        height: 1.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.35),
                              Colors.white.withValues(alpha: 0.55),
                              Colors.white.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),

                    // ── 7. Main content ────────────────────────────────
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.xs,
                        AppSpacing.xl,
                      ),
                      child: Row(
                        children: [
                          // ── Start column (text) ──
                          Expanded(
                            flex: 58,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Live badge
                                _PremiumBadge(
                                      shimmerController: _shimmerController,
                                    )
                                    .animate()
                                    .fadeIn(delay: 80.ms, duration: 350.ms)
                                    .slideX(
                                      begin: -0.25,
                                      curve: Curves.easeOutCubic,
                                    ),

                                const SizedBox(height: 10),

                                // Headline
                                Builder(
                                      builder: (ctx) {
                                        final l10n = AppLocalizations.of(ctx);
                                        final isAr =
                                            Localizations.localeOf(
                                              ctx,
                                            ).languageCode ==
                                            'ar';
                                        final headline =
                                            l10n?.homeHeroHeadline ??
                                            'Everything\nyour pet needs.';
                                        // Split off the last word for accent color
                                        final lastDot = headline.lastIndexOf(
                                          '.',
                                        );
                                        final mainText = lastDot > 0
                                            ? headline.substring(0, lastDot)
                                            : headline;
                                        final accentText = lastDot > 0
                                            ? headline.substring(lastDot)
                                            : '';
                                        return RichText(
                                          textAlign: isAr
                                              ? TextAlign.right
                                              : TextAlign.left,
                                          text: TextSpan(
                                            style: Theme.of(ctx)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  height: 1.08,
                                                  letterSpacing: isAr
                                                      ? 0
                                                      : -0.9,
                                                  fontSize: 20,
                                                ),
                                            children: [
                                              TextSpan(
                                                text: mainText,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.95),
                                                ),
                                              ),
                                              TextSpan(
                                                text: accentText,
                                                style: TextStyle(
                                                  color: AppColors.brandLight,
                                                  shadows: [
                                                    Shadow(
                                                      color: AppColors.brand
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      blurRadius: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                    .animate()
                                    .fadeIn(delay: 180.ms, duration: 400.ms)
                                    .slideY(
                                      begin: 0.18,
                                      curve: Curves.easeOutCubic,
                                    ),

                                const SizedBox(height: 6),

                                // Sub-text
                                Builder(
                                  builder: (ctx) => Text(
                                    AppLocalizations.of(
                                          ctx,
                                        )?.homeHeroSubtitle ??
                                        'In one place.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.darkTextSecondary,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ).animate().fadeIn(
                                  delay: 260.ms,
                                  duration: 350.ms,
                                ),

                                const SizedBox(height: AppSpacing.md),

                                // CTA
                                _GlowCTA(
                                      pulseController: _pulseController,
                                      onPressed: () => _openShellTab(
                                        1,
                                        AppRoutes.categories,
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 360.ms)
                                    .scale(
                                      begin: const Offset(0.82, 0.82),
                                      delay: 360.ms,
                                      duration: 600.ms,
                                      curve: Curves.elasticOut,
                                    ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 4),

                          // ── Right column: floating pet ──
                          Expanded(
                            flex: 42,
                            child: _FloatingPet(
                              floatController: _floatController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge({required this.shimmerController});
  final AnimationController shimmerController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.small),
        gradient: LinearGradient(
          colors: [
            AppColors.brand.withValues(alpha: 0.22),
            AppColors.brandLight.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(
          color: AppColors.brandLight.withValues(alpha: 0.30),
          width: 1.0,
        ),
      ),
      child: AnimatedBuilder(
        animation: shimmerController,
        builder: (_, child) {
          return ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              colors: [
                AppColors.brandLight,
                Colors.white,
                AppColors.brandLight,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.5 + shimmerController.value * 4.0, 0),
              end: Alignment(-0.5 + shimmerController.value * 4.0, 0),
            ).createShader(rect),
            blendMode: BlendMode.srcIn,
            child: child!,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandLight,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brand.withValues(alpha: 0.8),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Builder(
              builder: (ctx) => Text(
                AppLocalizations.of(ctx)?.homeNewCollection ?? 'New Collection',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: Colors.white, // overridden by ShaderMask
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCTA extends StatelessWidget {
  const _GlowCTA({required this.pulseController, required this.onPressed});

  final AnimationController pulseController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (_, child) {
        final glow = 0.35 + pulseController.value * 0.30;
        final spread = -1.0 + pulseController.value * 3.5;
        return Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            boxShadow: [
              BoxShadow(
                color: AppColors.brand.withValues(alpha: glow),
                blurRadius: 20,
                spreadRadius: spread,
              ),
              BoxShadow(
                color: AppColors.brandLight.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Builder(
        builder: (ctx) => AppButton(
          label: AppLocalizations.of(ctx)?.homeShopNow ?? 'Shop Now',
          isSmall: true,
          fullWidth: false,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _FloatingPet extends StatelessWidget {
  const _FloatingPet({required this.floatController});
  final AnimationController floatController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatController,
      builder: (_, child) {
        final dy = -7.0 + floatController.value * 14.0;
        final shadowScale = 0.7 + floatController.value * 0.3;
        final shadowOpacity = 0.15 + (1 - floatController.value) * 0.12;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Ground shadow blob
            Positioned(
              bottom: 0,
              child: Transform.scale(
                scaleX: shadowScale,
                scaleY: 0.35,
                child: Container(
                  width: 80,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brand.withValues(alpha: shadowOpacity),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand.withValues(
                          alpha: shadowOpacity * 0.6,
                        ),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Pet image
            Transform.translate(offset: Offset(0, dy), child: child!),
          ],
        );
      },
      child: Image.asset('assets/cat_vector.png', fit: BoxFit.contain),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dot-grid background painter
// ─────────────────────────────────────────────────────────────────────────────

class _DotGridPainter extends CustomPainter {
  _DotGridPainter({required this.dotColor});
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const spacing = 18.0;
    const radius = 1.2;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.dotColor != dotColor;
}

// ─── Component: Feature Highlights Strip ───
class _FeatureStrip extends StatelessWidget {
  const _FeatureStrip();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = [
      {
        'id': 'selection',
        'icon': '🐾',
        'title': l10n?.homeFeatureWideSelection ?? 'Wide Selection',
        'subtitle': l10n?.homeFeatureWideSelectionSub ?? 'Dogs, cats & more',
      },
      {
        'id': 'quality',
        'icon': '🛍️',
        'title': l10n?.homeFeatureQualityProducts ?? 'Quality Products',
        'subtitle': l10n?.homeFeatureQualityProductsSub ?? 'Food & accessories',
      },
      {
        'id': 'delivery',
        'icon': '🚚',
        'title': l10n?.homeFeatureFastDelivery ?? 'Fast Delivery',
        'subtitle': l10n?.homeFeatureFastDeliverySub ?? 'Right to your door',
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
        itemCount: features.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.base),
        itemBuilder: (context, index) {
          final f = features[index];
          return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.xLarge),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Get.toNamed('/feature/${f['id']}');
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.xLarge),
                      boxShadow: AppShadows.elevation1,
                      border: Border.all(color: AppColors.surfaceRaised),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceRaised,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            f['icon']!,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: AppColors.textMain,
                                ),
                              ),
                              Text(
                                f['subtitle']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: AppColors.textSub,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: (200 + (100 * index)).ms)
              .slideX(begin: 0.1);
        },
      ),
    );
  }
}

// ─── Component: Interactive Category Grid ───
class _InteractiveCategoryGrid extends StatelessWidget {
  const _InteractiveCategoryGrid({required this.categories});
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final displayCategories = categories.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.homeExploreCategories ??
                    'Explore Top Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () => _openShellTab(1, AppRoutes.categories),
                child: Text(
                  AppLocalizations.of(context)?.homeSeeAll ?? 'See All',
                  style: const TextStyle(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            itemCount: displayCategories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final cat = displayCategories[index];
              return _CategoryCard(category: cat)
                  .animate()
                  .fadeIn(delay: (index * 80).ms)
                  .scale(begin: const Offset(0.9, 0.9));
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({required this.category});
  final Category category;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xLarge),
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) {
          setState(() => _isHovered = false);
          HapticFeedback.lightImpact();
          Get.toNamed('/category/${widget.category.slug}');
        },
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.emphasis,
          width: 90,
          transform: Matrix4.diagonal3Values(
            _isHovered ? 0.96 : 1.0,
            _isHovered ? 0.96 : 1.0,
            1.0,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.surfaceSubtle
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppRadius.xLarge),
            border: Border.all(
              color: _isHovered ? AppColors.brandOrange : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: AppShadows.elevation1,
                ),
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: ClipOval(
                  child: CachedImage(
                    url: widget.category.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  PetUiAdapter.categoryLabel(widget.category, context),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.textMain,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Component: Popular Pets Carousel ───
class _PopularPetsCarousel extends StatelessWidget {
  const _PopularPetsCarousel({
    required this.title,
    required this.products,
    required this.onAddToCart,
  });
  final String title;
  final List<Product> products;
  final Function(Product) onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            AppSpacing.base,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () => _openShellTab(2, AppRoutes.search),
                child: Text(
                  AppLocalizations.of(context)?.homeSeeAll ?? 'See All',
                  style: const TextStyle(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.xs,
            ),
            itemCount: products.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                width: 170, // Fixed width for horizontal scrolling
                child: _CarouselProductCard(
                  product: product,
                  onTap: () => Get.toNamed('/product/${product.id}'),
                  onAddToCart: () => onAddToCart(product),
                  index: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CarouselProductCard extends StatefulWidget {
  const _CarouselProductCard({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    required this.index,
  });
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final int index;

  @override
  State<_CarouselProductCard> createState() => _CarouselProductCardState();
}

class _CarouselProductCardState extends State<_CarouselProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) {
          setState(() => _isHovered = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isHovered = false),
        child:
            AnimatedContainer(
                  duration: AppMotion.fast,
                  transform: Matrix4.diagonal3Values(
                    _isHovered ? 0.98 : 1.0,
                    _isHovered ? 0.98 : 1.0,
                    1.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xxLarge),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: _isHovered
                        ? AppShadows.elevation3
                        : AppShadows.elevation1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppRadius.xxLarge),
                              ),
                              child: AnimatedScale(
                                scale: _isHovered ? 1.05 : 1.0,
                                duration: AppMotion.fast,
                                child: CachedImage(
                                  url: widget.product.imageUrl,
                                  fallbackAsset: 'assets/category_img01.png',
                                ),
                              ),
                            ),
                            if (widget.index < 3)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.pill,
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(
                                          context,
                                        )?.homeTopRated ??
                                        'Top Rated',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    PetUiAdapter.productName(
                                      widget.product,
                                      context,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: AppColors.textMain,
                                    ),
                                  ),
                                  Text(
                                    PetUiAdapter.subtitle(widget.product),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textSub,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      PetUiAdapter.priceLabel(widget.product),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.brandOrange,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    message:
                                        AppLocalizations.of(
                                          context,
                                        )?.addToCart ??
                                        'Add to cart',
                                    child: Material(
                                      color: AppColors.surfaceRaised,
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: widget.onAddToCart,
                                        child: const Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.add_shopping_cart_rounded,
                                            size: 18,
                                            color: AppColors.brandOrange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: (400 + (100 * widget.index)).ms)
                .slideX(begin: 0.1),
      ),
    );
  }
}

// ─── Component: Trust Signals ───
class _TrustSignals extends StatelessWidget {
  const _TrustSignals();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.successSoft.withValues(alpha: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TrustItem(
            icon: '💖',
            label: l10n?.homeTrustHappyPets ?? 'Over 10k\nHappy Pets',
          ),
          _TrustItem(
            icon: '🛡️',
            label: l10n?.homeTrustSafeGuaranteed ?? '100% Safe\nGuaranteed',
          ),
          _TrustItem(
            icon: '🎧',
            label: l10n?.homeTrustSupport247 ?? '24/7 Support\nAvailable',
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: AppColors.textMain,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

// ─── Component: Bottom CTA Banner ───
class _BottomCtaBanner extends StatelessWidget {
  const _BottomCtaBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.brandDeep,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        image: const DecorationImage(
          image: AssetImage('assets/products_shape01.png'),
          alignment: Alignment.centerRight,
          opacity: 0.2,
        ),
        boxShadow: AppShadows.elevation2,
      ),
      child: Column(
        children: [
          Text(
            l10n?.homeCtaBannerTitle ?? 'Ready to spoil your pet? 🐶',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n?.homeStartShopping ?? 'Start Shopping',
            onPressed: () => _openShellTab(1, AppRoutes.categories),
          ),
        ],
      ),
    );
  }
}
