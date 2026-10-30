import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/brand_mark.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(onPressed: () => context.pop()),
      title: const Text('DreamBank 소개'),
    ),
    body: SafeArea(
      top: false,
      child: AppPage(
        storageKey: 'about',
        children: [
          const BrandWordmark(),
          const SizedBox(height: AppSpacing.xl),
          const Text('A little escape from money worries.'),
          const SizedBox(height: AppSpacing.xxl),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('잠시 쉬어갈 수 있는 가상의 은행'),
                SizedBox(height: AppSpacing.md),
                Text(
                  'DreamBank는 실제 금융 서비스가 아닙니다. 가상 잔고는 실제 자산이 아니며, 은행 계좌나 결제 시스템과 연결되지 않습니다.',
                ),
                SizedBox(height: AppSpacing.xl),
                Text('기록은 내 기기에'),
                SizedBox(height: AppSpacing.md),
                Text(
                  '계좌와 마음 기록은 내 기기에 저장돼요. 꿈과 편지도 내 기기에 보관하도록 준비하고 있어요. 앱 삭제 또는 기기 변경 시 기록이 사라질 수 있습니다. 회원가입과 클라우드 동기화는 제공하지 않습니다.',
                ),
                SizedBox(height: AppSpacing.xl),
                Text('편지의 공개 날짜'),
                SizedBox(height: AppSpacing.md),
                Text(
                  '공개 날짜는 기기의 날짜를 기준으로 해요. 편지 잠금은 보안 잠금이 아니며 작성자는 언제든 편집할 수 있어요.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextButton(
            onPressed: () =>
                showLicensePage(context: context, applicationName: 'DreamBank'),
            child: const Text('오픈소스 라이선스'),
          ),
        ],
      ),
    ),
  );
}
