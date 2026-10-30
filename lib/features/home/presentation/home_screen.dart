import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/editorial_image.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../account/presentation/account_card.dart';
import '../../mood/presentation/mood_section.dart';
import 'first_notice.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    storageKey: 'home',
    children: [
      const BrandWordmark(),
      const SizedBox(height: AppSpacing.xxl),
      Text(
        '잠시, 마음에\n여유를 주세요.',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: AppSpacing.md),
      const Text('A little escape from money worries.'),
      const SizedBox(height: AppSpacing.xxl),
      const AccountCard(),
      const SizedBox(height: AppSpacing.xl),
      const EditorialImage(asset: AppAssets.homeSerenity, aspectRatio: 2.5),
      const SizedBox(height: AppSpacing.xl),
      const MoodSection(),
      const FirstNotice(),
      const SizedBox(height: AppSpacing.xxl),
      Text('나를 위한 작은 공간', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: AppSpacing.sm),
      const Text('돈 걱정이 없는 하루라면, 무엇을 하고 싶나요?'),
      const SizedBox(height: AppSpacing.lg),
      OutlinedButton.icon(
        onPressed: () => context.go('/dreams'),
        icon: const Icon(Icons.auto_awesome_outlined),
        label: const Text('꿈 보관함 둘러보기'),
      ),
      const SizedBox(height: AppSpacing.xl),
      const Text('서두르지 않아도 괜찮아요. 이곳에서는 당신의 속도로.', textAlign: TextAlign.center),
    ],
  );
}
