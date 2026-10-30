import 'dart:io';

import 'package:drift/native.dart';
import 'package:dreambank/core/errors/storage_failure.dart';
import 'package:dreambank/data/database/app_database.dart';
import 'package:dreambank/data/repositories/account_repository.dart';
import 'package:dreambank/data/repositories/dream_repository.dart';
import 'package:dreambank/data/repositories/letter_repository.dart';
import 'package:dreambank/data/repositories/mood_repository.dart';
import 'package:dreambank/features/mood/domain/mood_type.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher failure(StorageFailureKind kind) =>
    isA<StorageFailure>().having((e) => e.kind, 'kind', kind);

class FutureVersionDatabase extends AppDatabase {
  FutureVersionDatabase(super.executor);
  @override
  int get schemaVersion => 2;
}

void main() {
  late AppDatabase db;
  var dbClosed = false;
  late DateTime now;
  late AccountRepository account;
  late DreamRepository dreams;
  late LetterRepository letters;
  late MoodRepository moods;
  setUp(() {
    dbClosed = false;
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime.utc(2026, 10, 29);
    account = AccountRepository(db, clock: () => now);
    dreams = DreamRepository(db, clock: () => now);
    letters = LetterRepository(db, clock: () => now);
    moods = MoodRepository(db, clock: () => now);
  });
  Future<void> closeMemory() async {
    if (!dbClosed) {
      dbClosed = true;
      await db.close();
    }
  }

  tearDown(closeMemory);

  test('initialization is idempotent under concurrent requests and preserves edits', () async {
    await Future.wait(List.generate(10, (_) => account.ensureDefault()));
    final original = await account.get();
    expect(original.id, 1);
    expect(original.accountNickname, '나의 여유 계좌');
    expect(original.virtualBalance, 1000000000);
    expect(original.currencyCode, 'KRW');
    expect(await db.select(db.accounts).get(), hasLength(1));
    expect(await dreams.list(), isEmpty);
    expect(await letters.list(), isEmpty);
    expect(await moods.latest(), isNull);
    now = now.add(const Duration(days: 1));
    await Future.wait([
      account.update(nickname: ' 나의 쉼 '),
      account.update(balance: 0),
    ]);
    await account.ensureDefault();
    final updated = await account.get();
    expect(updated.accountNickname, '나의 쉼');
    expect(updated.virtualBalance, 0);
    expect(updated.createdAt, original.createdAt);
    expect(updated.updatedAt, now.millisecondsSinceEpoch);
  });

  test(
    'account rejects invalid money and counts emoji as user-visible characters',
    () async {
      await account.ensureDefault();
      final emoji = List.filled(30, '👨‍👩‍👧‍👦').join();
      await account.update(nickname: emoji, balance: 999999999999);
      expect((await account.get()).accountNickname, emoji);
      for (final value in [-1, 1000000000000]) {
        await expectLater(
          account.update(balance: value),
          throwsA(failure(StorageFailureKind.validation)),
        );
      }
      for (final name in ['', '  ', '$emoji👨‍👩‍👧‍👦', 'a\nb']) {
        await expectLater(
          account.update(nickname: name),
          throwsA(failure(StorageFailureKind.validation)),
        );
      }
      expect((await account.get()).virtualBalance, 999999999999);
    },
  );

  test('dream CRUD handles nullable costs, ordering and timestamps independently of account', () async {
    await account.ensureDefault();
    final first = await dreams.create(title: ' 여행 ', description: ' 쉼 ');
    final second = await dreams.create(title: '여행', estimatedCost: 0);
    expect((await dreams.list()).map((e) => e.id), [second, first]);
    final original = (await dreams.get(first))!;
    expect(original.title, '여행');
    expect(original.description, '쉼');
    expect(original.estimatedCost, isNull);
    now = now.add(const Duration(minutes: 1));
    await dreams.update(
      first,
      title: '가족 여행',
      description: '',
      estimatedCost: 999999999999,
    );
    expect((await dreams.list()).first.id, first);
    expect((await dreams.get(first))!.createdAt, original.createdAt);
    await dreams.update(
      first,
      title: '휴식',
      description: '',
      estimatedCost: null,
    );
    expect((await dreams.get(first))!.estimatedCost, isNull);
    await dreams.delete(first);
    expect(await dreams.get(first), isNull);
    expect((await account.get()).virtualBalance, 1000000000);
    for (final action in [
      dreams.delete(first),
      dreams.update(first, title: '없음', description: '', estimatedCost: null),
    ]) {
      await expectLater(action, throwsA(failure(StorageFailureKind.notFound)));
    }
  });

  test('letters preserve createdAt and validate date without normalizing invalid days', () async {
    final id = await letters.create(
      title: ' 안부 ',
      content: ' 잘 지내 ',
      unlockAt: '2028-02-29',
    );
    final original = (await letters.get(id))!;
    now = now.add(const Duration(days: 2));
    await letters.update(id, title: '새 안부', content: '고마워', unlockAt: null);
    final updated = (await letters.get(id))!;
    expect(updated.content, '고마워');
    expect(updated.unlockAt, isNull);
    expect(updated.createdAt, original.createdAt);
    expect(updated.updatedAt, now.millisecondsSinceEpoch);
    for (final date in [
      '2027-02-29',
      '2026-13-01',
      '2026-01-32',
      '2026-1-01',
    ]) {
      await expectLater(
        letters.create(title: '안부', content: '내용', unlockAt: date),
        throwsA(failure(StorageFailureKind.validation)),
      );
    }
    await expectLater(
      letters.create(title: '안부', content: '  '),
      throwsA(failure(StorageFailureKind.validation)),
    );
    await letters.delete(id);
    expect(await letters.get(id), isNull);
    await expectLater(
      letters.delete(id),
      throwsA(failure(StorageFailureKind.notFound)),
    );
    await expectLater(
      letters.update(id, title: '없음', content: '없음', unlockAt: null),
      throwsA(failure(StorageFailureKind.notFound)),
    );
  });

  test(
    'all streams deliver committed changes and use deterministic tie ordering',
    () async {
      await account.ensureDefault();
      final dreamEvent = expectLater(
        dreams.watchAll().take(2),
        emitsInOrder([
          isEmpty,
          isA<List<DreamItem>>().having((v) => v.single.title, 'title', '휴식'),
        ]),
      );
      final moodEvent = expectLater(
        moods.watchLatest().take(2),
        emitsInOrder([
          isNull,
          isA<MoodEntry>().having((v) => v.moodType, 'mood', 'tired'),
        ]),
      );
      // Complete initial snapshots before mutating.
      await dreams.watchAll().first;
      await moods.watchLatest().first;
      await dreams.create(title: '휴식');
      await moods.add(MoodType.tired);
      await Future.wait([dreamEvent, moodEvent]);
      final id = await moods.add(MoodType.happy);
      expect((await moods.latest())!.id, id);
      final accountChange = expectLater(
        account.watch().take(2),
        emitsInOrder([
          isA<AccountSettings>().having(
            (v) => v.accountNickname,
            'name',
            '나의 여유 계좌',
          ),
          isA<AccountSettings>().having((v) => v.accountNickname, 'name', '여유'),
        ]),
      );
      await account.watch().first;
      await account.update(nickname: '여유');
      await accountChange;
      final letterChange = expectLater(
        letters.watchAll().take(2),
        emitsInOrder([
          isEmpty,
          isA<List<FutureLetter>>().having(
            (v) => v.single.title,
            'title',
            '안부',
          ),
        ]),
      );
      await letters.watchAll().first;
      await letters.create(title: '안부', content: '내용');
      await letterChange;
    },
  );

  test('SQLite constraints protect raw writes and expected indices exist', () async {
    await account.ensureDefault();
    final indices = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
        .get();
    expect(
      indices.map((r) => r.read<String>('name')),
      containsAll(['mood_latest', 'dream_recent', 'letter_recent']),
    );
    for (final sql in [
      "UPDATE account_settings SET virtual_balance = -1",
      "UPDATE account_settings SET currency_code = 'USD'",
      "UPDATE account_settings SET id = 2",
      "UPDATE account_settings SET account_nickname = ' '",
      "INSERT INTO mood_entries (mood_type, created_at) VALUES ('invalid', 0)",
      "INSERT INTO dream_items (title, created_at, updated_at) VALUES (' ', 0, 0)",
      "INSERT INTO dream_items (title, estimated_cost, created_at, updated_at) VALUES ('꿈', -1, 0, 0)",
      "INSERT INTO future_letters (title, content, unlock_at, created_at, updated_at) VALUES ('안부', '내용', 'bad', 0, 0)",
    ]) {
      await expectLater(db.customStatement(sql), throwsA(isA<Exception>()));
    }
    expect((await account.get()).virtualBalance, 1000000000);
  });

  test(
    'transaction rollback never publishes or preserves partial user data',
    () async {
      await account.ensureDefault();
      await expectLater(
        db.transaction(() async {
          await dreams.create(title: '롤백 대상');
          throw const StorageFailure(StorageFailureKind.write);
        }),
        throwsA(failure(StorageFailureKind.write)),
      );
      expect(await dreams.list(), isEmpty);
    },
  );

  test('file reopen preserves edits, moods, letters and deletions', () async {
    await closeMemory();
    final directory = await Directory.systemTemp.createTemp('dreambank-db-');
    final file = File('${directory.path}/test.sqlite');
    try {
      var disk = AppDatabase(NativeDatabase(file));
      final a = AccountRepository(disk);
      final d = DreamRepository(disk);
      final l = LetterRepository(disk);
      await a.ensureDefault();
      await a.update(nickname: '지속되는 여유', balance: 42);
      final kept = await d.create(title: '남겨둘 꿈', estimatedCost: 0);
      final deleted = await d.create(title: '삭제할 꿈');
      await d.delete(deleted);
      final letterId = await l.create(
        title: '미래',
        content: '기억해',
        unlockAt: '2030-01-01',
      );
      await MoodRepository(disk).add(MoodType.okay);
      await disk.close();
      disk = AppDatabase(NativeDatabase(file));
      try {
        await AccountRepository(disk).ensureDefault();
        expect(
          (await AccountRepository(disk).get()).accountNickname,
          '지속되는 여유',
        );
        expect((await AccountRepository(disk).get()).virtualBalance, 42);
        expect(await disk.select(disk.accounts).get(), hasLength(1));
        expect((await DreamRepository(disk).get(kept))!.estimatedCost, 0);
        expect(await DreamRepository(disk).get(deleted), isNull);
        expect(
          (await LetterRepository(disk).get(letterId))!.unlockAt,
          '2030-01-01',
        );
        expect((await MoodRepository(disk).latest())!.moodType, 'okay');
      } finally {
        await disk.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });

  test('newer schema is rejected without destroying its records', () async {
    await closeMemory();
    final directory = await Directory.systemTemp.createTemp('dreambank-newer-');
    final file = File('${directory.path}/newer.sqlite');
    try {
      final future = FutureVersionDatabase(NativeDatabase(file));
      await AccountRepository(future).ensureDefault();
      await AccountRepository(future).update(nickname: '보존');
      await future.close();
      final older = AppDatabase(NativeDatabase(file));
      await expectLater(
        AccountRepository(older).ensureDefault(),
        throwsA(failure(StorageFailureKind.incompatible)),
      );
      await older.close();
      final reopened = FutureVersionDatabase(NativeDatabase(file));
      try {
        expect((await AccountRepository(reopened).get()).accountNickname, '보존');
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });

  test(
    'closed database failures are classified and never expose private content',
    () async {
      await account.ensureDefault();
      await closeMemory();
      await expectLater(
        dreams.create(title: '비밀 꿈'),
        throwsA(failure(StorageFailureKind.write)),
      );
      await expectLater(
        dreams.list(),
        throwsA(failure(StorageFailureKind.read)),
      );
      await expectLater(
        dreams.watchAll(),
        emitsError(failure(StorageFailureKind.read)),
      );
      expect(
        const StorageFailure(StorageFailureKind.write).toString(),
        'StorageFailure(write)',
      );
    },
  );
}
