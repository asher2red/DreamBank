import 'package:dreambank/main.dart' as app;
import 'package:dreambank/data/storage_providers.dart';
import 'package:dreambank/features/home/presentation/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dreambank/features/auth/login_screen.dart';
import 'package:dreambank/features/account/presentation/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'native startup offers guest access and preserves the local account',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      await tester.scrollUntilVisible(find.text('Google로 계속하기'), 200);
      await tester.tap(find.text('Google로 계속하기'));
      await tester.pumpAndSettle();
      expect(find.textContaining('로그인 서비스 연결을 준비'), findsWidgets);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.scrollUntilVisible(find.text('게스트로 시작하기'), 200);
      await tester.tap(find.text('게스트로 시작하기'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(HomeScreen)),
      );
      final original = await container.read(accountRepositoryProvider).get();
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('내 계좌'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('DreamBank 계정'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(AccountScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('DreamBank 계정'));
      await tester.pumpAndSettle();
      expect(find.text('게스트로 이용 중이에요'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('게스트 이용 종료'), 200);
      await tester.tap(find.text('게스트 이용 종료'));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsNothing);
      expect(await container.read(accountRepositoryProvider).get(), original);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );
}
