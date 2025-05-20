import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final double size;
  final String placeholderAsset;
  const Avatar({
    super.key,
    this.url,
    this.size = 90,
    this.placeholderAsset = 'assets/icons/avatar.svg',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        width: size,
        height: size,
        child: url != null && url!.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildPlaceholder(),
          errorWidget: (_, __, ___) => _buildPlaceholder(),
        )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return SvgPicture.asset(
      placeholderAsset,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}