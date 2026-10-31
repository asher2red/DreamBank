import 'dart:async';

import 'package:dreambank/features/auth/auth_service.dart';

import '../support/test_app.dart';

import 'package:dreambank/core/errors/storage_failure.dart';

import 'package:dreambank/app/app.dart';
import 'package:dreambank/data/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'startup waits for storage and retry recovers without showing fake balances',
    (tester) async {
      final first = Completer<void>();
      var attempts = 0;
      final container = testContainer(
        initialization: (ref) {
          attempts++;
          return attempts == 1
              ? first.future
              : ref.read(accountRepositoryProvider).ensureDefault();
        },
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DreamBankApp(),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      first.completeError(StateError('private text must never be rendered'));
      await tester.pumpAndSettle();
      expect(find.text('계좌를 불러오지 못했어요'), findsOneWidget);
      expect(find.textContaining('private text'), findsNothing);
      await tester.tap(find.text('다시 시도'));
      await tester.pumpAndSettle();
      expect(attempts, 2);
      expect(find.byType(NavigationBar), findsOneWidget);
    },
  );
  testWidgets(
    'incompatible database error is readable on a small screen with large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loginProfileProvider.overrideWith(
              (ref) =>
                  Stream.value(const LoginProfile("test-user", "테스트", null)),
            ),
            storageReadyProvider.overrideWith(
              (ref) async =>
                  throw const StorageFailure(StorageFailureKind.incompatible),
            ),
          ],
          child: const DreamBankApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('현재 앱에서 읽을 수 없는 기록이에요'), findsOneWidget);
      await tester.ensureVisible(find.text('다시 시도'));
      expect(tester.takeException(), isNull);
    },
  );
}
