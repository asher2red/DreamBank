import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/storage_providers.dart';

class FirstNotice extends ConsumerStatefulWidget {
  const FirstNotice({super.key});
  @override
  ConsumerState<FirstNotice> createState() => _FirstNoticeState();
}

class _FirstNoticeState extends ConsumerState<FirstNotice> {
  bool _saving = false;
  bool _failed = false;
  bool _dismissed = false;
  Future<void> _confirm() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      await ref.read(settingsRepositoryProvider).completeOnboarding();
      if (!mounted) return;
      setState(() => _dismissed = true);
      ref.invalidate(settingsProvider);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).asData?.value;
    if (_dismissed || settings == null || settings.onboardingCompleted) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '마음의 여유를 위한 가상의 은행',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '잔고는 상상 속 자산이에요. 기록은 내 기기에 보관되며, 앱 삭제나 기기 변경 시 사라질 수 있어요.',
            ),
            if (settings.readFailed) ...[
              const SizedBox(height: AppSpacing.sm),
              const Text('설정을 읽지 못해 안내를 다시 보여드려요. 다른 기능은 계속 이용할 수 있어요.'),
              TextButton(
                onPressed: () => ref.invalidate(settingsProvider),
                child: const Text('설정 다시 불러오기'),
              ),
            ],
            if (_failed) const Text('안내 확인을 저장하지 못했어요. 다음 실행에 다시 나타날 수 있어요.'),
            TextButton(
              onPressed: _saving ? null : _confirm,
              child: Text(_saving ? '저장 중…' : '안내 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
