import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/storage_failure.dart';
import '../../../data/storage_providers.dart';

final accountEditorProvider =
    NotifierProvider.autoDispose<AccountEditor, AsyncValue<void>>(
      AccountEditor.new,
    );

class AccountEditor extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<bool> save({required String nickname, required int balance}) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    try {
      await ref
          .read(accountRepositoryProvider)
          .update(nickname: nickname, balance: balance);
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (_) {
      if (ref.mounted) {
        state = AsyncError(
          const StorageFailure(StorageFailureKind.write),
          StackTrace.current,
        );
      }
      return false;
    }
  }
}
