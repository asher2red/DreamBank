import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dreambank/data/database/open_database.dart';
import 'package:dreambank/data/repositories/account_repository.dart';
import 'package:dreambank/data/repositories/dream_repository.dart';
import 'package:dreambank/data/repositories/letter_repository.dart';
import 'package:dreambank/data/repositories/settings_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native database and preferences survive reopening', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Storage verification'))),
    );
    final db = openAppDatabase();
    final account = AccountRepository(db);
    await account.ensureDefault();
    final original = await account.get();
    final dream = await DreamRepository(db)
        .create(title: '환경 검증용 꿈', estimatedCost: 0);
    final letter = await LetterRepository(db)
        .create(title: '환경 검증용 편지', content: '재연결 확인', unlockAt: '2030-01-01');
    await db.close();
    final reopened = openAppDatabase();
    try {
      await AccountRepository(reopened).ensureDefault();
      expect(
        (await AccountRepository(reopened).get()).createdAt,
        original.createdAt,
      );
      expect((await DreamRepository(reopened).get(dream))!.estimatedCost, 0);
      expect((await LetterRepository(reopened).get(letter))!.content, '재연결 확인');
    } finally {
      await DreamRepository(reopened).delete(dream);
      await LetterRepository(reopened).delete(letter);
      await reopened.close();
    }
    final preferences = SharedPreferencesAsync();
    final originalFlag = await preferences.getBool(
      SettingsRepository.onboardingKey,
    );
    try {
      await SettingsRepository(PreferencesSettingsStore()).completeOnboarding();
      expect(
        (await SettingsRepository(
          PreferencesSettingsStore(),
        ).read()).onboardingCompleted,
        true,
      );
    } finally {
      if (originalFlag == null) {
        await preferences.remove(SettingsRepository.onboardingKey);
      } else {
        await preferences.setBool(
          SettingsRepository.onboardingKey,
          originalFlag,
        );
      }
    }
  });
}
