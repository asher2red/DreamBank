import 'package:dreambank/core/errors/storage_failure.dart';
import 'package:dreambank/data/repositories/settings_repository.dart';
import 'package:dreambank/features/letters/domain/letter_date.dart';
import 'package:flutter_test/flutter_test.dart';

class MemorySettingsStore implements SettingsStore {
  final values = <String, Object?>{};
  bool failRead = false;
  bool failWrite = false;
  @override
  Future<Map<String, Object?>> read() async {
    if (failRead) throw StateError('private raw exception');
    return values;
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    if (failWrite) throw StateError('private raw exception');
    values[key] = value;
  }
}

void main() {
  test('settings default, persist across repository recreation and tolerate unknown theme', () async {
    final store = MemorySettingsStore();
    var repository = SettingsRepository(store);
    expect((await repository.read()).onboardingCompleted, false);
    await repository.completeOnboarding();
    store.values[SettingsRepository.themeKey] = 'unknown';
    repository = SettingsRepository(store);
    final result = await repository.read();
    expect(result.themeMode, 'dark');
    expect(result.onboardingCompleted, true);
    expect(result.readFailed, false);
    store.values[SettingsRepository.onboardingKey] = 'not a bool';
    expect((await repository.read()).onboardingCompleted, false);
  });
  test('settings read failure falls back and write failure is not reported as success', () async {
    final store = MemorySettingsStore()
      ..failRead = true
      ..failWrite = true;
    final repository = SettingsRepository(store);
    final fallback = await repository.read();
    expect(fallback.readFailed, true);
    expect(fallback.themeMode, 'dark');
    expect(fallback.onboardingCompleted, false);
    await expectLater(
      repository.completeOnboarding(),
      throwsA(
        isA<StorageFailure>().having(
          (e) => e.kind,
          'kind',
          StorageFailureKind.write,
        ),
      ),
    );
    expect(store.values, isEmpty);
  });
  test('calendar date unlock boundaries, immediate access and leap year validation', () {
    expect(canOpenLetter(null, DateTime(2026, 1, 1)), true);
    expect(
      canOpenLetter('2026-10-29', DateTime(2026, 10, 28, 23, 59, 59)),
      false,
    );
    expect(canOpenLetter('2026-10-29', DateTime(2026, 10, 29)), true);
    expect(canOpenLetter('2026-10-29', DateTime(2026, 10, 30)), true);
    expect(LetterDate.parse('2028-02-29').value, '2028-02-29');
    for (final date in [
      '2027-02-29',
      '2026-04-31',
      '0000-01-01',
      '2026-00-01',
      '2026-1-1',
    ]) {
      expect(() => LetterDate.parse(date), throwsA(isA<StorageFailure>()));
    }
    expect(canOpenLetter('2026-10-29', DateTime(2026, 10, 28)), false);
  });
}
