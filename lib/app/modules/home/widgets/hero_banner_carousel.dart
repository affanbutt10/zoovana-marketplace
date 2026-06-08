import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Auto-advancing hero banner carousel.
///
/// Cycles through [_slides] every 4 seconds using [Timer.periodic].
/// Dot indicators reflect the current slide index.
/// Tapping a slide calls the optional [onTap] callback.
class HeroBannerCarousel extends StatefulWidget {
  final void Function(int index)? onTap;

  const HeroBannerCarousel({super.key, this.onTap});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel>
    with SingleTickerProviderStateMixin {
  static const _slides = [
    'assests/h3_banner_slide01.jpg',
    'assests/h3_banner_img01.jpg',
    'assests/h3_banner_img02.jpg',
  ];

  static const _autoAdvanceDuration = Duration(seconds: 4);

  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(_autoAdvanceDuration, (_) {
      if (!mounted) return;
      final next = (_currentIndex + 1) % _slides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          // ── PageView ────────────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: widget.onTap == null
                    ? null
                    : () => widget.onTap?.call(index),
                child: Image.asset(
                  _slides[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.skeletonBase,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 48),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Dot indicators ───────────────────────────────────────────────
          Positioned(
            bottom: AppSpacing.sm,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs / 2,
                  ),
                  width: isActive ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
