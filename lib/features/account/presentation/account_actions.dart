import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';

enum _AccountAction {
  deposit(
    '입금',
    Icons.arrow_downward_rounded,
    Icons.cloud_outlined,
    '입금 창구는 잠시 꿈꾸는 중',
    '담당 직원이 구름 위에서 낮잠 중이에요. 마음의 여유는 언제든 입금해 주세요.',
    '여유는 입금 완료',
  ),
  withdraw(
    '출금',
    Icons.arrow_upward_rounded,
    Icons.bedtime_outlined,
    '현금보다 휴식이 먼저예요',
    'ATM이 오늘은 휴가를 냈어요. 대신 깊은 숨을 한 번 꺼내 드릴게요.',
    '후우, 잘 받았어요',
  ),
  transfer(
    '송금',
    Icons.swap_horiz_rounded,
    Icons.cloud_queue_rounded,
    '송금 담당 구름을 찾는 중',
    '마음은 보낼 수 있지만 돈을 배달할 구름은 아직 출근 전이에요.',
    '마음만 보낼게요',
  );

  const _AccountAction(
    this.label,
    this.icon,
    this.dialogIcon,
    this.title,
    this.joke,
    this.confirmation,
  );
  final String label;
  final IconData icon;
  final IconData dialogIcon;
  final String title;
  final String joke;
  final String confirmation;
}

/// These actions only present information; they have no data-layer dependency.
class AccountActions extends StatefulWidget {
  const AccountActions({super.key});
  @override
  State<AccountActions> createState() => _AccountActionsState();
}

class _AccountActionsState extends State<AccountActions> {
  bool _dialogOpen = false;

  Future<void> _show(_AccountAction action) async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          scrollable: true,
          icon: ExcludeSemantics(
            child: Icon(action.dialogIcon, size: 40, color: AppColors.accent),
          ),
          title: Text(action.title),
          content: Text(
            'Dream Money는 아직 ${action.label} 기능을 제공하지 않아요.\n\n${action.joke}',
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(action.confirmation, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      );
    } finally {
      _dialogOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final vertical =
          MediaQuery.textScalerOf(context).scale(14) > 21 ||
          constraints.maxWidth < 260;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          for (final action in _AccountAction.values)
            SizedBox(
              width: vertical
                  ? constraints.maxWidth
                  : (constraints.maxWidth - AppSpacing.md * 2) / 3,
              child: OutlinedButton(
                onPressed: () => _show(action),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: AppColors.textSecondary.withValues(alpha: 0.18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.lg,
                  ),
                ),
                child: vertical
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(action.icon, size: 22, color: AppColors.accent),
                          const SizedBox(width: AppSpacing.md),
                          Text(action.label),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(action.icon, size: 22, color: AppColors.accent),
                          const SizedBox(height: AppSpacing.sm),
                          Text(action.label),
                        ],
                      ),
              ),
            ),
        ],
      );
    },
  );
}
