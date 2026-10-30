import 'package:dreambank/app/app.dart';
import 'package:dreambank/data/repositories/account_repository.dart';
import 'package:dreambank/core/errors/storage_failure.dart';
import 'package:dreambank/data/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

Future<void> tapText(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label));
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

class FailingAccount extends AccountRepository {
  FailingAccount(super.db);
  bool fail = true;
  @override
  Future<void> update({String? nickname, int? balance}) async {
    if (fail) throw const StorageFailure(StorageFailureKind.write);
    await super.update(nickname: nickname, balance: balance);
  }
}

void main() {
  testWidgets(
    'default balance, mood selection, message change and account editing',
    (tester) async {
      final container = testContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DreamBankApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('₩1,000,000,000'), findsOneWidget);
      await tapText(tester, '다른 메시지');
      await tapText(tester, '조금 지쳤어요.');
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '조금 지쳤어요.'))
            .selected,
        true,
      );
      expect(
        (await container.read(moodRepositoryProvider).latest())!.moodType,
        'tired',
      );
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
        '퇴사 허가 통장',
      );
      await tester.enterText(
        find.byKey(const ValueKey('balance-input')),
        '2,000,000,000',
      );
      await tapText(tester, '계좌 설정 저장');
      expect(find.text('퇴사 허가 통장'), findsOneWidget);
      expect(find.text('₩2,000,000,000'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('홈'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('₩2,000,000,000'), findsOneWidget);
    },
  );

  testWidgets(
    'account validation keeps input and unsaved changes require confirmation',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final container = testContainer();
      addTearDown(container.dispose);
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
      await tapText(tester, '계좌 설정 수정');
      await tester.enterText(find.byKey(const ValueKey('nickname-input')), '');
      await tester.enterText(
        find.byKey(const ValueKey('balance-input')),
        '1,00',
      );
      await tapText(tester, '계좌 설정 저장');
      expect(find.text('계좌 이름을 1~30자로 입력해 주세요.'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('작성을 그만둘까요?'), findsOneWidget);
      await tapText(tester, '계속 작성');
      expect(find.byKey(const ValueKey('balance-input')), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tapText(tester, '버리기');
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(
        (await container.read(accountRepositoryProvider).get()).virtualBalance,
        1000000000,
      );
    },
  );

  testWidgets(
    'notice save failure leaves app usable and retry persists acknowledgement',
    (tester) async {
      final settings = MemorySettings(completed: false)..failWrite = true;
      final container = testContainer(settings: settings);
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DreamBankApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tapText(tester, '안내 확인');
      expect(find.textContaining('안내 확인을 저장하지 못했어요.'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      settings.failWrite = false;
      await tapText(tester, '안내 확인');
      expect(find.text('안내 확인'), findsNothing);
      expect(
        (await container.read(settingsRepositoryProvider).read())
            .onboardingCompleted,
        true,
      );
    },
  );
  testWidgets('failed account write keeps the form and retries successfully', (
    tester,
  ) async {
    late FailingAccount repository;
    final container = testContainer(
      account: (db) => repository = FailingAccount(db),
    );
    addTearDown(container.dispose);
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
    await tapText(tester, '계좌 설정 수정');
    await tester.enterText(
      find.byKey(const ValueKey('nickname-input')),
      '실패해도 남는 입력',
    );
    await tapText(tester, '계좌 설정 저장');
    expect(find.textContaining('계좌 설정을 저장하지 못했어요.'), findsOneWidget);
    expect(find.text('실패해도 남는 입력'), findsOneWidget);
    expect((await repository.get()).accountNickname, '나의 여유 계좌');
    repository.fail = false;
    await tapText(tester, '계좌 설정 저장');
    expect(find.byType(NavigationBar), findsOneWidget);
    expect((await repository.get()).accountNickname, '실패해도 남는 입력');
  });
}
