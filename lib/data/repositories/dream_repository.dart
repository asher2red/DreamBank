import 'package:drift/drift.dart';

import '../../core/errors/storage_failure.dart';
import '../../core/utils/input_validation.dart';
import '../database/app_database.dart';

class DreamRepository {
  DreamRepository(this.db, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final AppDatabase db;
  final DateTime Function() clock;

  SimpleSelectStatement<DreamItems, DreamItem> _list() =>
      db.select(db.dreamItems)..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
  SimpleSelectStatement<DreamItems, DreamItem> _one(int id) =>
      db.select(db.dreamItems)..where((t) => t.id.equals(id));
  Future<List<DreamItem>> list() =>
      storageOperation(StorageFailureKind.read, () => _list().get());
  Stream<List<DreamItem>> watchAll() => storageStream(_list().watch());
  Future<DreamItem?> get(int id) => storageOperation(
    StorageFailureKind.read,
    () => _one(id).getSingleOrNull(),
  );
  Stream<DreamItem?> watch(int id) =>
      storageStream(_one(id).watchSingleOrNull());

  Future<int> create({
    required String title,
    String description = '',
    int? estimatedCost,
  }) => storageOperation(StorageFailureKind.write, () async {
    final name = validatedText(title, max: 80, singleLine: true);
    final detail = validatedText(description, max: 2000, required: false);
    if (estimatedCost != null) validateAmount(estimatedCost);
    final now = timestamp(clock);
    return db
        .into(db.dreamItems)
        .insert(
          DreamItemsCompanion.insert(
            title: name,
            description: Value(detail),
            estimatedCost: Value(estimatedCost),
            createdAt: now,
            updatedAt: now,
          ),
        );
  });

  Future<void> update(
    int id, {
    required String title,
    required String description,
    required int? estimatedCost,
  }) => storageOperation(StorageFailureKind.write, () async {
    final name = validatedText(title, max: 80, singleLine: true);
    final detail = validatedText(description, max: 2000, required: false);
    if (estimatedCost != null) validateAmount(estimatedCost);
    final count =
        await (db.update(db.dreamItems)..where((t) => t.id.equals(id))).write(
          DreamItemsCompanion(
            title: Value(name),
            description: Value(detail),
            estimatedCost: Value(estimatedCost),
            updatedAt: Value(timestamp(clock)),
          ),
        );
    if (count != 1) throw const StorageFailure(StorageFailureKind.notFound);
  });
  Future<void> delete(int id) =>
      storageOperation(StorageFailureKind.write, () async {
        final count = await (db.delete(
          db.dreamItems,
        )..where((t) => t.id.equals(id))).go();
        if (count != 1) throw const StorageFailure(StorageFailureKind.notFound);
      });
}
