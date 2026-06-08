import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';

enum _SkeletonVariant { card, listRow, textBlock }

/// Shimmer skeleton loader with three layout variants.
///
/// Uses a 1500ms [AnimationController] with a [ColorTween] between
/// [AppColors.skeletonBase] and [AppColors.skeletonHighlight].
class SkeletonLoader extends StatefulWidget {
  final _SkeletonVariant _variant;
  final double? width;
  final double? height;
  final int lines;

  /// Rounded-rectangle card skeleton. Aspect ratio ~0.75.
  const SkeletonLoader.card({super.key, this.width, this.height})
      : _variant = _SkeletonVariant.card,
        lines = 0;

  /// Full-width row skeleton, 72dp tall.
  const SkeletonLoader.listRow({super.key})
      : _variant = _SkeletonVariant.listRow,
        width = null,
        height = null,
        lines = 0;

  /// Stacked text-line skeletons of varying widths.
  const SkeletonLoader.textBlock({super.key, this.lines = 3})
      : _variant = _SkeletonVariant.textBlock,
        width = null,
        height = null;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: AppColors.skeletonBase,
      end: AppColors.skeletonHighlight,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, _) {
        final color = _colorAnimation.value ?? AppColors.skeletonBase;
        switch (widget._variant) {
          case _SkeletonVariant.card:
            return _buildCard(color);
          case _SkeletonVariant.listRow:
            return _buildListRow(color);
          case _SkeletonVariant.textBlock:
            return _buildTextBlock(color);
        }
      },
    );
  }

  Widget _buildCard(Color color) {
    final w = widget.width ?? 160.0;
    final h = widget.height ?? (w / 0.75);
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    );
  }

  Widget _buildListRow(Color color) {
    return Container(
      width: double.infinity,
      height: 72.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
    );
  }

  Widget _buildTextBlock(Color color) {
    // Varying widths: 100%, 80%, 60% cycling pattern
    const widthFactors = [1.0, 0.8, 0.6];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.lines, (i) {
        final factor = widthFactors[i % widthFactors.length];
        return Padding(
          padding: EdgeInsets.only(bottom: i < widget.lines - 1 ? 8.0 : 0),
          child: FractionallySizedBox(
            widthFactor: factor,
            child: Container(
              height: 14.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
            ),
          ),
        );
      }),
    );
  }
}
