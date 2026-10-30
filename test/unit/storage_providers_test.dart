import 'dart:async';

import 'package:drift/native.dart';
import 'package:dreambank/data/database/app_database.dart';
import 'package:dreambank/data/repositories/settings_repository.dart';
import 'package:dreambank/data/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class UnavailableSettingsStore implements SettingsStore {
  @override
  Future<Map<String, Object?>> read() async => throw StateError('unavailable');
  @override
  Future<void> writeBool(String key, bool value) async =>
      throw StateError('unavailable');
}

void main() {
  test('provider graph initializes before emitting data and propagates account commits', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => DateTime.utc(2026, 10, 29)),
      ],
    );
    try {
      // Mirror widgets that actively watch these streams.
      container.listen(accountProvider, (_, _) {});
      container.listen(latestMoodProvider, (_, _) {});
      container.listen(dreamsProvider, (_, _) {});
      container.listen(lettersProvider, (_, _) {});
      expect(
        (await container.read(accountProvider.future)).virtualBalance,
        1000000000,
      );

      expect(await container.read(latestMoodProvider.future), isNull);

      expect(await container.read(dreamsProvider.future), isEmpty);

      expect(await container.read(lettersProvider.future), isEmpty);

      final changed = Completer<void>();
      container.listen(accountProvider, (_, value) {
        if (value.asData?.value.accountNickname == '여유' &&
            !changed.isCompleted) {
          changed.complete();
        }
      });
      await container.read(accountRepositoryProvider).update(nickname: '여유');
      await changed.future.timeout(const Duration(seconds: 3));
    } finally {
      container.dispose();
      await db.close();
    }
  });

  test(
    'preferences failure is independent from database initialization',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(UnavailableSettingsStore()),
          ),
        ],
      );
      try {
        expect(
          (await container.read(settingsProvider.future)).readFailed,
          true,
        );
        await container.read(storageReadyProvider.future);
        expect((await container.read(accountRepositoryProvider).get()).id, 1);
      } finally {
        container.dispose();
        await db.close();
      }
    },
  );
}
