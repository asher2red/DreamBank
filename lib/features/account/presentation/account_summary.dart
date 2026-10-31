import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../data/database/app_database.dart';
import 'account_balance.dart';

class AccountSummary extends StatelessWidget {
  const AccountSummary({
    required this.account,
    required this.showBalance,
    required this.onToggleBalance,
    super.key,
  });
  final AccountSettings account;
  final bool showBalance;
  final VoidCallback onToggleBalance;
  @override
  Widget build(BuildContext context) => AppCard(
    backgroundAsset: AppAssets.accountBackground,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const BrandMark(size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'DreamBank',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                account.currencyCode,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          account.accountNickname,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Expanded(child: Text('Dream Money 잔고')),
            IconButton(
              tooltip: showBalance ? '잔고 숨기기' : '잔고 보기',
              onPressed: onToggleBalance,
              icon: Icon(
                showBalance
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (showBalance)
          AccountBalance(
            amount: account.virtualBalance,
            label: 'Dream Money 잔고',
          )
        else
          Text(
            '••••••••',
            semanticsLabel: '잔고가 숨겨져 있어요',
            style: Theme.of(context).textTheme.displaySmall,
          ),
      ],
    ),
  );
}
