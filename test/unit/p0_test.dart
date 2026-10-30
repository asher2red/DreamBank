import 'dart:async';

import 'package:drift/native.dart';
import 'package:dreambank/app/local_day.dart';
import 'package:dreambank/core/errors/storage_failure.dart';
import 'package:dreambank/core/utils/currency.dart';
import 'package:dreambank/data/database/app_database.dart';
import 'package:dreambank/data/repositories/account_repository.dart';
import 'package:dreambank/data/repositories/mood_repository.dart';
import 'package:dreambank/data/storage_providers.dart';
import 'package:dreambank/features/mood/application/mood_controller.dart';
import 'package:dreambank/features/mood/domain/messages.dart';
import 'package:dreambank/features/mood/domain/mood_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class ControlledMoods extends MoodRepository {
  ControlledMoods(super.db, {super.clock});
  bool fail = false;
  int calls = 0;
  Completer<void>? barrier;
  @override
  Future<int> add(MoodType mood) async {
    calls++;
    if (barrier != null) await barrier!.future;
    if (fail) throw const StorageFailure(StorageFailureKind.write);
    return super.add(mood);
  }
}

void main() {
  test('KRW formatting and strict input boundaries', () {
    expect(formatWon(1000000000), '₩1,000,000,000');
    expect(formatWon(0), '₩0');
    expect(formatWon(999999999999), '₩999,999,999,999');
    expect(parseWon('1,000,000'), 1000000);
    expect(parseWon(' 000 '), 0);
    for (final input in [
      '',
      '1,00',
      '1.5',
      '-1',
      '1e6',
      '₩100',
      '1000000000000',
      '9999999999999999999999999999',
    ]) {
      expect(() => parseWon(input), throwsA(isA<StorageFailure>()));
    }
  });

  test('message pools contain distinct messages for every mood', () {
    for (final mood in [null, ...MoodType.values]) {
      final pool = Messages.pool(mood);
      expect(pool.toSet().length, pool.length);
      expect(pool.length, greaterThanOrEqualTo(3));
      final index = Messages.initialIndex(DateTime(2026, 10, 29), mood);
      expect(pool[index], isNot(pool[(index + 1) % pool.length]));
    }
  });

  test('mood commit, duplicate protection, failure rollback, retry and midnight restoration', () async {
    final db = AppDatabase(NativeDatabase.memory());
    var now = DateTime(2026, 10, 29, 23, 59);
    final repository = ControlledMoods(db, clock: () => now);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        moodRepositoryProvider.overrideWithValue(repository),
      ],
    );
    container.listen(moodControllerProvider, (_, _) {});
    try {
      await AccountRepository(db).ensureDefault();
      expect(
        (await container.read(moodControllerProvider.future)).mood,
        isNull,
      );
      final controller = container.read(moodControllerProvider.notifier);
      final firstMessage = container
          .read(moodControllerProvider)
          .requireValue
          .message;
      controller.nextMessage();
      expect(
        container.read(moodControllerProvider).requireValue.message,
        isNot(firstMessage),
      );
      repository.barrier = Completer<void>();
      final save = controller.select(MoodType.happy);
      await controller.select(MoodType.tired);
      expect(repository.calls, 1);
      expect(container.read(moodControllerProvider).requireValue.saving, true);
      expect(container.read(moodControllerProvider).requireValue.mood, isNull);
      repository.barrier!.complete();
      await save;
      repository.barrier = null;
      expect(
        container.read(moodControllerProvider).requireValue.mood,
        MoodType.happy,
      );
      await controller.select(MoodType.happy);
      expect(repository.calls, 1);
      final previousMessage = container
          .read(moodControllerProvider)
          .requireValue
          .message;
      repository.fail = true;
      await controller.select(MoodType.tired);
      final failed = container.read(moodControllerProvider).requireValue;
      expect(failed.mood, MoodType.happy);
      expect(failed.message, previousMessage);
      expect(failed.failedMood, MoodType.tired);
      repository.fail = false;
      await controller.select(MoodType.tired);
      expect(
        container.read(moodControllerProvider).requireValue.mood,
        MoodType.tired,
      );
      container.invalidate(moodControllerProvider);
      expect(
        (await container.read(moodControllerProvider.future)).mood,
        MoodType.tired,
      );
      now = DateTime(2026, 10, 30);
      container.read(localDayProvider.notifier).refresh();
      expect(
        (await container.read(moodControllerProvider.future)).mood,
        isNull,
      );
      await container
          .read(moodControllerProvider.notifier)
          .select(MoodType.tired);
      expect(await db.select(db.moodEntries).get(), hasLength(3));
      expect((await AccountRepository(db).get()).virtualBalance, 1000000000);
    } finally {
      container.dispose();
      await db.close();
    }
  });
}
