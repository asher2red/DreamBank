import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dreambank/main.dart' as app;
import 'package:dreambank/core/utils/currency.dart';
import 'package:dreambank/data/repositories/settings_repository.dart';
import 'package:dreambank/data/storage_providers.dart';
import 'package:dreambank/features/home/presentation/home_screen.dart';
import 'package:dreambank/features/mood/application/mood_controller.dart';
import 'package:dreambank/features/mood/domain/messages.dart';
import 'package:dreambank/features/mood/domain/mood_type.dart';

Future<void> tapText(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label));
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

ProviderContainer scope(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(HomeScreen)));

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'P0 changes persist after rebuilding the entire application scope',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();
      var container = scope(tester);
      final original = await container.read(accountRepositoryProvider).get();
      final originalMood = await container
          .read(moodRepositoryProvider)
          .latest();
      final preferences = SharedPreferencesAsync();
      final originalNotice = await preferences.getBool(
        SettingsRepository.onboardingKey,
      );
      int? addedMood;
      try {
        expect(find.text(formatWon(original.virtualBalance)), findsOneWidget);
        final first = tester
            .widget<Text>(find.byKey(const ValueKey('comfort-message')))
            .data;
        await tapText(tester, '다른 메시지');
        expect(
          tester
              .widget<Text>(find.byKey(const ValueKey('comfort-message')))
              .data,
          isNot(first),
        );
        final current = container
            .read(moodControllerProvider)
            .requireValue
            .mood;
        final chosen = current == MoodType.tired
            ? MoodType.happy
            : MoodType.tired;
        await tapText(tester, Messages.label(chosen));
        final latest = (await container.read(moodRepositoryProvider).latest())!;
        if (latest.id != originalMood?.id) addedMood = latest.id;
        if (find.text('안내 확인').evaluate().isNotEmpty) {
          await tapText(tester, '안내 확인');
        }
        await tester.tap(
          find.descendant(
            of: find.byType(NavigationBar),
            matching: find.text('내 계좌'),
          ),
        );
        await tester.pumpAndSettle();
        await tapText(tester, '계좌 설정 수정');
        await tester.enterText(
          find.byKey(const ValueKey('nickname-input')),
          '검증용 여유 계좌',
        );
        await tester.enterText(
          find.byKey(const ValueKey('balance-input')),
          '2,000,000,000',
        );
        FocusManager.instance.primaryFocus?.unfocus();
        await tapText(tester, '계좌 설정 저장');
        expect(find.text('₩2,000,000,000'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        app.main();
        await tester.pumpAndSettle();
        container = scope(tester);
        expect(find.text('검증용 여유 계좌'), findsOneWidget);
        expect(find.text('₩2,000,000,000'), findsOneWidget);
        expect(
          container.read(moodControllerProvider).requireValue.mood,
          chosen,
        );
        expect(find.text('안내 확인'), findsNothing);
      } finally {
        await container
            .read(accountRepositoryProvider)
            .update(
              nickname: original.accountNickname,
              balance: original.virtualBalance,
            );
        if (addedMood != null) {
          final db = container.read(databaseProvider);
          await (db.delete(
            db.moodEntries,
          )..where((row) => row.id.equals(addedMood!))).go();
        }
        if (originalNotice == null) {
          await preferences.remove(SettingsRepository.onboardingKey);
        } else {
          await preferences.setBool(
            SettingsRepository.onboardingKey,
            originalNotice,
          );
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      }
    },
  );
}
