import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'skeleton_loader.dart';

/// Thin wrapper around [CachedNetworkImage] with fallback asset support.
///
/// - Detects if [url] is a local asset path (starts with 'assets/') or a remote URL.
/// - Supports SVG files automatically via [SvgPicture].
/// - Falls back to [Image.asset] with [fallbackAsset] when [url] is null/empty.
/// - Shows a [SkeletonLoader.card] as placeholder while loading remote images.
class CachedImage extends StatelessWidget {
  final String? url;
  final String? fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;

  const CachedImage({
    super.key,
    this.url,
    this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
  });

  bool get _hasUrl => url != null && url!.isNotEmpty;
  bool get _isLocalAsset => _hasUrl && url!.startsWith('assets/');

  Widget _buildAssetImage(String path) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  Widget _fallback() {
    if (fallbackAsset != null && fallbackAsset!.isNotEmpty) {
      return _buildAssetImage(fallbackAsset!);
    }
    return SizedBox(width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (_hasUrl) {
      if (_isLocalAsset) {
        image = _buildAssetImage(url!);
      } else {
        image = CachedNetworkImage(
          imageUrl: url!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          placeholder: (context, url) => SkeletonLoader.card(
            width: width,
            height: height,
          ),
          errorWidget: (context, url, error) => _fallback(),
        );
      }
    } else {
      image = _fallback();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}
