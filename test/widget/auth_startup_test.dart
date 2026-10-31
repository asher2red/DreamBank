import 'dart:async';

import 'package:dreambank/app/app.dart';
import 'package:dreambank/app/router.dart';
import 'package:dreambank/features/auth/auth_service.dart';
import 'package:dreambank/features/auth/guest_session.dart';
import 'package:dreambank/data/storage_providers.dart';
import 'package:dreambank/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

void main() {
  testWidgets(
    'startup blocks account routes, then opens home; logout locks app again',
    (tester) async {
      final events = StreamController<LoginProfile?>.broadcast();
      final container = testContainer(profiles: () => events.stream);
      addTearDown(container.dispose);
      addTearDown(() {
        unawaited(events.close());
      });
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DreamBankApp(),
        ),
      );
      await tester.pump();
      expect(find.byType(NavigationBar), findsNothing);
      events.add(null);
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Google로 계속하기'), findsOneWidget);
      expect(find.text('Apple로 계속하기'), findsOneWidget);
      container.read(routerProvider).go('/account/edit');
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('계좌 설정 저장'), findsNothing);
      events.add(const LoginProfile('uid', '사용자', null));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(
        container.read(routerProvider).routeInformationProvider.value.uri.path,
        '/home',
      );
      events.add(null);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Google로 계속하기'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
    },
  );
  testWidgets('missing configuration still shows login choices at startup', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: DreamBankApp()));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
    await tester.scrollUntilVisible(find.text('Google로 계속하기'), 180);
    await tester.tap(find.text('Google로 계속하기'));
    await tester.pumpAndSettle();
    expect(find.textContaining('로그인 서비스 연결을 준비'), findsWidgets);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'guest enters home without Firebase and exits without deleting local data',
    (tester) async {
      final container = testContainer(profiles: () => Stream.value(null));
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DreamBankApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('게스트로 시작하기'), 200);
      await tester.tap(find.text('게스트로 시작하기'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(container.read(guestSessionProvider), isTrue);
      expect(container.read(loginProfileProvider).asData?.value, isNull);
      final original = await container.read(accountRepositoryProvider).get();
      container.read(routerProvider).go('/account/login');
      await tester.pumpAndSettle();
      expect(find.text('게스트로 이용 중이에요'), findsOneWidget);
      expect(find.text('내 계정 ID'), findsNothing);
      await tester.scrollUntilVisible(find.text('게스트 이용 종료'), 200);
      await tester.tap(find.text('게스트 이용 종료'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      expect(container.read(guestSessionProvider), isFalse);
      expect(await container.read(accountRepositoryProvider).get(), original);
    },
  );
  testWidgets(
    'verified sign-in replaces guest access and signout does not retain it',
    (tester) async {
      final events = StreamController<LoginProfile?>.broadcast();
      final container = testContainer(profiles: () => events.stream);
      addTearDown(() {
        container.dispose();
        unawaited(events.close());
      });
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const DreamBankApp(),
        ),
      );
      await tester.pumpAndSettle();
      events.add(null);
      await tester.pumpAndSettle();
      container.read(guestSessionProvider.notifier).start();
      await tester.pumpAndSettle();
      events.add(const LoginProfile('real-user', '사용자', null));
      await tester.pumpAndSettle();
      expect(container.read(guestSessionProvider), isFalse);
      expect(find.byType(NavigationBar), findsOneWidget);
      events.add(null);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
    },
  );
}
