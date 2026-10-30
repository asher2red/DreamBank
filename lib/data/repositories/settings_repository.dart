import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/storage_failure.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = 'dark',
    this.onboardingCompleted = false,
    this.readFailed = false,
  });
  final String themeMode;
  final bool onboardingCompleted;
  final bool readFailed;
}

abstract interface class SettingsStore {
  Future<Map<String, Object?>> read();
  Future<void> writeBool(String key, bool value);
}

class PreferencesSettingsStore implements SettingsStore {
  @override
  Future<Map<String, Object?>> read() => SharedPreferencesAsync().getAll(
    allowList: {SettingsRepository.themeKey, SettingsRepository.onboardingKey},
  );
  @override
  Future<void> writeBool(String key, bool value) =>
      SharedPreferencesAsync().setBool(key, value);
}

class SettingsRepository {
  SettingsRepository(this.store);
  final SettingsStore store;
  static const themeKey = 'settings.theme_mode';
  static const onboardingKey = 'settings.onboarding_completed';

  Future<AppSettings> read() async {
    try {
      final values = await store.read();
      return AppSettings(onboardingCompleted: values[onboardingKey] == true);
    } catch (_) {
      return const AppSettings(readFailed: true);
    }
  }

  Future<void> completeOnboarding() => storageOperation(
    StorageFailureKind.write,
    () => store.writeBool(onboardingKey, true),
  );
}
