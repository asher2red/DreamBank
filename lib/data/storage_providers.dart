import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'database/open_database.dart';
import 'repositories/account_repository.dart';
import 'repositories/mood_repository.dart';
import 'repositories/dream_repository.dart';
import 'repositories/letter_repository.dart';
import 'repositories/settings_repository.dart';

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = openAppDatabase();
  ref.onDispose(() => unawaited(db.close()));
  return db;
});
final accountRepositoryProvider = Provider(
  (ref) => AccountRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);
final moodRepositoryProvider = Provider(
  (ref) => MoodRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);
final dreamRepositoryProvider = Provider(
  (ref) => DreamRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);
final letterRepositoryProvider = Provider(
  (ref) => LetterRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);
final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(PreferencesSettingsStore()),
);

final storageReadyProvider = FutureProvider<void>(
  (ref) => ref.watch(accountRepositoryProvider).ensureDefault(),
  retry: (retryCount, error) => null,
);
final accountProvider = StreamProvider<AccountSettings>((ref) async* {
  await ref.watch(storageReadyProvider.future);
  yield* ref.watch(accountRepositoryProvider).watch();
});
final latestMoodProvider = StreamProvider<MoodEntry?>((ref) async* {
  await ref.watch(storageReadyProvider.future);
  yield* ref.watch(moodRepositoryProvider).watchLatest();
});
final dreamsProvider = StreamProvider<List<DreamItem>>((ref) async* {
  await ref.watch(storageReadyProvider.future);
  yield* ref.watch(dreamRepositoryProvider).watchAll();
});
final lettersProvider = StreamProvider<List<FutureLetter>>((ref) async* {
  await ref.watch(storageReadyProvider.future);
  yield* ref.watch(letterRepositoryProvider).watchAll();
});
final settingsProvider = FutureProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).read(),
);
