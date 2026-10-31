import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';
import 'account_balance.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../data/storage_providers.dart';

class AccountCard extends ConsumerWidget {
  const AccountCard({this.showDisclosure = true, super.key});
  final bool showDisclosure;
  @override
  Widget build(BuildContext context, WidgetRef ref) => AppCard(
    backgroundAsset: AppAssets.accountBackground,
    child: ref
        .watch(accountProvider)
        .when(
          loading: () => const Center(
            child: CircularProgressIndicator(semanticsLabel: '계좌 불러오는 중'),
          ),
          error: (_, _) => AppStateView(
            icon: Icons.account_balance_wallet_outlined,
            title: '계좌를 불러오지 못했어요',
            message: '잠시 후 다시 시도해 주세요.',
            actionLabel: '계좌 다시 불러오기',
            onAction: () => ref.invalidate(accountProvider),
          ),
          data: (account) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDisclosure)
                const Text(
                  '상상 속 여유가 머무는 곳',
                  style: TextStyle(color: AppColors.accent),
                )
              else
                Row(
                  children: [
                    const Expanded(child: BrandWordmark()),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      account.currencyCode,
                      style: const TextStyle(color: AppColors.accent),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                account.accountNickname,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              if (!showDisclosure) ...[
                const Text('Dream Money 잔고'),
                const SizedBox(height: AppSpacing.sm),
              ],
              AccountBalance(
                amount: account.virtualBalance,
                label: showDisclosure ? '가상 잔고' : 'Dream Money 잔고',
              ),
              if (showDisclosure) ...[
                const SizedBox(height: AppSpacing.xl),
                const Text('가상 잔고 · 실제 금융 자산이 아니에요.'),
              ],
            ],
          ),
        ),
  );
}
