import 'dart:convert';

import 'package:dreambank/app/app.dart';
import 'package:dreambank/data/storage_providers.dart';
import 'package:dreambank/features/account/presentation/account_actions.dart';
import 'package:dreambank/features/mood/domain/mood_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

const dialogs = [
  ('입금', '입금 창구는 잠시 꿈꾸는 중', '여유는 입금 완료'),
  ('출금', '현금보다 휴식이 먼저예요', '후우, 잘 받았어요'),
  ('송금', '송금 담당 구름을 찾는 중', '마음만 보낼게요'),
];

Future<void> openAccount(
  WidgetTester tester,
  ProviderContainer container,
) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const DreamBankApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('내 계좌'),
    ),
  );
  await tester.pumpAndSettle();
}

Future<String> snapshot(ProviderContainer container) async {
  final db = container.read(databaseProvider);
  return jsonEncode({
    'account': (await container.read(accountRepositoryProvider).get()).toJson(),
    'moods': (await db.select(db.moodEntries).get())
        .map((e) => e.toJson())
        .toList(),
    'dreams': (await container.read(dreamRepositoryProvider).list())
        .map((e) => e.toJson())
        .toList(),
    'letters': (await container.read(letterRepositoryProvider).list())
        .map((e) => e.toJson())
        .toList(),
    'notice': (await container.read(settingsRepositoryProvider).read())
        .onboardingCompleted,
  });
}

void main() {
  testWidgets(
    'all banking buttons show the requested popup without mutating any stored data',
    (tester) async {
      final container = testContainer();
      addTearDown(container.dispose);
      await openAccount(tester, container);
      await container.read(moodRepositoryProvider).add(MoodType.happy);
      await container.read(dreamRepositoryProvider).create(title: '보존할 꿈');
      await container
          .read(letterRepositoryProvider)
          .create(title: '보존할 편지', content: '기억할 내용');
      final before = await snapshot(container);
      expect(find.text('가상 잔고 · 실제 금융 자산이 아니에요.'), findsNothing);
      expect(find.text('Dream Money 잔고'), findsOneWidget);
      expect(find.text('KRW'), findsOneWidget);
      expect(find.text('아직 거래 내역이 없어요'), findsOneWidget);
      final account = await container.read(accountRepositoryProvider).get();
      final created = DateTime.fromMillisecondsSinceEpoch(account.createdAt)
          .toLocal();
      final opened =
          '${created.year}.${created.month.toString().padLeft(2, '0')}.${created.day.toString().padLeft(2, '0')}';
      expect(find.text(opened), findsOneWidget);
      expect(find.text('₩1,000,000,000'), findsOneWidget);
      await tester.tap(find.byTooltip('잔고 숨기기'));
      await tester.pumpAndSettle();
      expect(find.text('₩1,000,000,000'), findsNothing);
      expect(find.text('••••••••'), findsOneWidget);
      await tester.tap(find.byTooltip('잔고 보기'));
      await tester.pumpAndSettle();
      expect(find.text('₩1,000,000,000'), findsOneWidget);
      for (final (label, title, confirmation) in dialogs) {
        final button = find.widgetWithText(OutlinedButton, label);
        await tester.ensureVisible(button);
        expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);
        expect(
          find.textContaining('Dream Money는 아직 $label 기능을 제공하지 않아요.'),
          findsOneWidget,
        );
        await tester.tap(find.text(confirmation));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      }
      expect(await snapshot(container), before);
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('홈'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('가상 잔고 · 실제 금융 자산이 아니에요.'), findsOneWidget);
    },
  );

  testWidgets(
    'rapid requests open only one popup, with barrier and system-back dismissal',
    (tester) async {
      final container = testContainer();
      addTearDown(container.dispose);
      await openAccount(tester, container);
      final deposit = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, '입금'),
      );
      final transfer = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, '송금'),
      );
      deposit.onPressed!();
      transfer.onPressed!();
      deposit.onPressed!();
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(dialogs.first.$2), findsOneWidget);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.widgetWithText(OutlinedButton, '출금'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.widgetWithText(OutlinedButton, '송금'));
      await tester.pumpAndSettle();
      expect(find.text(dialogs.last.$2), findsOneWidget);
      await tester.tap(find.text(dialogs.last.$3));
      await tester.pumpAndSettle();
    },
  );

  testWidgets('account and all dialogs remain usable at 320px and 2x text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final container = testContainer();
    addTearDown(container.dispose);
    await openAccount(tester, container);
    expect(find.byType(AccountActions), findsOneWidget);
    for (final (label, title, confirmation) in dialogs) {
      final button = find.widgetWithText(OutlinedButton, label);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
      await tester.ensureVisible(find.text(confirmation));
      await tester.tap(find.text(confirmation));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    await tester.ensureVisible(find.text('계좌 설정 수정'));
    expect(tester.takeException(), isNull);
  });
}
