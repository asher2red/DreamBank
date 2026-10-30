import 'package:flutter/material.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/editorial_image.dart';
import '../../../core/constants/app_assets.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_state_view.dart';

class DreamVaultScreen extends StatelessWidget {
  const DreamVaultScreen({super.key});
  @override
  Widget build(BuildContext context) => const AppPage(
    storageKey: 'dreams',
    children: [
      PageHeading(title: '꿈 보관함', subtitle: '언젠가의 바람을, 나만의 공간에.'),
      EditorialImage(asset: AppAssets.dreamVault),
      SizedBox(height: AppSpacing.xl),
      AppCard(
        child: AppStateView(
          icon: Icons.auto_awesome_outlined,
          title: '당신의 꿈이 머물 자리를 준비해요',
          message: '꿈 작성과 보관 기능은 다음 개발 단계에서 만날 수 있어요.',
        ),
      ),
    ],
  );
}
