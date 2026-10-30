import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/utils/currency.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../../data/storage_providers.dart';

class AccountCard extends ConsumerWidget {
  const AccountCard({super.key});
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
              const Text(
                '상상 속 여유가 머무는 곳',
                style: TextStyle(color: AppColors.accent),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                account.accountNickname,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              Semantics(
                label: '가상 잔고 ${formatWon(account.virtualBalance)}',
                child: ExcludeSemantics(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final amount = formatWon(account.virtualBalance);
                      var style = Theme.of(context).textTheme.displaySmall!;
                      final scaler = MediaQuery.textScalerOf(context);
                      final measure = TextPainter(
                        text: TextSpan(text: amount, style: style),
                        textDirection: Directionality.of(context),
                        textScaler: scaler,
                      )..layout();
                      if (scaler.scale(1) <= 1 &&
                          measure.width > constraints.maxWidth) {
                        style = style.copyWith(
                          fontSize:
                              (style.fontSize! *
                                      (constraints.maxWidth - 1) /
                                      measure.width)
                                  .clamp(24.0, 40.0),
                        );
                      }
                      measure.dispose();
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          amount,
                          key: const ValueKey('virtual-balance'),
                          style: style,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('가상 잔고 · 실제 금융 자산이 아니에요.'),
            ],
          ),
        ),
  );
}
