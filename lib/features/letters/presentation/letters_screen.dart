import 'package:flutter/material.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/editorial_image.dart';
import '../../../core/constants/app_assets.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_state_view.dart';

class LettersScreen extends StatelessWidget {
  const LettersScreen({super.key});
  @override
  Widget build(BuildContext context) => const AppPage(
    storageKey: 'letters',
    children: [
      PageHeading(title: '미래의 편지', subtitle: '지금의 마음을, 언젠가의 나에게.'),
      EditorialImage(asset: AppAssets.futureLetter),
      SizedBox(height: AppSpacing.xl),
      AppCard(
        child: AppStateView(
          icon: Icons.mail_outline_rounded,
          title: '미래의 나를 위한 작은 안부',
          message: '편지 작성과 공개 날짜 설정 기능을 준비하고 있어요.',
        ),
      ),
    ],
  );
}
