import 'dart:async';

import 'package:dreambank/features/auth/auth_service.dart';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dreambank/data/database/app_database.dart';
import 'package:dreambank/data/repositories/account_repository.dart';
import 'package:dreambank/data/repositories/settings_repository.dart';
import 'package:dreambank/data/storage_providers.dart';

class MemorySettings implements SettingsStore {
  MemorySettings({bool completed = true}) {
    values[SettingsRepository.onboardingKey] = completed;
  }
  final values = <String, Object?>{};
  bool failRead = false;
  bool failWrite = false;
  @override
  Future<Map<String, Object?>> read() async {
    if (failRead) throw StateError('read');
    return values;
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    if (failWrite) throw StateError('write');
    values[key] = value;
  }
}

ProviderContainer testContainer({
  Stream<LoginProfile?> Function()? profiles,
  MemorySettings? settings,
  AccountRepository Function(AppDatabase)? account,
  DateTime Function()? clock,
  Future<void> Function(Ref)? initialization,
}) => ProviderContainer(
  overrides: [
    loginProfileProvider.overrideWith(
      (ref) =>
          profiles?.call() ??
          Stream.value(const LoginProfile('test-user', '테스트 사용자', null)),
    ),
    if (initialization != null)
      storageReadyProvider.overrideWith(initialization),
    databaseProvider.overrideWith((ref) {
      final db = AppDatabase(NativeDatabase.memory());
      ref.onDispose(() => unawaited(db.close()));
      return db;
    }),
    if (account != null)
      accountRepositoryProvider.overrideWith(
        (ref) => account(ref.watch(databaseProvider)),
      ),
    settingsRepositoryProvider.overrideWithValue(
      SettingsRepository(settings ?? MemorySettings()),
    ),
    clockProvider.overrideWithValue(clock ?? () => DateTime(2026, 10, 29, 12)),
  ],
);
