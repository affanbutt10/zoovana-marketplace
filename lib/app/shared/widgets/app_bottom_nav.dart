import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// CurvedBottomNavBar – buttery smooth animated bottom navigation
//
// IMPORTANT – wrap in a Theme widget to prevent your app's ThemeData
// from overriding the peach colour:
//
//   bottomNavigationBar: Theme(
//     data: ThemeData.light(),   // isolate from app theme
//     child: CurvedBottomNavBar(
//       currentIndex: _currentIndex,
//       onTap: (i) => setState(() => _currentIndex = i),
//     ),
//   ),
//
// OR just use it directly – the widget ignores theme colours internally.
// ---------------------------------------------------------------------------

class CurvedBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const CurvedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = const [],
  });

  @override
  State<CurvedBottomNavBar> createState() => _CurvedBottomNavBarState();
}

class _CurvedBottomNavBarState extends State<CurvedBottomNavBar>
    with TickerProviderStateMixin {
  // ── Palette from AppColors ────────────────────────────────────────────────
  static const Color kPeach = Color(0xFFE4EEFF); // bar bg — slightly deeper
  static const Color kBubble = Colors.white; // inactive bubble — white
  static const Color kInactive = AppColors.textSecondary; // inactive icon
  static const Color kWhite = AppColors.surfaceRaised; // active icon color
  static const Color kBg = Color(0xFFF1F6FF); // page bg behind bar
  static const Color kActive = AppColors.brand; // active bubble only

  static const double kBarHeight = 72.0;
  static const double kBubbleSize = 52.0;
  static const double kRiseAmount = 26.0; // px the active bubble rises

  // ── Nav items ──────────────────────────────────────────────────────────────
  static const _items = [
    _NavItem(outline: Icons.home_outlined, filled: Icons.home_rounded),
    _NavItem(outline: Icons.category_outlined, filled: Icons.category),
    _NavItem(outline: Icons.search_rounded, filled: Icons.search_rounded),
    _NavItem(
      outline: Icons.shopping_cart_outlined,
      filled: Icons.shopping_cart_rounded,
    ),
    _NavItem(
      outline: Icons.person_outline_rounded,
      filled: Icons.person_rounded,
    ),
  ];

  // ── Wave X: tracks the horizontal centre of the animated dip ──────────────
  // Stored as a simple double so we can tween it manually each frame.
  double _waveFromX = 0;
  double _waveToX = 0;
  bool _waveReady = false;

  late final AnimationController _waveCtrl;
  late final CurvedAnimation _waveCurve;

  // ── Per-item animations ────────────────────────────────────────────────────
  late final List<AnimationController> _itemCtrl;

  // Rise:  0 → 1  easeOutBack  (overshoot for springy feel)
  late final List<Animation<double>> _rise;

  // Scale: squeeze → overshoot → settle  (physical pop)
  late final List<Animation<double>> _scale;

  // Icon crossfade: 0 = outline, 1 = filled
  late final List<Animation<double>> _iconT;

  @override
  void initState() {
    super.initState();

    // Wave slide controller
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _waveCurve = CurvedAnimation(
      parent: _waveCtrl,
      curve: Curves.easeInOutCubic,
    );

    // Per-item controllers
    _itemCtrl = List.generate(
      _items.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 480),
      ),
    );

    _rise = _itemCtrl
        .map(
          (c) => Tween<double>(
            begin: 0,
            end: 1,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutBack)),
        )
        .toList();

    _scale = _itemCtrl
        .map(
          (c) => TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.80), weight: 18),
            TweenSequenceItem(tween: Tween(begin: 0.80, end: 1.20), weight: 44),
            TweenSequenceItem(tween: Tween(begin: 1.20, end: 1.0), weight: 38),
          ]).animate(CurvedAnimation(parent: c, curve: Curves.linear)),
        )
        .toList();

    _iconT = _itemCtrl
        .map(
          (c) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: c,
              curve: const Interval(0.15, 0.65, curve: Curves.easeInOut),
            ),
          ),
        )
        .toList();

    // Activate initial item without animation
    _itemCtrl[widget.currentIndex].value = 1.0;

    // Wave position initialised after first layout so we know the widget width
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final w = MediaQuery.of(context).size.width;
      final x = _centerX(widget.currentIndex, w);
      setState(() {
        _waveFromX = x;
        _waveToX = x;
        _waveReady = true;
      });
    });
  }

  @override
  void didUpdateWidget(CurvedBottomNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex == widget.currentIndex) return;

    // Use cached width — safe to call during build phase
    final w = _cachedWidth > 0
        ? _cachedWidth
        : MediaQuery.of(context).size.width;

    _waveFromX = _centerX(old.currentIndex, w);
    _waveToX = _centerX(widget.currentIndex, w);
    _waveCtrl.forward(from: 0);

    _itemCtrl[old.currentIndex].reverse();
    _itemCtrl[widget.currentIndex].forward(from: 0);
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    for (final c in _itemCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  // Width cached from LayoutBuilder — safe to use in didUpdateWidget
  double _cachedWidth = 0;

  bool get _isRtl => Directionality.of(context) == TextDirection.rtl;

  int _effectiveIndex(int index) =>
      _isRtl ? (_items.length - 1 - index) : index;

  double _centerX(int index, double totalWidth) {
    final effectiveIndex = _effectiveIndex(index);
    return (totalWidth / _items.length) * effectiveIndex +
        (totalWidth / _items.length) / 2;
  }

  double get _currentWaveX =>
      _waveReady ? _waveFromX + (_waveToX - _waveFromX) * _waveCurve.value : 0;

  void _onTap(int i) {
    if (i == widget.currentIndex) return;
    HapticFeedback.lightImpact();
    widget.onTap(i);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final totalH = kBarHeight + kRiseAmount + bottomPad;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Cache width here — safe to use in didUpdateWidget
        final w = constraints.maxWidth;
        if (_cachedWidth != w) {
          _cachedWidth = w;
          final x = _centerX(widget.currentIndex, w);
          if (!_waveReady) {
            _waveFromX = x;
            _waveToX = x;
            _waveReady = true;
          }
        }

        return SizedBox(
          height: totalH,
          child: AnimatedBuilder(
            animation: Listenable.merge([_waveCtrl, ..._itemCtrl]),
            builder: (ctx, _) {
              final waveX = _currentWaveX;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── 1. Peach background + wave dip ──────────────────────────
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: kBarHeight + bottomPad,
                    child: CustomPaint(
                      painter: _WavePainter(
                        barColor: kPeach,
                        pageColor: kBg,
                        centerX: waveX,
                        dipDepth: kRiseAmount + 8,
                        dipHalfW: 66,
                      ),
                    ),
                  ),

                  // ── 2. Nav bubbles ───────────────────────────────────────────
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomPad,
                    height: kBarHeight,
                    child: Row(
                      textDirection: Directionality.of(context),
                      children: List.generate(_items.length, (i) {
                        final active = widget.currentIndex == i;
                        final rise = _rise[i].value * kRiseAmount;
                        final scale = _scale[i].value;
                        final t = _iconT[i].value;

                        return Expanded(
                          child: Semantics(
                            button: true,
                            selected: active,
                            child: InkResponse(
                              containedInkWell: true,
                              onTap: () => _onTap(i),
                              child: Transform.translate(
                                offset: Offset(0, -rise),
                                child: Transform.scale(
                                  scale: scale,
                                  child: Center(
                                    child: _Bubble(
                                      outline: _items[i].outline,
                                      filled: _items[i].filled,
                                      t: t,
                                      active: active,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }, // LayoutBuilder
    );
  }
}

class _Bubble extends StatelessWidget {
  final IconData outline, filled;
  final double t; // 0 → 1 animation progress
  final bool active;

  const _Bubble({
    required this.outline,
    required this.filled,
    required this.t,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    const active =
        _CurvedBottomNavBarState.kActive; // brand color — active bubble only
    const bubble = _CurvedBottomNavBarState.kBubble;
    const inactive = _CurvedBottomNavBarState.kInactive;
    const white = _CurvedBottomNavBarState.kWhite;

    final bgColor = Color.lerp(bubble, active, t)!;
    final iconColor = Color.lerp(inactive, white, t)!;
    final size = _CurvedBottomNavBarState.kBubbleSize + t * 3;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          if (this.active)
            BoxShadow(
              color: active.withValues(alpha: 0.38 * t),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outline fades OUT
          Opacity(
            opacity: (1 - t).clamp(0.0, 1.0),
            child: Icon(outline, size: 24, color: iconColor),
          ),
          // Filled fades IN + scales up from 55%
          Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: 0.55 + t * 0.45,
              child: Icon(filled, size: 24, color: iconColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Wave CustomPainter ────────────────────────────────────────────────────────
// Draws the peach bar with a smooth upward dip for the active icon.
// The dip slides left/right as centerX changes each frame.

class _WavePainter extends CustomPainter {
  final Color barColor;
  final Color pageColor; // colour shown inside the dip (matches page bg)
  final double centerX;
  final double dipDepth; // how deep the notch goes (px)
  final double dipHalfW; // half-width of the notch

  const _WavePainter({
    required this.barColor,
    required this.pageColor,
    required this.centerX,
    required this.dipDepth,
    required this.dipHalfW,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = centerX;
    final d = dipDepth;
    final hw = dipHalfW;

    // ── Peach bar with a smooth upward notch ──────────────────────────────
    final path = Path()
      ..moveTo(0, d) // start at notch height
      ..lineTo(cx - hw, d)
      // rise into notch – left shoulder
      ..cubicTo(cx - hw * 0.55, d, cx - hw * 0.28, 0, cx, 0)
      // descend out of notch – right shoulder
      ..cubicTo(cx + hw * 0.28, 0, cx + hw * 0.55, d, cx + hw, d)
      ..lineTo(size.width, d)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, Paint()..color = barColor);
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.centerX != centerX ||
      old.dipDepth != dipDepth ||
      old.barColor != barColor;
}

// ── Data class ────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData outline;
  final IconData filled;
  const _NavItem({required this.outline, required this.filled});
}
