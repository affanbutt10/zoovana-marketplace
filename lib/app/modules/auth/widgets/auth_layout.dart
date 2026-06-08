import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:ui';

import '../../../../l10n/app_localizations.dart';
import '../../../core/controllers/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_spacing.dart';

/// Clean, brand-aligned auth layout for all authentication screens.
class AuthLayout extends StatefulWidget {
  const AuthLayout({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.showBackButton = true,
    this.onBack,
    this.preview,
  });

  final Widget child;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? preview;

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: Stack(
        children: [
          // ─── Ambient Background ───
          _buildBackground(),

          // ─── Floating Pet Icons ───
          _buildFloatingIcons(),

          // ─── Main Content ───
          SafeArea(
            minimum: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                if (isDesktop)
                  Expanded(
                    flex: 5,
                    child: widget.preview ?? _buildDefaultPreview(),
                  ),
                Expanded(
                  flex: isDesktop ? 4 : 1,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        isDesktop ? AppSpacing.xl * 2 : AppSpacing.lg,
                        isDesktop ? AppSpacing.xl * 2 : AppSpacing.lg,
                        isDesktop ? AppSpacing.xl * 2 : AppSpacing.lg,
                        (isDesktop ? AppSpacing.xl * 2 : AppSpacing.lg) +
                            MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceRaised.withValues(
                                  alpha: 0.96,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: AppColors.borderSubtle,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brand.withValues(
                                      alpha: 0.08,
                                    ),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: _AuthLanguageToggle(),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  _buildHeader(),
                                  const SizedBox(height: AppSpacing.lg),
                                  widget.child,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        // Top-right brand blob
        Positioned(
          top: -120,
          right: -120,
          child: Container(
            width: 480,
            height: 480,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.brand.withValues(alpha: 0.18),
                  AppColors.brand.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom-left accent blob
        Positioned(
          bottom: -160,
          left: -120,
          child: Container(
            width: 420,
            height: 420,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Subtle paw print pattern
        CustomPaint(
          size: Size.infinite,
          painter: PawPrintPainter(
            color: AppColors.brand.withValues(alpha: 0.04),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingIcons() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, _) {
        return Stack(
          children: [
            _buildFloatingIcon(
              Icons.pets_rounded,
              top: 80,
              right: 40,
              delay: 0,
              size: 22,
            ),
            _buildFloatingIcon(
              Icons.favorite_rounded,
              top: 260,
              left: 24,
              delay: 1.2,
              size: 18,
            ),
            _buildFloatingIcon(
              Icons.local_offer_rounded,
              bottom: 180,
              right: 60,
              delay: 2.0,
              size: 20,
            ),
            _buildFloatingIcon(
              Icons.shopping_bag_rounded,
              bottom: 80,
              left: 44,
              delay: 0.8,
              size: 20,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingIcon(
    IconData icon, {
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double delay,
    required double size,
  }) {
    final yOffset =
        math.sin((_floatController.value + delay) * 2 * math.pi) * 10;
    return Positioned(
      top: top != null ? top + yOffset : null,
      bottom: bottom != null ? bottom + yOffset : null,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceTint,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.brand.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, size: size, color: AppColors.brand),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        _buildBouncingIcon(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn().slideY(begin: 0.2),
        const SizedBox(height: AppSpacing.xs),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
      ],
    );
  }

  Widget _buildBouncingIcon() {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_bounceController.value * math.pi) * 4),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brand.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
        );
      },
    ).animate().scale(begin: const Offset(0, 0), curve: AppMotion.spring);
  }

  Widget _buildDefaultPreview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOnlineBadge(),
          const SizedBox(height: AppSpacing.xl * 2),
          Text(
                'Everything Your\nPet Dreams Of',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .slideY(begin: 0.2),
          const SizedBox(height: AppSpacing.lg),
          Text(
                'Join 50,000+ pet parents saving on premium food, toys, and vet-approved wellness products.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 400))
              .slideY(begin: 0.2),
          const SizedBox(height: AppSpacing.xl),
          _buildCategoryPills(),
          const SizedBox(height: AppSpacing.xl * 2),
          _buildTestimonialCard(),
        ],
      ),
    );
  }

  Widget _buildOnlineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.brand.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeOut(duration: const Duration(seconds: 1)),
          const SizedBox(width: 8),
          Text(
            '2,847 shoppers online now',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.brandDeep,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.2);
  }

  Widget _buildCategoryPills() {
    final categories = ['🐕 Dogs', '🐈 Cats', '🦜 Birds', '🐰 Small Pets'];
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: categories.map((cat) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceTint,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.brand.withValues(alpha: 0.2)),
          ),
          child: Text(
            cat,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: const Duration(milliseconds: 500));
  }

  Widget _buildTestimonialCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (_) => const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '4.9/5 from 12k+ reviews',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '"Saved \$200 on my first order and the quality is better than my local pet store!"',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '- Sarah & Max 🐕',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 800)).slideY(begin: 0.2);
  }
}

class _AuthLanguageToggle extends StatelessWidget {
  const _AuthLanguageToggle();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GetBuilder<LocaleController>(
      builder: (controller) {
        final isArabic = controller.locale.languageCode == 'ar';
        final nextLocale = isArabic ? const Locale('en') : const Locale('ar');
        final currentLabel = isArabic
            ? l10n.profileLanguageArabicCode
            : l10n.profileLanguageEnglishCode;
        final nextLabel = isArabic
            ? l10n.profileLanguageEnglishCode
            : l10n.profileLanguageArabicCode;

        return Tooltip(
          message: l10n.authChangeLanguage,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => controller.setLocale(nextLocale),
              child: AnimatedContainer(
                duration: AppMotion.fast,
                curve: AppMotion.emphasis,
                padding: const EdgeInsetsDirectional.fromSTEB(10, 7, 8, 7),
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.brand.withValues(alpha: 0.18),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language_rounded,
                      size: 16,
                      color: AppColors.brand,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AnimatedSwitcher(
                      duration: AppMotion.fast,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        '$currentLabel / $nextLabel',
                        key: ValueKey(currentLabel),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.brandDeep,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.swap_horiz_rounded,
                      size: 14,
                      color: AppColors.brand,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: AppMotion.medium).slideY(begin: -0.12);
      },
    );
  }
}

class PawPrintPainter extends CustomPainter {
  final Color color;
  PawPrintPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const spacing = 110.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        _drawPaw(canvas, x + 20, y + 20, paint, 11);
      }
    }
  }

  void _drawPaw(Canvas canvas, double x, double y, Paint paint, double size) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: size, height: size * 0.8),
      paint,
    );
    final toeOffsets = [
      Offset(x - size * 0.5, y - size * 0.6),
      Offset(x - size * 0.2, y - size * 0.8),
      Offset(x + size * 0.2, y - size * 0.8),
      Offset(x + size * 0.5, y - size * 0.6),
    ];
    for (final toe in toeOffsets) {
      canvas.drawCircle(toe, size * 0.25, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
