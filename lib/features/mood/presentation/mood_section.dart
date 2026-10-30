import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_state_view.dart';
import '../application/mood_controller.dart';
import '../domain/messages.dart';
import '../domain/mood_type.dart';

class MoodSection extends ConsumerWidget {
  const MoodSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(moodControllerProvider)
      .when(
        skipLoadingOnReload: true,
        loading: () => const AppCard(
          child: Center(
            child: CircularProgressIndicator(semanticsLabel: '오늘의 마음 불러오는 중'),
          ),
        ),
        error: (_, _) => AppCard(
          child: AppStateView(
            icon: Icons.favorite_border,
            title: '마음 기록을 불러오지 못했어요',
            message: '계좌와 다른 기능은 계속 이용할 수 있어요.',
            actionLabel: '마음 기록 다시 불러오기',
            onAction: () => ref.invalidate(moodControllerProvider),
          ),
        ),
        data: (session) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘의 여유',
                    style: TextStyle(color: AppColors.accent),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    session.message,
                    key: const ValueKey('comfort-message'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton.icon(
                    onPressed: session.saving
                        ? null
                        : () => ref
                              .read(moodControllerProvider.notifier)
                              .nextMessage(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('다른 메시지'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('오늘의 마음 잔고', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            const Text('지금 마음은 어떤가요? 선택하지 않아도 괜찮아요.'),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final mood in MoodType.values)
                  ChoiceChip(
                    label: Text(Messages.label(mood)),
                    selected: session.mood == mood,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onSelected: session.saving
                        ? null
                        : (_) => ref
                              .read(moodControllerProvider.notifier)
                              .select(mood),
                  ),
              ],
            ),
            if (session.saving) const Text('마음을 기록하고 있어요…'),
            if (session.failedMood != null) ...[
              const Text('마음을 저장하지 못했어요. 이전 선택은 그대로 유지돼요.'),
              TextButton(
                onPressed: session.saving
                    ? null
                    : () => ref
                          .read(moodControllerProvider.notifier)
                          .select(session.failedMood!),
                child: const Text('마음 저장 다시 시도'),
              ),
            ],
          ],
        ),
      );
}
