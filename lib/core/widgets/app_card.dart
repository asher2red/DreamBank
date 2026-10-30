import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_tokens.dart';

class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.backgroundAsset, super.key});
  final Widget child;
  final String? backgroundAsset;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        if (backgroundAsset != null)
          Positioned.fill(
            child: ExcludeSemantics(
              child: Image.asset(
                backgroundAsset!,
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
                cacheWidth: 1200,
                filterQuality: FilterQuality.medium,
                errorBuilder: (_, _, _) =>
                    const ColoredBox(color: AppColors.surface),
              ),
            ),
          ),
        if (backgroundAsset != null)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: 0.08),
                      AppColors.background.withValues(alpha: 0.32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: child),
      ],
    ),
  );
}
