import 'package:drift/drift.dart';

import '../../core/errors/storage_failure.dart';
import '../../core/utils/input_validation.dart';
import '../../features/mood/domain/mood_type.dart';
import '../database/app_database.dart';

class MoodRepository {
  MoodRepository(this.db, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final AppDatabase db;
  final DateTime Function() clock;

  SimpleSelectStatement<MoodEntries, MoodEntry> _latest() =>
      db.select(db.moodEntries)
        ..orderBy([
          (t) => OrderingTerm.desc(t.createdAt),
          (t) => OrderingTerm.desc(t.id),
        ])
        ..limit(1);

  Future<MoodEntry?> latest() => storageOperation(
    StorageFailureKind.read,
    () => _latest().getSingleOrNull(),
  );
  Stream<MoodEntry?> watchLatest() =>
      storageStream(_latest().watchSingleOrNull());
  Future<int> add(MoodType mood) => storageOperation(
    StorageFailureKind.write,
    () => db
        .into(db.moodEntries)
        .insert(
          MoodEntriesCompanion.insert(
            moodType: mood.name,
            createdAt: timestamp(clock),
          ),
        ),
  );
}
