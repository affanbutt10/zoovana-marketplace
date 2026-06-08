import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _progressController;
  late AnimationController _rotateController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _blurOpacity;

  @override
  void initState() {
    super.initState();

    // Set system UI to match brand
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.surfaceBase,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Main orchestration controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Continuous pulse for the heart icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Floating animation for background elements
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Progress bar animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Subtle rotation for logo
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );

    // Logo animations with elastic bounce
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.5),
    ));

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    // Text animations with stagger
    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
    ));

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    ));

    // Continuous pulse animation for heart
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Floating background animation
    _floatAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      _floatController,
    );

    // Progress bar
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Blur circles fade in
    _blurOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    // Start animations
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _floatController.repeat();
    _rotateController.repeat();
    _progressController.forward();

    // Simulate loading completion
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _navigateToNext();
      }
    });
  }

  void _navigateToNext() {
    // Add your navigation logic here
    // Navigator.of(context).pushReplacement(...);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _progressController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _pulseController,
          _floatController,
          _progressController,
          _rotateController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              /// 🌈 Animated Background blur circles using brand colors
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  final offset1 = math.sin(_floatAnimation.value) * 20;
                  final offset2 = math.cos(_floatAnimation.value) * 15;

                  return Stack(
                    children: [
                      // Top-right brand accent blur
                      Positioned(
                        top: -100 + offset1,
                        right: -100 + offset2,
                        child: Opacity(
                          opacity: _blurOpacity.value * 0.6,
                          child: _blurCircle(AppColors.brandOrange.withValues(alpha: 0.3)),
                        ),
                      ),
                      // Bottom-left accent blur
                      Positioned(
                        bottom: -100 + offset2,
                        left: -100 + offset1,
                        child: Opacity(
                          opacity: _blurOpacity.value * 0.5,
                          child: _blurCircle(AppColors.peachSoft.withValues(alpha: 0.9)),
                        ),
                      ),
                      // Additional brand soft blur
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.3,
                        left: -60,
                        child: Opacity(
                          opacity: _blurOpacity.value * 0.4,
                          child: _blurCircle(AppColors.peachSoft.withValues(alpha: 0.7)),
                        ),
                      ),
                    ],
                  );
                },
              ),

              /// ✨ Floating particles using brand colors
              ..._buildParticles(),

              /// 🧠 Main Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// 🐾 Logo with your logo.png and animations
                    Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Main logo container with brand gradient
                            Transform.rotate(
                              angle: math.sin(_floatAnimation.value * 2) * 0.02,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.brandOrange.withValues(alpha: 
                                        0.2 + _pulseAnimation.value * 0.15,
                                      ),
                                      blurRadius: 25 + _pulseAnimation.value * 15,
                                      offset: const Offset(0, 12),
                                      spreadRadius: _pulseAnimation.value * 3,
                                    ),
                                    BoxShadow(
                                      color: AppColors.brandOrange.withValues(alpha: 0.1),
                                      blurRadius: 40,
                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Image.asset(
                                      'assets/logo.png',
                                      fit: BoxFit.contain,
                                      // Fallback if logo has its own colors:
                                      // Remove color and colorBlendMode above
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// ❤️ Pulsing heart icon with accent color
                            Positioned(
                              bottom: -6,
                              right: -6,
                              child: Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.borderSubtle,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.brandOrange.withValues(alpha: 0.2),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.favorite_rounded,
                                    size: 20,
                                    color: AppColors.brandOrange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    /// 🏷 Brand Name with brand color gradient
                    Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: _textOpacity.value,
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: const [
                                AppColors.brandOrange,
                                AppColors.peachDark,
                                AppColors.brandOrange,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              transform: GradientRotation(
                                _floatAnimation.value * 0.3,
                              ),
                            ).createShader(bounds);
                          },
                          child: const Text(
                            "Zoovana",
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ✨ Subtitle with navy color
                    Transform.translate(
                      offset: Offset(0, _textSlide.value * 0.8),
                      child: Opacity(
                        opacity: _textOpacity.value * 0.9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.peachSoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "PREMIUM PET LIFESTYLE",
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w700,
                              color: AppColors.peachDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 📊 Bottom Loader with brand colors
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Progress bar container
                    Container(
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.skeletonBase,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // Animated progress fill with brand gradient
                          FractionallySizedBox(
                            widthFactor: _progressAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.brandOrange,
                                    AppColors.peachDark,
                                    AppColors.brandOrange,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brandOrange.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Shimmer effect
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  widthFactor: 0.3,
                                  alignment: Alignment(
                                    -1.2 + (_floatAnimation.value % (2 * math.pi)) / (2 * math.pi) * 2.4,
                                    0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0),
                                          Colors.white.withValues(alpha: 0.5),
                                          Colors.white.withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Animated loading text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.brandOrange.withValues(alpha: 
                                (0.5 + (_pulseAnimation.value - 1.0) * 0.5).clamp(0.0, 1.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "WAKING THE PACK",
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSub.withValues(alpha: 
                              (0.6 + (_pulseAnimation.value - 1.0) * 0.4).clamp(0.0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔵 Blur circle widget
  Widget _blurCircle(Color color) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: const SizedBox(),
      ),
    );
  }

  /// ✨ Build floating particles with brand colors
  List<Widget> _buildParticles() {
    final particles = <Widget>[];
    final random = math.Random(42);
    final colors = [
      AppColors.brandOrange,
      AppColors.peachDark,
      AppColors.peachSoft,
    ];

    for (var i = 0; i < 8; i++) {
      final delay = i * 0.4;
      final x = random.nextDouble() * 400 - 200;
      final y = random.nextDouble() * 800 - 400;
      final size = random.nextDouble() * 8 + 3;
      final color = colors[i % colors.length];

      particles.add(
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            final progress = (_floatAnimation.value + delay) % (2 * math.pi);
            final opacity = (math.sin(progress) + 1) / 2 * 0.4;
            final offsetY = math.sin(progress * 2) * 25;
            final scale = 0.8 + (math.sin(progress) + 1) / 2 * 0.4;

            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + x,
              top: MediaQuery.of(context).size.height / 2 + y + offsetY,
              child: Opacity(
                opacity: opacity * _blurOpacity.value,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: size * 1.5,
                          spreadRadius: size * 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return particles;
  }
}