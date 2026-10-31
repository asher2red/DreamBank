import 'dart:async';

import 'package:dreambank/features/auth/auth_service.dart';
import 'package:dreambank/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuth implements AuthService {
  final events = StreamController<LoginProfile?>.broadcast();
  final pending = Completer<void>();
  int calls = 0;
  LoginMethod? lastMethod;
  LoginFailure? failure;
  @override
  Stream<LoginProfile?> get changes async* {
    yield null;
    yield* events.stream;
  }

  @override
  Future<void> signIn(LoginMethod method) async {
    calls++;
    lastMethod = method;
    if (failure != null) throw failure!;
    await pending.future;
    events.add(const LoginProfile('stable-uid', '테스터', null));
  }

  @override
  Future<void> signOut() async {
    events.add(null);
  }
}

void main() {
  testWidgets('configuration missing leaves app usable with retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('로그인 서비스 연결을 준비'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
    expect(find.text('Google로 계속하기'), findsOneWidget);
  });
  testWidgets('both providers, duplicate guard, identity and signout', (
    tester,
  ) async {
    final auth = FakeAuth();
    addTearDown(auth.events.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWith((ref) async => auth)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Apple로 계속하기'), findsOneWidget);
    await tester.tap(find.text('Google로 계속하기'));
    await tester.pump();
    await tester.tap(find.text('Google로 계속하기'));
    expect(auth.calls, 1);
    expect(auth.lastMethod, LoginMethod.google);
    auth.pending.complete();
    await tester.pumpAndSettle();
    expect(find.text('stable-uid'), findsOneWidget);
    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();
    expect(find.text('Google로 계속하기'), findsOneWidget);
  });
  testWidgets('cancel is quiet; failure is shown without raw details', (
    tester,
  ) async {
    final auth = FakeAuth()
      ..failure = const LoginFailure('취소', cancelled: true);
    addTearDown(auth.events.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWith((ref) async => auth)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apple로 계속하기'));
    await tester.pumpAndSettle();
    expect(find.text('취소'), findsNothing);
    expect(auth.lastMethod, LoginMethod.apple);
    auth.failure = const LoginFailure('인터넷 연결을 확인해 주세요.');
    await tester.tap(find.text('Google로 계속하기'));
    await tester.pumpAndSettle();
    expect(find.text('인터넷 연결을 확인해 주세요.'), findsOneWidget);
  });
  testWidgets('restored identity fits small screens with enlarged text', (
    tester,
  ) async {
    final auth = FakeAuth();
    addTearDown(auth.events.close);
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWith((ref) async => auth),
          loginProfileProvider.overrideWith(
            (ref) => Stream.value(
              const LoginProfile('restored-uid', '반가운 사용자', null),
            ),
          ),
        ],
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('restored-uid'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('restored-uid'), findsOneWidget);
    expect(find.text('Google로 계속하기'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
