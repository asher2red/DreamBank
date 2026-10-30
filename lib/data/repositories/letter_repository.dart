import 'package:drift/drift.dart';

import '../../core/errors/storage_failure.dart';
import '../../core/utils/input_validation.dart';
import '../../features/letters/domain/letter_date.dart';
import '../database/app_database.dart';

class LetterRepository {
  LetterRepository(this.db, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final AppDatabase db;
  final DateTime Function() clock;

  SimpleSelectStatement<FutureLetters, FutureLetter> _list() =>
      db.select(db.futureLetters)..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
  SimpleSelectStatement<FutureLetters, FutureLetter> _one(int id) =>
      db.select(db.futureLetters)..where((t) => t.id.equals(id));
  Future<List<FutureLetter>> list() =>
      storageOperation(StorageFailureKind.read, () => _list().get());
  Stream<List<FutureLetter>> watchAll() => storageStream(_list().watch());
  Future<FutureLetter?> get(int id) => storageOperation(
    StorageFailureKind.read,
    () => _one(id).getSingleOrNull(),
  );
  Stream<FutureLetter?> watch(int id) =>
      storageStream(_one(id).watchSingleOrNull());

  Future<int> create({
    required String title,
    required String content,
    String? unlockAt,
  }) => storageOperation(StorageFailureKind.write, () async {
    final name = validatedText(title, max: 80, singleLine: true);
    final body = validatedText(content, max: 10000);
    if (unlockAt != null) LetterDate.parse(unlockAt);
    final now = timestamp(clock);
    return db
        .into(db.futureLetters)
        .insert(
          FutureLettersCompanion.insert(
            title: name,
            content: body,
            unlockAt: Value(unlockAt),
            createdAt: now,
            updatedAt: now,
          ),
        );
  });

  Future<void> update(
    int id, {
    required String title,
    required String content,
    required String? unlockAt,
  }) => storageOperation(StorageFailureKind.write, () async {
    final name = validatedText(title, max: 80, singleLine: true);
    final body = validatedText(content, max: 10000);
    if (unlockAt != null) LetterDate.parse(unlockAt);
    final count =
        await (db.update(
          db.futureLetters,
        )..where((t) => t.id.equals(id))).write(
          FutureLettersCompanion(
            title: Value(name),
            content: Value(body),
            unlockAt: Value(unlockAt),
            updatedAt: Value(timestamp(clock)),
          ),
        );
    if (count != 1) throw const StorageFailure(StorageFailureKind.notFound);
  });
  Future<void> delete(int id) =>
      storageOperation(StorageFailureKind.write, () async {
        final count = await (db.delete(
          db.futureLetters,
        )..where((t) => t.id.equals(id))).go();
        if (count != 1) throw const StorageFailure(StorageFailureKind.notFound);
      });
}
