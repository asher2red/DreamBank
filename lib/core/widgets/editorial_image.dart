import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_tokens.dart';

/// Decorative local photography; page information remains in accessible text.
class EditorialImage extends StatelessWidget {
  const EditorialImage({
    required this.asset,
    this.aspectRatio = 1.6,
    super.key,
  });
  final String asset;
  final double aspectRatio;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          cacheWidth: 1200,
          errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surface),
        ),
      ),
    ),
  );
}
