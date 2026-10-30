import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/app_state_view.dart';
import '../core/widgets/app_page.dart';
import '../core/errors/storage_failure.dart';
import '../data/storage_providers.dart';

class StorageGate extends ConsumerWidget {
  const StorageGate({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(storageReadyProvider)
      .when(
        data: (_) => child,
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(semanticsLabel: '기록을 준비하고 있어요'),
          ),
        ),
        error: (error, _) => Scaffold(
          body: SafeArea(
            child: AppPage(
              storageKey: 'storage-error',
              children: [
                AppStateView(
                  icon: Icons.storage_outlined,
                  title:
                      error is StorageFailure &&
                          error.kind == StorageFailureKind.incompatible
                      ? '현재 앱에서 읽을 수 없는 기록이에요'
                      : '계좌를 불러오지 못했어요',
                  message:
                      error is StorageFailure &&
                          error.kind == StorageFailureKind.incompatible
                      ? '앱 버전을 확인해 주세요. 저장된 기록은 그대로 유지됩니다.'
                      : '기록을 지우지 않고 다시 시도할 수 있어요.',
                  actionLabel: '다시 시도',
                  onAction: () {
                    ref.invalidate(databaseProvider);
                    ref.invalidate(storageReadyProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
