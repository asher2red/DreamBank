import 'package:drift/drift.dart';

import '../../core/errors/storage_failure.dart';
import '../../core/utils/input_validation.dart';
import '../database/app_database.dart';

class AccountRepository {
  AccountRepository(this.db, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final AppDatabase db;
  final DateTime Function() clock;

  Future<void> ensureDefault() => storageOperation(
    StorageFailureKind.write,
    () => db.transaction(() async {
      final now = timestamp(clock);
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              id: const Value(1),
              accountNickname: '나의 여유 계좌',
              createdAt: now,
              updatedAt: now,
            ),
            onConflict: DoNothing(target: [db.accounts.id]),
          );
    }),
  );

  Future<AccountSettings> get() => storageOperation(
    StorageFailureKind.read,
    () => db.select(db.accounts).getSingle(),
  );

  Stream<AccountSettings> watch() =>
      storageStream(db.select(db.accounts).watchSingle());

  Future<void> update({String? nickname, int? balance}) =>
      storageOperation(StorageFailureKind.write, () async {
        final normalized = nickname == null
            ? null
            : validatedText(nickname, max: 30, singleLine: true);
        if (balance != null) validateAmount(balance);
        if (nickname == null && balance == null) return;
        final count = await db
            .update(db.accounts)
            .write(
              AccountsCompanion(
                accountNickname: normalized == null
                    ? const Value.absent()
                    : Value(normalized),
                virtualBalance: balance == null
                    ? const Value.absent()
                    : Value(balance),
                updatedAt: Value(timestamp(clock)),
              ),
            );
        if (count != 1) throw const StorageFailure(StorageFailureKind.notFound);
      });
}
