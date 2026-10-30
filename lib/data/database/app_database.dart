import 'package:drift/drift.dart';

import '../../core/errors/storage_failure.dart';
import 'tables.dart';
export 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Accounts, MoodEntries, DreamItems, FutureLetters])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => transaction(() => m.createAll()),
    onUpgrade: (m, from, to) async {
      // Add explicit, data-preserving migrations when version 2 is introduced.
      throw const StorageFailure(StorageFailureKind.incompatible);
    },
  );
}
