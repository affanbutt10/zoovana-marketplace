import 'package:flutter/material.dart';

import '../../app/core/theme/app_colors.dart';
import '../../app/core/theme/app_spacing.dart';

/// Scroll-aware compact page header.
///
/// The header is fully transparent at the top of the scroll view and fades in
/// with a subtle divider once the attached [scrollController] passes 20px.
class FloatingPageHeader extends StatefulWidget {
  const FloatingPageHeader({
    super.key,
    required this.title,
    required this.scrollController,
    this.subtitle,
    this.leading,
    this.actions,
  });

  final String title;
  final ScrollController scrollController;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  State<FloatingPageHeader> createState() => _FloatingPageHeaderState();
}

class _FloatingPageHeaderState extends State<FloatingPageHeader> {
  bool _isElevated = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
    _handleScroll();
  }

  @override
  void didUpdateWidget(FloatingPageHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_handleScroll);
      widget.scrollController.addListener(_handleScroll);
      _handleScroll();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final isElevated = widget.scrollController.hasClients &&
        widget.scrollController.offset > AppSpacing.lg;
    if (isElevated != _isElevated && mounted) {
      setState(() => _isElevated = isElevated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;

    return IgnorePointer(
      ignoring: !_isElevated,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        color: surface.withValues(alpha: _isElevated ? 0.96 : 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.borderSubtle.withValues(
                  alpha: _isElevated ? 0.7 : 0,
                ),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.base,
              ),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (widget.subtitle != null &&
                            widget.subtitle!.isNotEmpty)
                          Text(
                            widget.subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.actions != null) ...widget.actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
