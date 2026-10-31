import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../../data/storage_providers.dart';
import 'account_summary.dart';
import 'account_actions.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});
  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool _showBalance = true;
  @override
  Widget build(BuildContext context) => AppPage(
    storageKey: 'account',
    children: [
      Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                '내 계좌',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          IconButton(
            tooltip: '계좌 설정',
            onPressed: () => context.push('/account/edit'),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        'ACCOUNT OVERVIEW',
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(letterSpacing: 2, fontSize: 11),
      ),
      const SizedBox(height: AppSpacing.xl),
      ref
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
            data: (account) {
              final created = DateTime.fromMillisecondsSinceEpoch(
                account.createdAt,
              ).toLocal();
              final opened =
                  '${created.year}.${created.month.toString().padLeft(2, '0')}.${created.day.toString().padLeft(2, '0')}';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AccountSummary(
                    account: account,
                    showBalance: _showBalance,
                    onToggleBalance: () =>
                        setState(() => _showBalance = !_showBalance),
                  ),
                  const SizedBox(height: 12),
                  const AccountActions(),
                  const SizedBox(height: 32),
                  const _SectionTitle(title: '거래 내역', detail: '전체'),
                  const SizedBox(height: 16),
                  AppCard(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 32,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.65,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '아직 거래 내역이 없어요',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '표시할 입출금 내역이 없어요.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _SectionTitle(title: '계좌 정보'),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      children: [
                        const _InfoRow(label: '계좌 유형', value: 'Dream Money'),
                        const SizedBox(height: 16),
                        const _InfoRow(label: '통화', value: '대한민국 원'),
                        const SizedBox(height: 16),
                        _InfoRow(label: '개설일', value: opened),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _SectionTitle(title: '계좌 관리'),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.person_outline),
                          title: const Text('DreamBank 계정'),
                          subtitle: const Text('Google · Apple 로그인'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push('/account/login'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.tune_rounded),
                          title: const Text('계좌 설정 수정'),
                          subtitle: const Text('별칭 · 잔고'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push('/account/edit'),
                        ),
                        Divider(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.info_outline),
                          title: const Text('DreamBank 소개'),
                          subtitle: const Text('서비스 안내'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push('/account/about'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.detail});
  final String title;
  final String? detail;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
      ),
      if (detail != null)
        Text(detail!, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (MediaQuery.textScalerOf(context).scale(14) > 21) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
    },
  );
}
