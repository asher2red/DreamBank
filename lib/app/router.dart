import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/auth_service.dart';
import '../features/auth/guest_session.dart';
import '../core/widgets/app_shell.dart';
import '../core/widgets/app_state_view.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/dream_vault/presentation/dream_vault_screen.dart';
import '../features/letters/presentation/letters_screen.dart';
import '../features/account/presentation/account_screen.dart';
import '../features/account/presentation/about_screen.dart';
import '../features/account/presentation/account_edit_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/home',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('DreamBank')),
      body: AppStateView(
        icon: Icons.explore_outlined,
        title: '페이지를 찾을 수 없어요',
        message: '홈에서 다시 시작해 주세요.',
        actionLabel: '홈으로 이동',
        onAction: () => context.go('/home'),
      ),
    ),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dreams',
                builder: (_, _) => const DreamVaultScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/letters',
                builder: (_, _) => const LettersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (_, _) => const AccountScreen(),
                routes: [
                  GoRoute(
                    path: 'login',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const LoginScreen(),
                  ),
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const AccountEditScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const AboutScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.listen(loginProfileProvider, (previous, next) {
    if (next is AsyncData<LoginProfile?> &&
        previous?.asData?.value?.uid != next.value?.uid) {
      if (next.value != null) {
        ref.read(guestSessionProvider.notifier).end();
      }
      router.go('/home');
    }
  });
  ref.listen(guestSessionProvider, (previous, next) {
    if (previous != next) router.go('/home');
  });
  ref.onDispose(router.dispose);
  return router;
});
