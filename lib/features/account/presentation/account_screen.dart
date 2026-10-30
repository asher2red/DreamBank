import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_page.dart';
import 'account_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    storageKey: 'account',
    children: [
      const PageHeading(title: '내 계좌', subtitle: '당신만의 여유를 담을 공간이에요.'),
      const AccountCard(),
      const SizedBox(height: AppSpacing.xl),
      FilledButton.icon(
        onPressed: () => context.push('/account/edit'),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('계좌 설정 수정'),
      ),
      const SizedBox(height: AppSpacing.xl),
      const Text('공유용 카드 기능을 준비하고 있어요.'),
      const SizedBox(height: AppSpacing.lg),
      OutlinedButton.icon(
        onPressed: () => context.push('/account/about'),
        icon: const Icon(Icons.info_outline),
        label: const Text('DreamBank 소개'),
      ),
    ],
  );
}
