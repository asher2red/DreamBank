import 'package:dreambank/app/app.dart';

import 'support/test_app.dart';

import 'package:dreambank/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('four tabs, root detail, back and unknown route', (tester) async {
    final container = testContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const DreamBankApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('잠시, 마음에\n여유를 주세요.'), findsOneWidget);
    for (final label in ['꿈 보관함', '미래의 편지', '내 계좌']) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        container.read(routerProvider).routeInformationProvider.value.uri.path,
        {'꿈 보관함': '/dreams', '미래의 편지': '/letters', '내 계좌': '/account'}[label],
      );
    }
    await tester.ensureVisible(find.text('DreamBank 소개'));
    await tester.tap(find.text('DreamBank 소개'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('잠시 쉬어갈 수 있는 가상의 은행'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();
    expect(find.text('페이지를 찾을 수 없어요'), findsOneWidget);
    await tester.tap(find.text('홈으로 이동'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('home scroll offset survives switching branches', (tester) async {
    final container = testContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const DreamBankApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -450),
    );
    await tester.pumpAndSettle();
    final before = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;
    expect(before, greaterThan(0));
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('꿈 보관함'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('홈')),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels,
      before,
    );
  });

  for (final width in [320.0, 430.0, 800.0]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('all tabs at width $width and text scale $scale', (
        tester,
      ) async {
        final container = testContainer();
        addTearDown(container.dispose);
        tester.view.physicalSize = Size(width, 740);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const DreamBankApp(),
          ),
        );
        await tester.pumpAndSettle();
        for (final label in ['꿈 보관함', '미래의 편지', '내 계좌', '홈']) {
          await tester.tap(
            find.descendant(
              of: find.byType(NavigationBar),
              matching: find.text(label),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        await tester.ensureVisible(find.text('꿈 보관함 둘러보기'));
        await tester.tap(find.text('꿈 보관함 둘러보기'));
        await tester.pumpAndSettle();
        expect(find.text('당신의 꿈이 머물 자리를 준비해요'), findsOneWidget);
      });
    }
  }
}
