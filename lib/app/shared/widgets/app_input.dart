import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

/// Premium text input with focus ring animation, optional error shake,
/// and support for password visibility toggle.
class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.maxLines = 1,
    this.errorText,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? errorText;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;
  String? _currentError;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.obscureText;
    _currentError = widget.errorText;
  }

  @override
  void didUpdateWidget(AppInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      _currentError = widget.errorText;
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _currentError != null;

    Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: hasError
                  ? AppColors.danger
                  : _isFocused
                  ? AppColors.brand
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.emphasis,
          decoration: BoxDecoration(
            color: widget.enabled
                ? AppColors.surfaceRaised.withValues(alpha: 0.82)
                : AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: hasError
                  ? AppColors.danger
                  : _isFocused
                  ? AppColors.brandLight.withValues(alpha: 0.65)
                  : AppColors.borderSubtle.withValues(alpha: 0.55),
              width: _isFocused && !hasError ? 1.25 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(
                  alpha: _isFocused && !hasError ? 0.06 : 0.03,
                ),
                blurRadius: _isFocused && !hasError ? 18 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: (val) {
              if (hasError) {
                setState(() => _currentError = null);
              }
              widget.onChanged?.call(val);
            },
            validator: widget.validator,
            maxLines: widget.maxLines,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: widget.enabled
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              isDense: true,
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: hasError
                            ? AppColors.danger
                            : _isFocused
                            ? AppColors.brand
                            : AppColors.textTertiary,
                        size: 20,
                      ),
                      child: widget.prefixIcon!,
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      tooltip: _obscureText
                          ? AppLocalizations.of(context)?.showPassword ??
                                'Show password'
                          : AppLocalizations.of(context)?.hidePassword ??
                                'Hide password',
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      child: widget.suffixIcon!,
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: 15,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
                _currentError!,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.danger),
              )
              .animate()
              .fadeIn(duration: AppMotion.fast)
              .slideX(begin: -0.05, end: 0, duration: AppMotion.fast),
        ],
      ],
    );

    if (hasError) {
      field = field
          .animate(key: ValueKey(_currentError))
          .shake(hz: 4, curve: AppMotion.emphasis, duration: AppMotion.medium);
    }

    return field;
  }
}
